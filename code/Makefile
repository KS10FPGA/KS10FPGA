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
# Copyright (C) 2013-2017 Rob Doyle
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

G++    := g++

CFLAGS := -O2 -W -Wall -lpthread -pipe

CFILES := commands.cpp config.cpp cursor.cpp dasm.cpp dz11.cpp hist.cpp cmdline.cpp ks10.cpp lp20.cpp rh11.cpp main.cpp
HFILES := commands.hpp config.hpp cursor.hpp dasm.hpp dz11.hpp hist.hpp cmdline.hpp ks10.hpp lp20.hpp rh11.hpp

console : $(CFILES) $(HFILES) makefile
	$(G++) $(CFLAGS) $(CFILES) -o console

.PHONEY : get

get : Makefile
	./get.sh

.PHONEY : put
put : Makefile
	./put.sh

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
	@-find . -type f | grep -v $(EXCLUDE) | grep -e '\.cpp$$' -e '\.hpp$$' -e '\.c$$' -e '\.h$$' -e '\.s$$' | xargs grep -P '\t'
	@echo "Trailing white space in:"
	@-find . -type f | grep -v $(EXCLUDE) | grep -e '\.cpp$$' -e '\.hpp$$' -e '\.c$$' -e '\.h$$' -e '\.s$$' | xargs grep -P '[ ]+$$'
	@echo "FIXMEs in:"
	@-find . -type f | grep -v $(EXCLUDE) | grep -e '\.cpp$$' -e '\.hpp$$' -e '\.c$$' -e '\.h$$' -e '\.s$$' | xargs grep -i 'fixme'

