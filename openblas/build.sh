if [[ `uname` == 'Darwin' ]]; then
    CXXFLAGS="${CXXFLAGS} -stdlib=libc++"
    CXX_LDFLAGS="${LDFLAGS} -stdlib=libc++"
    #CXXFLAGS="${CXXFLAGS}"
    #CXX_LDFLAGS="${LDFLAGS}"
else
    CXXFLAGS="${CXXFLAGS}"
    CXX_LDFLAGS="${LDFLAGS}"
fi

make TARGET=NEHALEM BINARY=64 NO_LAPACK=0 NO_AFFINITY=1 NUM_THREADS=1 -j${CPU_COUNT}
make install PREFIX=$PREFIX
