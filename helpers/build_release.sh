#!/bin/bash
set -xeo pipefail
source build-config.sh
source helpers/build-common.sh
check_vars
$DOCKERBIN run --rm -it --privileged -e MKPKG_VER=${VERSION} -v $(pwd)/releases:/releases -v $(pwd)/helpers:/root  -v $(pwd)/repo:/root/repo  -v $(pwd)/source:/opt/wine-electrum/drive_c/electrum-grs/ -v $(pwd):/root/electrum-grs-release mazaclub/electrum-grs-release:${VERSION} /root/make_release $VERSION $TYPE 
