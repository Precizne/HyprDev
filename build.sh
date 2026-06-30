#!/bin/bash

set -eoux pipefail

#############################
# Path And Environment Setup
#############################
WORKSPACE="$(dirname "$(realpath "$0")")"
INSTALL_DIR="$WORKSPACE/install"
SRC_DIR="$WORKSPACE/src"

mkdir -p "$INSTALL_DIR"

export PKG_CONFIG_PATH="$INSTALL_DIR/lib/pkgconfig:$INSTALL_DIR/share/pkgconfig:${PKG_CONFIG_PATH:-}"
export CMAKE_PREFIX_PATH="$INSTALL_DIR:${CMAKE_PREFIX_PATH:-}"
export LD_LIBRARY_PATH="$INSTALL_DIR/lib:$INSTALL_DIR/lib64:${LD_LIBRARY_PATH:-}"
export PATH="$INSTALL_DIR/bin:${PATH:-}"

echo "Starting local build sequence inside: $WORKSPACE"

###########################
# Submodule Initialization
###########################
echo "=========================================="
echo " Initializing And Updating Git Submodules "
echo "=========================================="
cd "$WORKSPACE"
git submodule update --init --recursive

############################
# Core Compilation Function
############################
build_dependency() {
    DIR_NAME=$2

    echo "==============================================="
    echo " Building Dependency: $DIR_NAME                "
    echo "==============================================="

    cd "$SRC_DIR/$DIR_NAME"

    cmake -S . -B build/ -G Ninja \
        -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

    ninja -C build/
    ninja -C build/ install
}

######################
# Execute Build Order
######################
build_dependency "hyprwayland-scanner"
build_dependency "hyprutils"
build_dependency "hyprgraphics"
build_dependency "hyprcursor"
build_dependency "hyprwire"
build_dependency "hyprland-qtutils"
build_dependency "aquamarine"

######################
# Main Hyprland Build
######################
echo "==================="
echo " Building Hyprland "
echo "==================="

cd "$SRC_DIR/hyprland"

cmake -S . -B build/ -G Ninja \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

ninja -C build/

echo "============================================================"
echo " BUILD COMPLETE SUCCESSFULLY !!!                            "
echo " Nested Binary at: $SRC_DIR/hyprland/build/Hyprland         "
echo "============================================================"
