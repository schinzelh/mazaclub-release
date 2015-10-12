# setup build-config.sh for export/import of common variables
if [[ $# -gt 0 ]]; then
  echo "#!/bin/bash" > build-config.sh
  echo "OS=$3"
  echo "export OS=$3" >> build-config.sh
  export VERSION=$1
  echo "export VERSION=$1" >> build-config.sh
  export TYPE=${2:-tagged}
  echo "export TYPE=${2:-tagged}" >> build-config.sh
  export FILENAME=Electrum-GRS-$VERSION.zip
  echo "export FILENAME=Electrum-GRS-$VERSION.zip" >> build-config.sh
  export TARGETPATH=$(pwd)/source/$FILENAME
  echo "export TARGETPATH=$(pwd)/source/$FILENAME" >> build-config.sh
  export TARGETFOLDER=$(pwd)/source/Electrum-GRS-$VERSION
  echo "export TARGETFOLDER=$(pwd)/source/Electrum-GRS-$VERSION" >> build-config.sh
  echo "Building Electrum-GRS $VERSION from $FILENAME"
else
  echo "Usage: ./build <version>."
  echo "For example: ./build 1.9.8"
  exit
fi

# ensure docker is installed
source helpers/build-common.sh
source helpers/build-config.sh
if [[ -z "$DOCKERBIN" ]]; then
        echo "Could not find docker binary, exiting"
        exit
else
        echo "Using docker at $DOCKERBIN"
fi

# make sure production builds are clean
if [ "${TYPE}" = "rc" -o "${TYPE}" = "SIGNED" ]
then 
   ./clean.sh all
fi
