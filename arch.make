#
# Copyright (C) 1996-2016 The SIESTA group
#  This file is distributed under the terms of the
#  GNU General Public License: see COPYING in the top directory
#  or http://www.gnu.org/copyleft/gpl.txt.
# See Docs/Contributors.txt for a list of contributors.
#
#-------------------------------------------------------------------
# arch.make file for gfortran compiler.
# To use this arch.make file you should rename it to
# arch.make
# or make a sym-link.
# For an explanation of the flags see DOCUMENTED-TEMPLATE.make

.SUFFIXES:
.SUFFIXES: .f .F .o .c .a .f90 .F90

SIESTA_ARCH = x86_64_MPI

INSDIR = /home/kfm/Programs

CC = mpicc
FPP = $(FC) -E -P -x c
FC = mpif90
FC_SERIAL = gfortran

# MPI setup
MPI_INTERFACE = libmpi_f90.a
MPI_INCLUDE = .

FFLAGS = -O3 -fPIC -ftree-vectorize -march=native

AR = ar
RANLIB = ranlib

SYS = nag

SP_KIND = 4
DP_KIND = 8
KINDS = $(SP_KIND) $(DP_KIND)

LDFLAGS =
INCFLAGS=
COMP_LIBS =
LIBS =

FPPFLAGS = $(DEFS_PREFIX)-DFC_HAVE_ABORT -DSIESTA__WANNIER90

# MPI requirement:
FPPFLAGS += -DMPI

# flook
INCFLAGS += -I/home/kfm/Programs/siesta/Docs/build/flook/0.8.1/include
LDFLAGS += -L/home/kfm/Programs/siesta/Docs/build/flook/0.8.1/lib -Wl,-rpath,/home/kfm/Programs/siesta/Docs/build/flook/0.8.1/lib
LIBS += -lflookall -ldl
COMP_LIBS += libfdict.a
FPPFLAGS += -DSIESTA__FLOOK

# netcdf
INCFLAGS += -I/home/kfm/Programs/siesta/Docs/build/include
LDFLAGS += -L/home/kfm/Programs/siesta/Docs/build/lib -Wl,-rpath,/home/kfm/Programs/siesta/Docs/build/lib
LIBS += -lnetcdff -lnetcdf -lhdf5_hl -lhdf5 -lz
COMP_LIBS += libncdf.a libfdict.a
FPPFLAGS += -DCDF -DNCDF -DNCDF_4

# openblas
LDFLAGS += -L$(INSDIR)/openblas/lib -Wl,-rpath=$(INSDIR)/openblas/lib
LIBS += -lopenblas_nonthreaded

# ScaLAPACK (required only for MPI build)
LDFLAGS += -L$(INSDIR)/scalapack/scalapack-2.1.0 -Wl,-rpath=$(INSDIR)/scalapack/scalapack-2.1.0
LIBS += -lscalapack

# Wannier90
WANNIER90_ROOT = $(INSDIR)/wannier90/call-from-siesta
WANNIER90_INCFLAGS = -I$(WANNIER90_ROOT)/src/objp -I$(WANNIER90_ROOT)/arc/obj
WANNIER90_LIBS = -L$(WANNIER90_ROOT) -lwannier
##DEFS_WANNIER90 = $(DEFS_PREFIX)-DHAVE__WANNIER90
DEFS_WANNIER90 = $(DEFS_PREFIX)-DSIESTA__WANNIER90
INCFLAGS += -I/usr/include -I$(WANNIER90_ROOT)/src/objp -I$(WANNIER90_ROOT)/src/obj

DEFS := $(DEFS_MPI) $(DEFS_CDF) $(DEFS_WANNIER90)
FPPFLAGS += $(DEFS_MPI) $(DEF_CDF) $(DEFS) $(DEFS_WANNIER90)
LIBS += $(WANNIER90_LIBS)

# Dependency rules ---------

FFLAGS_DEBUG = -g -O1

# The atom.f code is very vulnerable. Particularly the Intel compiler
# will make an erroneous compilation of atom.f with high optimization
# levels.
atom.o: atom.F
	$(FC) -c $(FFLAGS_DEBUG) $(INCFLAGS) $(FPPFLAGS) $(FPPFLAGS_fixed_F) $<
.c.o:
	$(CC) -c $(CFLAGS) $(INCFLAGS) $(CPPFLAGS) $<
.F.o:
	$(FC) -c $(FFLAGS) $(INCFLAGS) $(FPPFLAGS) $(FPPFLAGS_fixed_F) $<
.F90.o:
	$(FC) -c $(FFLAGS) $(INCFLAGS) $(FPPFLAGS) $(FPPFLAGS_free_F90) $<
.f.o:
	$(FC) -c $(FFLAGS) $(INCFLAGS) $(FCFLAGS_fixed_f) $<
.f90.o:
	$(FC) -c $(FFLAGS) $(INCFLAGS) $(FCFLAGS_free_f90) $<
