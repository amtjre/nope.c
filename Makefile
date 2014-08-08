#!/bin/make

ifdef THREADS
	PTHREAD=-D NOPE_THREADS=$(THREADS) -pthread
endif

ifdef DEBUG
	DEBUG_OPT=-D NOPE_DEBUG -ggdb
endif

ifdef PROCESSES
	PROCESSES_OPT=-D NOPE_PROCESSES=$(PROCESSES) -ggdb
endif

ifdef LOOP
	ifeq ($(LOOP),epoll) 
		LOOP_OPT=-D NOPE_EPOLL
	endif	
endif

EXT_OPTIONS=$(PTHREAD) $(DEBUG_OPT) $(PROCESSES_OPT) $(LOOP_OPT)

CC=gcc
AR=ar
CFLAGS=-W -Wall -O2 -Wno-unused-parameter -g $(EXT_OPTIONS)
LIBNOPE_OBJ=nope.o nopeutils.o
LIBNOPE=libnope.a
MODULES=server factor

all: $(MODULES)

# rule to build modules
%: %.c $(LIBNOPE)
	$(CC) $(EXT_OPTIONS) $(CFLAGS) -o $@ $^

$(LIBNOPE): $(LIBNOPE_OBJ)
	$(AR) r $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(LIBNOPE_OBJ)

distclean:
	rm -f $(LIBNOPE) $(LIBNOPE_OBJ) $(MODULES)

