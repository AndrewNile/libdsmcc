##############################################################
###                                                        ###
### Makefile: local makefile for libsi                     ###
###                                                        ###
##############################################################

## $Revision: 1.1 $
## $Date: 2003/10/22 15:12:04 $
## $Author: rdp123 $
##
##   (C) 2001 Rolf Hakenes <hakenes@hippomi.de>, under the GNU GPL.
##
## dtv_scan is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2, or (at your option)
## any later version.
##
## dtv_scan is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You may have received a copy of the GNU General Public License
## along with dtv_scan; see the file COPYING.  If not, write to the
## Free Software Foundation, Inc., 59 Temple Place - Suite 330,
## Boston, MA 02111-1307, USA.
#
#
#

.DELETE_ON_ERROR:

VERMAJOR = 0
VERMINOR = 7
VERPATCH = 0

VER = $(VERMAJOR).$(VERMINOR).$(VERPATCH)

CC = gcc
CFLAGS ?= -fPIC -g -Wmissing-prototypes -Wstrict-prototypes \
         -DNAPI -Wimplicit -D__USE_FIXED_PROTOTYPES__ # -ansi -pedantic 

LDFLAGS ?= -shared
INCDIRS = -I/usr/src/media_build/linux/dvb
PREFIX ?= /usr/local
ifneq ($(wildcard $(PREFIX)/lib64),)
    DESTDIR ?= $(PREFIX)/lib64
else
    DESTDIR ?= $(PREFIX)/lib
endif
PCDIR  ?= $(DESTDIR)/pkgconfig
MAKEDEPEND = gcc -M

LIBS = -lsi -llx -lz

AR = ar
ARFLAGS = r
RANLIB = ranlib

LIBNAME = libdsmcc
SILIB = $(LIBNAME).a
SILIB_SO = $(LIBNAME).so
OBJS = dsmcc-win32.o dsmcc-receiver.o dsmcc-util.o dsmcc-descriptor.o dsmcc-biop.o dsmcc-carousel.o dsmcc-cache.o dsmcc.o

HEADERS = libdsmcc.h dsmcc-win32.h dsmcc-receiver.h dsmcc-carousel.h dsmcc-biop.h dsmcc-descriptor.h dsmcc-cache.h

all : $(SILIB) $(SILIB_SO).$(VER)

clean :
	@echo cleaning workspace...
	@rm -f $(OBJS) $(SILIB) $(SILIB_SO).$(VER) *~
	@rm -f Makefile.dep

depend : Makefile.dep
Makefile.dep :
	@echo "updating dependencies..."
	@$(MAKEDEPEND) $(INCDIRS) $(OBJS:%.o=%.c) $(SITEST_OBJS:%.o=%.c) \
           $(SISCAN_OBJS:%.o=%.c) > Makefile.dep

new : clean depend all

#dist: all
#	@echo "distributing $(SILIB) to $(DISTDIR)..."
#	@cp $(SILIB) $(DISTDIR)
#	@cp $(INCLUDES) $(DISTINCDIR)
#	@$(RANLIB) $(DISTDIR)/$(SILIB)

$(SILIB) : $(OBJS)
	@echo updating library...
	@$(AR) $(ARFLAGS) $(SILIB) $(OBJS)
	@$(RANLIB) $(SILIB)

$(SILIB_SO).$(VER) : $(OBJS)
	@$(CC) $(LDFLAGS) $(OBJS) -o $@

.c.o : 
	@echo compiling $<...
	@$(CC) $(DEFINES) $(CFLAGS) $(INCDIRS) -c $<

.PHONY: $(LIBNAME).pc
$(LIBNAME).pc:
	@echo "libdir=$(DESTDIR)" > $@
	@echo "includedir=$(PREFIX)/include" >> $@
	@echo "" >> $@
	@echo "Name: Libdsmcc" >> $@
	@echo "Description: Parser for MPEG2 DSM-CC Data/Object Carousel" >> $@
	@echo "Version: $(VER)" >> $@
	@echo "Libs: -L\$${libdir} -ldsmcc" >> $@
	@echo "Cflags: -I\$${includedir}/libdsmcc" >> $@

-include Makefile.dep

install-lib: all
	install -d $(DESTDIR)
	install -m 755 $(SILIB) $(DESTDIR)
	install -m 755 $(SILIB_SO).$(VER) $(DESTDIR)/
	( cd $(DESTDIR); ln -sf $(SILIB_SO).$(VER) $(SILIB_SO).$(VERMAJOR); ln -sf $(SILIB_SO).$(VER) $(SILIB_SO) )
	if [ -z "$(DESTDIR)" ] ; then ldconfig; fi

install-includes:
	install -d $(PREFIX)/include/$(LIBNAME)
	install -m 644 $(HEADERS) $(PREFIX)/include/$(LIBNAME)

install-pc: $(LIBNAME).pc
	install -d $(PCDIR)
	install -m 644 $(LIBNAME).pc $(PCDIR)/

install: install-lib install-includes install-pc
