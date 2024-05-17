#!bin/bash

git clone https://github.com/gcc-mirror/gcc.git
cd gcc
git checkout releases/gcc-12.2.0
./contrib/download_prerequisites
mkdir build
cd build
../configure --prefix=$PWD --enable-languages=c,c++,fortran,go --disable-multilib
make -j
make install

# Manually run following commands to add it to path
# export PATH=/home/psharma/iTensor/gcc/build/bin:$PATH
#export LD_LIBRARY_PATH=/home/psharma/iTensor/gcc/build/lib64:$LD_LIBRARY_PATH

#Make sure MKL is installed and MKLROOT is defined
check using echo $(MKLROOT)

#install iTensor and configure it
git clone https://github.com/ITensor/ITensor.git
cd ITensor
cp options.mk.sample options.mk
vi options.mk
edit : 
	MKLROOT=/opt/intel/mkl
	PLATFORM=mkl                                                                                                                                               
 BLAS_LAPACK_LIBFLAGS=-L$(MKLROOT)/lib/intel64 \                                                                                                                                                  
 	-Wl,-rpath,$(MKLROOT)/lib/intel64 \                                                                                                                      
  	-L/opt/intel/tbb/lib/intel64_lin/gcc4.7 \                                                                                                                 
  	-Wl,-rpath,/opt/intel/tbb/lib/intel64_lin/gcc4.7 \                                                                                                       
  	-lmkl_rt -lpthread#/opt/intel/tbb/lib/intel64_lin/gcc4.7/libtbb.so.2 /opt/intel/tbb/lib/intel64_lin/gcc4.7/libtbbmalloc.so.2 -lpthread -lm -ldl       

#add following command to .bashrc
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/psharma/ITensor/lib

