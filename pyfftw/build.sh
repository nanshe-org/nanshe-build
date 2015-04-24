#!/usr/bin/env bash

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

export C_INCLUDE_PATH=$PREFIX/include  # required as fftw3.h installed here
CC=$CC CXX=$CXX $PYTHON setup.py build
CC=$CC CXX=$CXX $PYTHON setup.py install --optimize=1
