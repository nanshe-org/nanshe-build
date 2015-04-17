#!/bin/sh
#export LAPACK=$PREFIX/lib/liblapack.so
#export BLAS=$PREFIX/lib/libf77blas.so
#export ATLAS=$PREFIX/lib/libatlas.so

# Depending on our platform, shared libraries end with either .so or .dylib
if [[ `uname` == 'Darwin' ]]; then
    DYLIB_EXT=dylib
else
    DYLIB_EXT=so
fi

export LAPACK=$PREFIX/lib/libopenblas.$DYLIB_EXT
export BLAS=$PREFIX/lib/libopenblas.$DYLIB_EXT

test -f $LAPACK
test -f $BLAS
#test -f $ATLAS

#export BLAS=None
#export LAPACK=None
#export ATLAS=None

unset LDFLAGS

#LDFLAGS="${LDFLAGS} -lpython2.7 -c" $PYTHON setup.py install
$PYTHON setup.py install

