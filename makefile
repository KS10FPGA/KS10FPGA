#******************************************************************************
#
# KS-10 Processor
#
# Brief
#    FPGA and Software Build Rules
#
# File
#    makefile
#
# Author
#    Rob Doyle - doyle (at) cox (dot) net
#
#******************************************************************************
#
# Copyright (C) 2013-2021 Rob Doyle
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

FPGA_LIST := \
	fpga* \
	code \
	makefile

ALL_LIST := \
	fpga* \
	code \
	wiki \
	makefile \
	doc/Manual \
	doc/Website

ARGS :=\
	--exclude=fpga/esm_top/ise/isim/* \
	--exclude=fpga/esm_top/ise/*.wdb \
	--exclude=fpga*/testbench/*.dsk \
	--exclude=fpga*/testbench/*.rp06.gz \
	--exclude=fpga*/testbench/RCS/*.rp06.gz,v \
	--exclude=fpga*/results/* \
	--exclude=fpga*/*.wlf \
	--exclude=fpga*/wlf* \
	--exclude=fpga*/transcript

all:
	${MAKE} -C code console.bin
	${MAKE} -C fpga ise/esm_ks10.mcs

clean:
	${MAKE} -C fpga clean
	${MAKE} -C code clean

rcsclean:
	${MAKE} -C fpga rcsclean
	${MAKE} -C code rcsclean

rcsfetch:
	${MAKE} -C fpga rcsfetch
	${MAKE} -C code rcsfetch

loadcode:
	${MAKE} -C code load

loadfpga:
	${MAKE} -C fpga load

loadall: loadcode loadfpga

reset:
	${MAKE} -C code reset

isim:
	${MAKE} -C fpga isim

archive_all:
	tar $(ARGS) -czvf ks10_all_`date '+%y%m%d'`.tgz $(ALL_LIST)

archive_fpga:
	tar $(ARGS) -czvf ks10_fpga_`date '+%y%m%d'`.tgz $(FPGA_LIST)

archive_dist:
	tar $(ARGS) --exclude-vcs -czvf ks10_dist_`date '+%y%m%d'`.tgz $(FPGA_LIST)
