#******************************************************************************
#
# KS10 Console Microcontroller
#
# Brief
#    Console MCU Build rules
#
# File
#    makefile
#
# Author
#    Rob Doyle - doyle (at) cox (dot) net
#
#******************************************************************************
#
# Copyright (C) 2013-2022 Rob Doyle
#
# This file is part of the KS10 FPGA Project
#
# The KS10 FPGA project is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# The KS10 FPGA project is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this software.  If not, see <http://www.gnu.org/licenses/>.
#
#******************************************************************************

#
# Cross compile on cygwin
#  Compile -static because shared libraries don't match
#

UNAME := $(shell uname -po)
ifeq ('$(UNAME)', 'unknown Cygwin')
CROSS_COMPILE := arm-none-linux-gnueabihf-
CFLAGS        := -static
export PATH   := /usr/local/gcc-arm-10.3-2021.07-mingw-w64-i686-arm-none-linux-gnueabihf/bin:$(PATH)
endif

#
# Cross compile on WSL
#

UNAME := $(shell uname -po)
ifeq ('$(UNAME)', 'x86_64 GNU/Linux')
CROSS_COMPILE := arm-linux-gnueabihf-
CFLAGS        := -static
endif

#
# Native compiler on target
#

G++    := $(CROSS_COMPILE)g++
CFLAGS := $(CFLAGS) -Os -W -Wall -pthread -pipe -Wformat=0

CFILES := commands.cpp config.cpp cursor.cpp dasm.cpp dz11.cpp dup11.cpp hist.cpp cmdline.cpp ks10.cpp lp20.cpp mt.cpp rp.cpp rh11.cpp tape.cpp main.cpp
HFILES := commands.hpp config.hpp cursor.hpp dasm.hpp dz11.hpp dup11.hpp hist.hpp cmdline.hpp ks10.hpp lp20.hpp mt.hpp rp.hpp rh11.hpp tape.hpp uba.hpp

console : $(CFILES) $(HFILES) makefile
	$(G++) $(CFLAGS) $(CFILES) -o console
	make xfer

#
# If cross compiling, transfer the executable from the Host to the Target
#

.PHONY: xfer

xfer:
ifneq ('$(UNAME)', 'armv7l GNU/Linux')
	scp -B console root@ks10:/home/root/
endif

.PHONY: clean
clean:
	rm console

archive_all:
	tar -czvf ks10_code_all_`date '+%y%m%d'`.tgz *

archive_dist:
	${MAKE} rcsfetch
	tar --exclude-vcs -czvf ks10_code_dist_`date '+%y%m%d'`.tgz *

doxygen : doxyfile
	$(DOXYGEN)

EXCLUDE := \
	-e RCS \
	-e libSDL \
	-e libCONFUSE \
	-e vt05 \

check :
	@echo "Tabs in:"
	@-find . -maxdepth 1 -type f | grep -v $(EXCLUDE) | grep -e '\.cpp$$' -e '\.hpp$$' -e '\.c$$' -e '\.h$$' -e '\.s$$' | xargs grep -P '\t'
	@echo "Trailing white space in:"
	@-find . -maxdepth 1 -type f | grep -v $(EXCLUDE) | grep -e '\.cpp$$' -e '\.hpp$$' -e '\.c$$' -e '\.h$$' -e '\.s$$' | xargs grep -P '[ ]+$$'
	@echo "FIXMEs in:"
	@-find . -maxdepth 1 -type f | grep -v $(EXCLUDE) | grep -e '\.cpp$$' -e '\.hpp$$' -e '\.c$$' -e '\.h$$' -e '\.s$$' | xargs grep -i 'fixme'

