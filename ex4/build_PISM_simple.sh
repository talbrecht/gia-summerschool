#!/bin/bash


# https://www.pism.io/docs/installation/index.html

git clone https://github.com/pism/pism.git pism2.0.6
cd pism2.0.6
PISMDIR=$PWD
mkdir build && cd build

#adjust path!
export PETSC_DIR=~/Applications/petsc-3.12.4
export PETSC_ARCH=linux-gnu-opt

export CC=mpicc
export CXX=mpicxx
cmake -DCMAKE_INSTALL_PREFIX=$PISMDIR ..
make install
make test
