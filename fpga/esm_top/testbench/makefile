#******************************************************************************
#
# KS-10 Processor
#
# Brief
#    Testbench build rules
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

#
# Programs
#

T10BACKUP   := ../../../tools/tapeutils-0.6.mods/t10backup.exe
DIAGTAPE    := ../../../Tape\ and\ Disk\ Images/KS10\ Diagnostics/ks_diag_gs.tap
REDPACK     := ../../../Tape\ and\ Disk\ Images/RED\ PACK\ 405A2/red405a2.tap
SAV2VERILOG := ../../../tools/sav2verilog/sav2verilog.exe
MERGE_AWK   := ../../../tools/merge/merge.awk

#
# Read SD Card to file so it can be examined.
#  This assumes that a 8GB card is installed.
#

DEV   := sdf
UNIT0 := dskb.rp06.gz
UNIT1 := dskc.rp06.gz
UNIT2 := red405a2.rp06.gz
UNIT3 := dskb.rp06.gz
UNIT4 := dskb.rp06.gz
UNIT5 := dskb.rp06.gz
UNIT6 := dskb.rp06.gz
UNIT7 := dskb.rp06.gz

all : dsdab.ssram.dat

dsuba.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH DSUBA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsuba.sav -f $(DIAGTAPE)
	mv dsuba.sav DSUBA.SAV
	$(SAV2VERILOG) DSUBA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH DSUBA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSUBA.DAT > dsuba.ssram.dat

dskba.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskba.sav -f $(DIAGTAPE)
	mv dskba.sav DSKBA.SAV
	$(SAV2VERILOG) DSKBA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKBA.DAT > dskba.ssram.dat

dskda.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskda.sav -f $(DIAGTAPE)
	mv dskda.sav DSKDA.SAV
	$(SAV2VERILOG) DSKDA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKDA.DAT > dskda.ssram.dat

dskea.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskea.sav -f $(DIAGTAPE)
	mv dskea.sav DSKEA.SAV
	$(SAV2VERILOG) DSKEA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKEA.DAT > dskea.ssram.dat

dskeb.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskeb.sav -f $(DIAGTAPE)
	mv dskeb.sav DSKEB.SAV
	$(SAV2VERILOG) DSKEB.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKEB.DAT > dskeb.ssram.dat

dskec.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskec.sav -f $(DIAGTAPE)
	mv dskec.sav DSKEC.SAV
	$(SAV2VERILOG) DSKEC.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKEC.DAT > dskec.ssram.dat

dsmma.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsmma.sav -f $(DIAGTAPE)
	mv dsmma.sav DSMMA.SAV
	$(SAV2VERILOG) DSMMA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSMMA.DAT > dsmma.ssram.dat

dsmmb.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsmmb.sav -f $(DIAGTAPE)
	mv dsmmb.sav DSMMB.SAV
	$(SAV2VERILOG) DSMMB.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSMMB.DAT > dsmmb.ssram.dat

dsmmc.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsmmc.sav -f $(DIAGTAPE)
	mv dsmmc.sav DSMMC.SAV
	$(SAV2VERILOG) DSMMC.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSMMC.DAT > dsmmc.ssram.dat

dsmmd.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsmmd.sav -f $(DIAGTAPE)
	mv dsmmd.sav DSMMD.SAV
	$(SAV2VERILOG) DSMMD.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSMMD.DAT > dsmmd.ssram.dat

dsrpa.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH DSRPA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsrpa.sav -f $(DIAGTAPE)
	mv dsrpa.sav DSRPA.SAV
	$(SAV2VERILOG) DSRPA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH DSRPA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSRPA.DAT > dsrpa.ssram.dat

dslpa.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dslpa.sav -f $(DIAGTAPE)
	mv dslpa.sav DSLPA.SAV
	$(SAV2VERILOG) DSLPA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSLPA.DAT > dslpa.ssram.dat

dsdua.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsdua.sav -f $(DIAGTAPE)
	mv dsdua.sav DSDUA.SAV
	$(SAV2VERILOG) DSDUA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSDUA.DAT > dsdua.ssram.dat

dsdza.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH.PATCH
	$(T10BACKUP) -i -x diagnostics..dsdza.sav -f $(DIAGTAPE)
	mv dsdza.sav DSDZA.SAV
	$(SAV2VERILOG) DSDZA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSDZA.DAT > dsdza.ssram.dat

dskma.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskma.sav -f $(DIAGTAPE)
	mv dskma.sav DSKMA.SAV
	$(SAV2VERILOG) DSKMA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKMA.DAT > dskma.ssram.dat

dsrmb.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsrmb.sav -f $(DIAGTAPE)
	mv dsrmb.sav DSRMB.SAV
	$(SAV2VERILOG) DSRMB.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSRMB.DAT > dsrmb.ssram.dat

dslpa_v0_7a.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	awk -f ssram.awk < dslpa_v0_7a.seq > dslpa_v0_7a.tmp
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT dslpa_v0_7a.tmp DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSLPA.DAT > dslpa_v0_7a.dat

#
# Diagnostic Programs and Subroutines
#

DSQDA.DAT : $(T10BACKUP) $(DIAGTAPE)
	$(T10BACKUP) -i -x diagnostics..subsm.sav -f $(DIAGTAPE)
	mv subsm.sav DSQDA.SAV
	$(SAV2VERILOG) DSQDA.SAV DSQDA.DAT

DSQDB.DAT : $(T10BACKUP) $(DIAGTAPE)
	$(T10BACKUP) -i -x diagnostics..smddt.sav -f $(DIAGTAPE)
	mv smddt.sav DSQDB.SAV
	$(SAV2VERILOG) DSQDB.SAV DSQDB.DAT

