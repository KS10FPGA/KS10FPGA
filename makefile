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

ARGS :=\
	--exclude=*.tgz \
	--exclude=*.dsk \
	--exclude=*.tap \
	--exclude=*.tap.* \
	--exclude=*.rp06 \
	--exclude=*.rp06.* \
	--exclude=fpga/esm_top/ise/isim/* \
	--exclude=fpga/esm_top/ise/*.wdb \
	--exclude=fpga*/results/* \
	--exclude=fpga*/*.wlf \
	--exclude=fpga*/wlf* \
	--exclude=fpga*/transcript \
	--exclude=SIMH/* \
	--exclude=results/* \
	--exclude=testsuite/* \
	--exclude='Tape and Disk Images' \
	--exclude=tools/*.tap \

all:
	${MAKE} -C code
	${MAKE} -C fpga

clean:
	${MAKE} -C fpga clean
	${MAKE} -C code clean

archive_all:
	tar $(ARGS) --exclude-vcs -czvf ks10_all_`date '+%y%m%d'`.tgz *
