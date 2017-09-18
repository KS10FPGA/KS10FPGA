#
# Programs
#

T10BACKUP   := ../../../tools/tapeutils-0.6.mods/t10backup.exe
DIAGTAPE    := ../../../Tape\ and\ Disk\ Images/KS10\ Diagnostics/ks_diag_gs.tap
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

all : DSDAB.temp.DAT

DSKBA.temp.DAT : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskba.sav -f $(DIAGTAPE)
	mv dskba.sav DSKBA.SAV
	$(SAV2VERILOG) DSKBA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKBA.DAT > DSKBA.temp.DAT

DSKDA.temp.DAT : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskda.sav -f $(DIAGTAPE)
	mv dskda.sav DSKDA.SAV
	$(SAV2VERILOG) DSKDA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKDA.DAT > DSKDA.temp.DAT

DSKEA.temp.DAT : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskea.sav -f $(DIAGTAPE)
	mv dskea.sav DSKEA.SAV
	$(SAV2VERILOG) DSKEA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKEA.DAT > DSKEA.temp.DAT

DSKEB.temp.DAT : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskeb.sav -f $(DIAGTAPE)
	mv dskeb.sav DSKEB.SAV
	$(SAV2VERILOG) DSKEB.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKEB.DAT > DSKEB.temp.DAT

DSKEC.temp.DAT : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskec.sav -f $(DIAGTAPE)
	mv dskec.sav DSKEC.SAV
	$(SAV2VERILOG) DSKEC.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKEC.DAT > DSKEC.temp.DAT

DSMMA.temp.DAT : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsmma.sav -f $(DIAGTAPE)
	mv dsmma.sav DSMMA.SAV
	$(SAV2VERILOG) DSMMA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSMMA.DAT > DSMMA.temp.DAT

DSMMB.temp.DAT : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsmmb.sav -f $(DIAGTAPE)
	mv dsmmb.sav DSMMB.SAV
	$(SAV2VERILOG) DSMMB.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSMMB.DAT > DSMMB.temp.DAT

DSMMC.temp.DAT : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsmmc.sav -f $(DIAGTAPE)
	mv dsmmc.sav DSMMC.SAV
	$(SAV2VERILOG) DSMMC.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSMMC.DAT > DSMMC.temp.DAT

DSMMD.temp.DAT : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsmmd.sav -f $(DIAGTAPE)
	mv dsmmd.sav DSMMD.SAV
	$(SAV2VERILOG) DSMMD.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSMMD.DAT > DSMMD.temp.DAT

DSRPA.temp.DAT : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH DSRPA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsrpa.sav -f $(DIAGTAPE)
	mv dsrpa.sav DSRPA.SAV
	$(SAV2VERILOG) DSRPA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH DSRPA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSRPA.DAT > DSRPA.temp.DAT

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