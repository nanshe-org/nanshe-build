if [[ `uname` == 'Darwin' ]]; then
    CXXFLAGS="${CXXFLAGS} -stdlib=libc++"
    CXX_LDFLAGS="${LDFLAGS} -stdlib=libc++"
    #CXXFLAGS="${CXXFLAGS}"
    #CXX_LDFLAGS="${LDFLAGS}"
else
    CXXFLAGS="${CXXFLAGS}"
    CXX_LDFLAGS="${LDFLAGS}"
fi

make TARGET=NEHALEM BINARY=64 NO_LAPACK=0
make install PREFIX=$PREFIX
