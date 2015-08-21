#!/bin/sh

# Depending on our platform, shared libraries end with either .so or .dylib
if [[ `uname` == 'Darwin' ]]; then
    DYLIB_EXT=dylib
    CC=clang
    CXX=clang++
else
    DYLIB_EXT=so
    CC=gcc
    CXX=g++
fi

export LAPACK=$PREFIX/lib/libopenblas.$DYLIB_EXT
export BLAS=$PREFIX/lib/libopenblas.$DYLIB_EXT

test -f $LAPACK
test -f $BLAS

unset LDFLAGS

CC=$CC CXX=$CXX $PYTHON setup.py install

