CCCOM=g++ -m64 -std=c++17 -fPIC #-O3
MKLROOT=/opt/intel/mkl
PLATFORM=mkl
BLAS_LAPACK_LIBFLAGS=-L$(MKLROOT)/lib/intel64 \
                                         -Wl,-rpath,$(MKLROOT)/lib/intel64 \
                                         -L/opt/intel/tbb/lib/intel64_lin/gcc4.7 \
                                         -Wl,-rpath,/opt/intel/tbb/lib/intel64_lin/gcc4.7 \
                                         -lmkl_rt -lpthread
BLAS_LAPACK_INCLUDEFLAGS=-I$(MKLROOT)/include
OPTIMIZATIONS=-O2 -DNDEBUG -Wall

## Flags to give the compiler for "debug mode"
DEBUGFLAGS=-DDEBUG -g -Wall -pedantic
#
## Set this to 1 if you want ITensor to also build dynamic libraries
## These can be faster to link and give smaller binary sizes
## You may need to set you LD_LIBRARY_PATH to include the ITensor lib/
## folder in order to link with the dynamic libraries
ITENSOR_MAKE_DYLIB=1


###
### Other Makefile variables defined for convenience.
### Not necessary to modify these for most cases.
###

PREFIX=$(THIS_DIR)

ITENSOR_LIBDIR=$(PREFIX)/lib
ITENSOR_INCLUDEDIR=$(PREFIX)

ITENSOR_LIBNAMES=itensor
ITENSOR_LIBFLAGS=$(patsubst %,-l%, $(ITENSOR_LIBNAMES))
ITENSOR_LIBFLAGS+= $(BLAS_LAPACK_LIBFLAGS)
ITENSOR_LIBGFLAGS=$(patsubst %,-l%-g, $(ITENSOR_LIBNAMES))
ITENSOR_LIBGFLAGS+= $(BLAS_LAPACK_LIBFLAGS)
ITENSOR_LIBS=$(patsubst %,$(ITENSOR_LIBDIR)/lib%.a, $(ITENSOR_LIBNAMES))
ITENSOR_GLIBS=$(patsubst %,$(ITENSOR_LIBDIR)/lib%-g.a, $(ITENSOR_LIBNAMES))

ITENSOR_INCLUDEFLAGS=-I'$(ITENSOR_INCLUDEDIR)' $(BLAS_LAPACK_INCLUDEFLAGS)

ifdef HDF5_PREFIX
ITENSOR_USE_HDF5 = 1
ITENSOR_INCLUDEFLAGS += -I$(HDF5_PREFIX)/include -DITENSOR_USE_HDF5
ITENSOR_LIBFLAGS += -L$(HDF5_PREFIX)/lib -lhdf5 -lhdf5_hl
ITENSOR_LIBGFLAGS += -L$(HDF5_PREFIX)/lib -lhdf5 -lhdf5_hl
endif

ifndef CCCOM
$(error Makefile variable CCCOM not defined in options.mk; please define it.)
endif

CCFLAGS=-I. $(ITENSOR_INCLUDEFLAGS) $(OPTIMIZATIONS) -Wno-unused-variable
CCGFLAGS=-I. $(ITENSOR_INCLUDEFLAGS) $(DEBUGFLAGS)
LIBFLAGS=-L'$(ITENSOR_LIBDIR)' $(ITENSOR_LIBFLAGS) -Wl,-rpath,'$(ITENSOR_LIBDIR)'
LIBGFLAGS=-L'$(ITENSOR_LIBDIR)' $(ITENSOR_LIBGFLAGS) -Wl,-rpath,'$(ITENSOR_LIBDIR)'

## Determine shared library extension
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
  DYLIB_EXT ?= dylib
  DYLIB_FLAGS ?= -dynamiclib
else
  DYLIB_EXT ?= so
  DYLIB_FLAGS ?= -shared
endif
