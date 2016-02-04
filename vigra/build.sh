# Get commonly needed env vars
CWD=$(cd `dirname $0` && pwd)
source $CWD/../common-vars.sh

if [[ `uname` == 'Darwin' ]]; then
    VIGRA_CXX_FLAGS="${CXXFLAGS}"
else
    VIGRA_CXX_FLAGS="-pthread ${CXXFLAGS}"
fi

# In release mode, we use -O2 because gcc is known to miscompile certain vigra functionality at the O3 level.
# (This is probably due to inappropriate use of undefined behavior in vigra itself.)
VIGRA_CXX_FLAGS_RELEASE="-O2 -DNDEBUG ${VIGRA_CXX_FLAGS}"
VIGRA_LDFLAGS="${CXX_LDFLAGS} -Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib"

# We like to make builds of vigra from arbitrary git commits (not always tagged).
# Include the git commit in the build version so we remember which one was used for the build.
#echo "g$(git rev-parse --short HEAD)" > __conda_version__.txt

# CONFIGURE
mkdir build
cd build
cmake ..\
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_PREFIX_PATH=${PREFIX} \
\
        -DCMAKE_CXX_LINK_FLAGS="${VIGRA_LDFLAGS}" \
        -DCMAKE_EXE_LINKER_FLAGS="${VIGRA_LDFLAGS}" \
        -DCMAKE_CXX_FLAGS="${VIGRA_CXX_FLAGS}" \
        -DCMAKE_CXX_FLAGS_RELEASE="${VIGRA_CXX_FLAGS_RELEASE}" \
        -DCMAKE_CXX_FLAGS_DEBUG="${VIGRA_CXX_FLAGS}" \
\
        -DWITH_VIGRANUMPY=TRUE \
        -DDEPENDENCY_SEARCH_PREFIX=${PREFIX} \
\
        -DFFTW3F_INCLUDE_DIR=${PREFIX}/include \
        -DFFTW3F_LIBRARY=${PREFIX}/lib/libfftw3f.${DYLIB_EXT} \
        -DFFTW3_INCLUDE_DIR=${PREFIX}/include \
        -DFFTW3_LIBRARY=${PREFIX}/lib/libfftw3.${DYLIB_EXT} \
\
        -DHDF5_CORE_LIBRARY=${PREFIX}/lib/libhdf5.${DYLIB_EXT} \
        -DHDF5_HL_LIBRARY=${PREFIX}/lib/libhdf5_hl.${DYLIB_EXT} \
        -DHDF5_INCLUDE_DIR=${PREFIX}/include \
\
        -DBoost_INCLUDE_DIR=${PREFIX}/include \
        -DBoost_LIBRARY_DIRS=${PREFIX}/lib \
\
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_INCLUDE_PATH=${PREFIX}/include \
\
        -DZLIB_INCLUDE_DIR=${PREFIX}/include \
        -DZLIB_LIBRARY=${PREFIX}/lib/libz.${DYLIB_EXT} \
\
        -DPNG_LIBRARY=${PREFIX}/lib/libpng.${DYLIB_EXT} \
        -DPNG_PNG_INCLUDE_DIR=${PREFIX}/include \
\
        -DTIFF_LIBRARY=${PREFIX}/lib/libtiff.${DYLIB_EXT} \
        -DTIFF_INCLUDE_DIR=${PREFIX}/include \
\
        -DJPEG_INCLUDE_DIR=${PREFIX}/include \
        -DJPEG_LIBRARY=${PREFIX}/lib/libjpeg.${DYLIB_EXT} \


# BUILD (in parallel)
make -j2

# TEST (before install)
# (Since conda hasn't performed its link step yet, we must help the tests locate their dependencies via LD_LIBRARY_PATH)
eval ${LIBRARY_SEARCH_VAR}=$PREFIX/lib make -j2 check

# "install" to the build prefix (conda will relocate these files afterwards)
make install

