export WORKSPACE="$(dirname "$(realpath "$0")")"
export INSTALL_DIR="$WORKSPACE/install"
export SRC_DIR="$WORKSPACE/src"

export PKG_CONFIG_PATH="$INSTALL_DIR/lib/pkgconfig:$INSTALL_DIR/share/pkgconfig:${PKG_CONFIG_PATH:-}"
export CMAKE_PREFIX_PATH="$INSTALL_DIR:${CMAKE_PREFIX_PATH:-}"
export LD_LIBRARY_PATH="$INSTALL_DIR/lib:$INSTALL_DIR/lib64:${LD_LIBRARY_PATH:-}"
export PATH="$INSTALL_DIR/bin:${PATH:-}"

echo "Environment set for $WORKSPACE"
