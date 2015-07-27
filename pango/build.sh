#!/bin/bash
./configure --prefix=$PREFIX --with-dynamic-modules=no --with-included-modules=yes
make -j
make install
