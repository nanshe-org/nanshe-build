#!/usr/bin/env bash
# inspired by build script for Arch Linux fftw pacakge:
# https://projects.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD?h=packages/fftw

# Get commonly needed env vars
CWD=$(cd `dirname $0` && pwd)
source $CWD/../common-vars.sh

# Depending on our platform, shared libraries end with either .so or .dylib
if [[ `uname` == 'Darwin' ]]; then
    export DYLIB_EXT=dylib
    export CC=clang
    export CXX=clang++
else
    export DYLIB_EXT=so
    export CC=gcc
    export CXX=g++
fi

export LDFLAGS="-L${PREFIX}/lib"
export CFLAGS="${CFLAGS} -I${PREFIX}/include"

CONFIGURE="./configure --prefix=$PREFIX --enable-shared --enable-threads --disable-fortran"

# (Note exported LDFLAGS and CFLAGS vars provided above.)
BUILD_CMD="make -j${CPU_COUNT}"
INSTALL_CMD="make install"

# Test suite
# tests are performed during building as they are not available in the
# installed package.
# Additional tests can be run with "make smallcheck" and "make bigcheck"
TEST_CMD="eval cd tests && ${LIBRARY_SEARCH_VAR}=\"$PREFIX/lib\" make check-local && cd -"

#
# We build 3 different versions of fftw:
#

# (1) Single precision (fftw libraries have "f" suffix)
$CONFIGURE --enable-float --enable-sse
${BUILD_CMD}
${INSTALL_CMD}
${TEST_CMD}

# (2) Long double precision (fftw libraries have "l" suffix)
$CONFIGURE --enable-long-double
${BUILD_CMD}
${INSTALL_CMD}
${TEST_CMD}

# (3) Double precision (fftw libraries have no precision suffix)
$CONFIGURE --enable-sse2
${BUILD_CMD}
${INSTALL_CMD}
${TEST_CMD}

unset DYLIB_EXT
unset CC
unset CXX
unset LDFLAGS
unset CFLAGS
