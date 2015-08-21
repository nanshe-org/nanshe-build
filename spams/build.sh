# Get commonly needed env vars
CWD=$(cd `dirname $0` && pwd)
source $CWD/../common-vars.sh

# Grab the right gcc/g++ from the path.
GCC=$PREFIX/bin/gcc
GXX=$PREFIX/bin/g++

# Set include path if it is missing.
if [ -n $INCLUDE_PATH ] ;
then
    INCLUDE_PATH=$PREFIX/include
fi
# Set library path if it is missing.
if [ -n $LIBRARY_PATH ] ;
then
    LIBRARY_PATH=$PREFIX/lib
fi

# CONFIGURE
cd $SRC_DIR

# BUILD (in parallel)
eval CC=$GCC CXX=$GXX INCLUDE_PATH=$INCLUDE_PATH LIBRARY_PATH=$LIBRARY_PATH ${LIBRARY_SEARCH_VAR}=$PREFIX/lib ${PYTHON} setup.py build

# "install" to the build prefix (conda will relocate these files afterwards)
eval CC=$GCC CXX=$GXX INCLUDE_PATH=$INCLUDE_PATH LIBRARY_PATH=$LIBRARY_PATH ${LIBRARY_SEARCH_VAR}=$PREFIX/lib ${PYTHON} setup.py install --prefix=$PREFIX
