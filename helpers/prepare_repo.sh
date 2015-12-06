#!/bin/bash
set -xeo pipefail
source build-config.sh
source helpers/build-common.sh

check_vars 

check_local(){
if [ ${TYPE} = "local" ]
then
  echo "Setting up Local build"
  test -d repo || mkdir -pv repo
  sudo tar -C ../../ -cpv --exclude=contrib/* . |sudo  tar -C repo -xpf -
fi  
}
check_ver () { 
 export gitver=$(grep "ELECTRUM_VERSION" lib/version.py |awk '{print $3}' |cut  -d"\"" -f2)
  if [ "${VERSION}" != "${gitver}" ]
  then
      sed -i 's/ELECTRUM_VERSION\ \=\ \"'${gitver}'\"/ELECTRUM_VERSION\ \=\ \"'${VERSION}'\"/g' lib/version.py
  fi
}


localdie () {
case $1 in
 1) echo "Build Error:" 
   echo "Build Version: ${VERSION} and git Version: ${gitver} don't match"
   echo "Bump version or build from master with  ./build ${VERSION} master"
   exit 1
   ;;
 2) echo "git checkout failed" 
    echo "Didnt find TAG for ${VERSION}"
    exit 2
    ;;
 3) echo "setup.py not found in /root/repo"
    echo "maybe your source dir was empty?"
    exit 3
    ;;
 *) echo "ERROR: die called exit $1"
    exit "$1"
    ;;
esac
}

check_tags(){
if [ "${TYPE}" = "master" ]                                                                                                                        
then
   echo "building from MASTER" 
   git clone https://github.com/mazaclub/electrum-dash repo
   cd repo
   check_ver
   cd ..
elif [ "${TYPE}" = "local" ] 
then
   cd repo
   test -f setup.py || localdie 3
   echo "Building from local sources as Version ${VERSION}"
   check_ver
   cd ..
elif [ "${TYPE}" = "rc" ]
then 
    git clone https://github.com/mazaclub/electrum-dash repo
    cd repo
    git checkout release/${VERSION} || localdie 2
    check_ver
    cd ..
else 
    echo "Building from Tagged Version: ${VERSION}"
    git clone https://github.com/mazaclub/electrum-dash repo
    cd repo
    git checkout v"${VERSION}" || localdie 2
    cd ..
fi
}
check_local \
  && check_tags \
  && cp -av python-trezor/trezorctl helpers/trezorctl.py \
  && touch prepared
