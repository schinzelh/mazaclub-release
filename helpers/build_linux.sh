#!/bin/bash 
source helpers/build-common.sh
source build-config.sh
check_vars

$DOCKERBIN run --rm -it --privileged -e MKPKG_VER=${VERSION} -v $(pwd)/helpers:/root  -v $(pwd)/repo:/root/repo  -v $(pwd)/source:/opt/wine-electrum/drive_c/electrum-grs/ -v $(pwd):/root/electrum-grs-release mazaclub/electrum-grs-release:${VERSION} /root/make_linux ${VERSION}