DSQDC.DAT : $(T10BACKUP) $(DIAGTAPE)
	$(T10BACKUP) -i -x diagnostics..smmon.sav -f $(DIAGTAPE)
	mv smmon.sav DSQDC.SAV
	$(SAV2VERILOG) DSQDC.SAV DSQDC.DAT

#
# The PATCH to DSQDA changes the timeout on the console.
#

DSQDA.PATCH : makefile
	echo -e "000000180\t\t// mem[007304] = 000000000600" >  DSQDA.PATCH
	echo -e "000000040\t\t// mem[007366] = 000000000100" >> DSQDA.PATCH

#
# Set the initial test number to something other than 1 at addr 077263
#  Start on Test 0
#

DSRPA.PATCH : makefile
	echo -e "568000000\t\t// mem[060773] = 255000000000" >  DSRPA.PATCH
	echo -e "000000000\t\t// mem[077263] = 000000000000" >> DSRPA.PATCH

#
# Patch the timout on the UART test
#

# Start with test 31
#	echo -e "@38fe"                                      >   DSDZA.PATCH
#	echo -e "000003669\t\t// mem[034376] = 000000033151" >>  DSDZA.PATCH

DSDZA.PATCH : makefile
	echo -e ""                                                           >  DSDZA.PATCH
	echo -e "@3ba8"                                                      >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035650] = 000000006000 ( 0:   50 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035651] = 000000006000 ( 1:   75 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035652] = 000000006000 ( 2:  110 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035653] = 000000006000 ( 3:  134 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035654] = 000000006000 ( 4:  150 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035655] = 000000006000 ( 5:  300 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035656] = 000000006000 ( 6:  600 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035657] = 000000006000 ( 7: 1200 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035660] = 000000006000 ( 8: 1800 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035661] = 000000006000 ( 9: 2000 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035662] = 000000006000 (10: 2400 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035663] = 000000006000 (11: 3600 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035664] = 000000006000 (12: 4800 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035665] = 000000006000 (13: 7200 baud)" >> DSDZA.PATCH
	echo -e "0000000c0\t\t// mem[035666] = 0000000000c0 (14: 9600 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035667] = 000000006000 (15:19200 baud)" >> DSDZA.PATCH

#
#
#

DSUBA.PATCH : makefile
	echo -e ""                                                          >  DSUBA.PATCH
	echo -e "@4e00"                                                     >> DSUBA.PATCH
	echo -e "000000000\t\t// mem[047000] = 000000000000 (memlow)"       >> DSUBA.PATCH
	echo -e "@38E5"                                                     >> DSUBA.PATCH
	echo -e "0000032d4\t\t// mem[034345] = 000000031324 (DSUBA test10)" >> DSUBA.PATCH

check :
	cat /proc/partitions
	@echo
	@echo Device is currently /dev/$(DEV)

#
# Carefully update the SD Card
#

rp06_disk : makefile $(UNIT0) $(UNIT1) $(UNIT2)
	@echo ""
	@echo "The disk" /dev/$(DEV) "is partitioned as follows:"
	@cat /proc/partitions | grep $(DEV)
	@echo ""
	@echo "This script will destroy all of the data on" /dev/$(DEV)
	@echo "This script will destroy all of the data on" /dev/$(DEV)
	@echo "This script will destroy all of the data on" /dev/$(DEV)
	@echo ""
	@echo "You've been warned.  If you don't know what you're doing.   Stop now!"
	@echo ""
	@read -r -p "Are you sure you want to do that? [YES/NO] " prompt; \
	if [[ $$prompt == "YES" || $$prompt == "yes" ]]; then \
		echo "This will take a while.  Please be patient."; \
		zcat $(UNIT0) | dd of=/dev/$(DEV) bs=512 iflag=count_bytes oflag=seek_bytes count=309700K seek=0G; \
		zcat $(UNIT1) | dd of=/dev/$(DEV) bs=512 iflag=count_bytes oflag=seek_bytes count=309700K seek=1G; \
		zcat $(UNIT2) | dd of=/dev/$(DEV) bs=512 iflag=count_bytes oflag=seek_bytes count=309700K seek=2G; \
        else \
		echo "You must answer YES to write to SD Card!"; \
        fi

crc16_tb: crc16_tb.v ../../ks10/utils/crc16.v
	iverilog -W all -g2012 -s crc16_tb -o crc16_tb.vvp $?
	vvp crc16_tb.vvp

#
# The SD Card Simulator uses a seperate file for each of the devices
#   $fseek() can't seek a 8GB file so we split it up.
#   These are the disk images
#

unit0.dsk : makefile $(UNIT0)
	zcat $(UNIT0) > unit0.dsk

unit1.dsk : makefile $(UNIT1)
	zcat $(UNIT1) > unit1.dsk

unit2.dsk : makefile $(UNIT2)
	zcat $(UNIT2) > unit2.dsk

unit3.dsk : makefile $(UNIT3)
	zcat $(UNIT3) > unit3.dsk

unit4.dsk : makefile $(UNIT4)
	zcat $(UNIT4) > unit4.dsk

unit5.dsk : makefile $(UNIT5)
	zcat $(UNIT5) > unit5.dsk

unit6.dsk : makefile $(UNIT6)
	zcat $(UNIT6) > unit6.dsk

unit7.dsk : makefile $(UNIT7)
	zcat $(UNIT7) > unit7.dsk

sim_disk : unit0.dsk unit1.dsk unit2.dsk unit3.dsk unit4.dsk unit5.dsk unit6.dsk unit7.dsk

clean :	makefile
	rcsclean *
	rm -rf unit0.dsk unit1.dsk unit2.dsk unit3.dsk unit4.dsk unit5.dsk unit6.dsk unit7.dsk
