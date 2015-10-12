#!/bin/bash -l
source helpers/build-common.sh
set -xeo pipefail
./make_requirements_txt.sh
if [ -f /.dockerenv ] ; then
 #running the build from within a docker container
 echo "Building from within Docker - YMMV"
 touch .DIND
fi
# Main script
OS=$(echo $0|awk -F "/" '{print $2}')
VERSION="$1"
TYPE="$2"

echo "RUNNING CONFIG ${VERSION} ${TYPE} ${OS}"

config ${VERSION} ${TYPE} ${OS} \
 && prep_deps \
 && buildRelease \
 && pick_build 
# Build release, binaries, and packages
if [[ $? = 0 ]]; then
    echo "Build successful."
else
  echo "Seems like the build failed. Exiting."
  exit 42
fi

# move completed builds from helpers/release-packages to releases/
# sum and sign the binaries, zipfiles, and tarballs
completeReleasePackage ${OS}
echo "End."
