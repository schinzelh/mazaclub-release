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
BUILD_CMD="$0 $1 $2 $3"
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
mv Electrum-DASH-${VERSION}.sums releases/
# this is done here so we don't run this by hand on manual builds
# get all git URI/commits for build system & product 
# show config & build command line
# add it all to the .sums file and gpg sign it
echo "BUILD COMMAND: ${BUILD_CMD}"  >> releases/Electrum-DASH-${VERSION}.sums
echo "BUILD SYSTEM ==================="  >> releases/Electrum-DASH-${VERSION}.sums
echo "Built with $(grep -i url .git/config)" >> releases/Electrum-DASH-${VERSION}.sums
echo "Build system commit: $(git rev-parse HEAD  --short)" >>  releases/Electrum-DASH-${VERSION}.sums
echo "git diff: $(git diff)" >>  releases/Electrum-DASH-${VERSION}.sums
echo "PRODUCT CODE ===================" >>  releases/Electrum-DASH-${VERSION}.sums
echo "Built from $(grep -i url repo/.git/config)" >> releases/Electrum-DASH-${VERSION}.sums
echo "Built from commit $(cd repo ; git rev-parse HEAD  --short)" >>  releases/Electrum-DASH-${VERSION}.sums
echo "git diff: $(cd repo ; git diff)" >>  releases/Electrum-DASH-${VERSION}.sums
echo "BUILD CONFIG ==================="  >> releases/Electrum-DASH-${VERSION}.sums
echo "build-config.sh:" >> releases/Electrum-DASH-${VERSION}.sums
echo " " >> releases/Electrum-DASH-${VERSION}.sums
cat helpers/build-config.sh >> releases/Electrum-DASH-${VERSION}.sums
### sign the sums file if this is a public release
if [ "${TYPE}" = "rc" ] ; then
   export TYPE="SIGNED"
fi
if [ "${TYPE}" = "SIGNED" ] ; then 
   gpg --output releases/Electrum-DASH-${VERSION}.sums.asc --sign -armor --detach  releases/Electrum-DASH-${VERSION}.sums
fi


echo "End."
