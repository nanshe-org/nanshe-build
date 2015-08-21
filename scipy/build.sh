#!/bin/sh


unset LDFLAGS

$PYTHON setup.py install


# Make sure the linked gfortran libraries are searched for on the RPATH.
if [[ `uname` == 'Darwin' ]]; then
    GCC_LIB=$(python -c "from os.path import realpath; print(realpath(\"$(gfortran -print-file-name=libgcc_s.1.dylib)\"))")

    for EACH_FILE in `find ${SP_DIR}/scipy -name "*.so"`;
    do
        install_name_tool -change $GCC_LIB @rpath/libgcc_s.1.dylib $EACH_FILE
    done
fi
