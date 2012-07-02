#                                                                       
# Makefile for building measure-holes
#                                                                     

### Here starts the section for user-configurable macros

## C compiler and options to the same
CC = gcc
CFLAGS = -ansi -Wall -I$(HOME)/include

## Flags for the C compiler during linking phase (in addition to CFLAGS)
LDFLAGS = -N -s -I$(HOME)/lib

## Program to install a group of files into a directory
INSTALL = install

## Program to create a library file (archive of object files)
AR = ar
ARFLAGS = r

## Use : or echo if you don't have or need ranlib
RANLIB = ranlib

## Add here any libraries you need to add when linking these programs
LIBS = -lpub

## The directories to which the executable, documentation, and library
## files are to be installed with `make install'
bindir = /usr/local/bin
docdir = /usr/local/man/man1
libdir = /usr/local/lib

### Configuration section ends

sources = measure-holes.c 
headers = 
allsrcs = $(sources) $(headers)
docs = xxx.1
examples = xxx

distfiles = README Makefile $(docs) $(allsrcs) $(examples)
dist = xxx-1.0

progs = measure-holes
objsxxx = xxx.o

libname = 
libobjs = xxx.o

all: $(libname) $(progs)

measure-holes: measure-holes.o $(libname)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ measure-holes.o $(libname) $(LIBS)

foo $(libname): $(libobjs)
	$(AR) $(ARFLAGS) $(libname) $(libobjs)
	$(RANLIB) $(libname)

zero:
	dd if=/dev/zero of=zero bs=1024 count=1

sources: $(allsrcs)

clean:
	rm -f $(progs) $(libname) core *.o

realclean: clean
	rm -f $(dist).tar.gz

dist:
	mkdir $(dist)
	ln $(distfiles) $(dist)
	tar cf - $(dist) > gzip $(dist).tar.gz
	rm -r $(dist)

install:
	$(INSTALL) $(prog) $(bindir)
	$(INSTALL) $(docs) $(docdir)

depend .depend:
	$(CC) -MM *.c > .depend
include .depend
