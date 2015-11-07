#!/bin/bash
set -xeo pipefail
source build-config.sh
source helpers/build-common.sh

sign_release () {
         sha1sum ${1} > ${1}.sha1
	 echo "${1} SHA1 Sum:" >>  ${topdir}/Electrum-DASH-${VERSION}.sums
         cat ${1}.sha1 >> ${topdir}/Electrum-DASH-${VERSION}.sums
         md5sum ${1} > ${1}.md5
	 echo "${1} MD5 Sum:" >>  ${topdir}/Electrum-DASH-${VERSION}.sums
         cat ${1}.md5 >> ${topdir}/Electrum-DASH-${VERSION}.sums
         gpg --sign --armor --detach  ${1}
         gpg --sign --armor --detach  ${1}.md5
         gpg --sign --armor --detach  ${1}.sha1
}

  mv $(pwd)/helpers/release-packages/* $(pwd)/releases/
  if [ "${TYPE}" = "SIGNED" ] ; then
    ${DOCKERBIN} push mazaclub/electrum-dash-winbuild:${VERSION}
    ${DOCKERBIN} push mazaclub/electrum-dash-release:${VERSION}
    ${DOCKERBIN} push mazaclub/electrum-dash32-release:${VERSION}
    ${DOCKERBIN} tag -f ogrisel/python-winbuilder mazaclub/python-winbuilder:${VERSION}
    ${DOCKERBIN} push mazaclub/python-winbuilder:${VERSION}
  if [ "${TYPE}" = "rc" ]; then export TYPE=SIGNED ; fi
    topdir=$(pwd)
    test -f Electrum-DASH-${VERSION}.sums && rm  Electrum-DASH-${VERSION}.sums
    cd releases
    for release in * 
    do
      if [ ! -d ${release} ]; then
         sign_release ${release}
      else
         cd ${release}
         for i in * 
         do 
           if [ ! -d ${i} ]; then
              sign_release ${i}
	   fi
         done
         cd ..
      fi
    done
  fi
  gpg --sign --armor --detach Electrum-DASH-${VERSION}.sums
  mv Electrum-DASH-${VERSION}.sums* releases/
  echo "You can find your Electrum-DASHs $VERSION binaries in the releases folder."
