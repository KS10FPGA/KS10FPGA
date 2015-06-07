T10BACKUP   := ../../../tools/tapeutils-0.6.mods/t10backup.exe
DIAGTAPE    := ../../../Tape\ and\ Disk\ Images/KS10\ Diagnostics/ks_diag_gs.tap
SAV2VERILOG := ../../../tools/sav2verilog/sav2verilog.exe
MERGE_AWK   := ../../../tools/merge/merge.awk

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

DSRPA.temp.DAT : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDC.PATCH
	$(T10BACKUP) -i -x diagnostics..dsrpa.sav -f $(DIAGTAPE)
	mv dsrpa.sav DSRPA.SAV
	$(SAV2VERILOG) DSRPA.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSRPA.DAT > DSRPA.temp.DAT

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
# Read SD Card to file so it can be examined.
#  This assumes that a 8GB card is installed.
#

DEV := sdg

check :
	cat /proc/partitions
	@echo
	@echo Device is currently /dev/$(DEV)

read_rp06unit0 :
	dd if=/dev/$(DEV) of=rp06unit0 bs=512 iflag=count_bytes,skip_bytes count=309700K skip=0G

read_rp06unit1 :
	dd if=/dev/$(DEV) of=rp06unit1 bs=512 iflag=count_bytes,skip_bytes count=309700K skip=1G

read_rp06unit2 :
	dd if=/dev/$(DEV) of=rp06unit2 bs=512 iflag=count_bytes,skip_bytes count=309700K skip=2G

read_rp06unit3 :
	dd if=/dev/$(DEV) of=rp06unit3 bs=512 iflag=count_bytes,skip_bytes count=309700K skip=3G

read_rp06unit4 :
	dd if=/dev/$(DEV) of=rp06unit4 bs=512 iflag=count_bytes,skip_bytes count=309700K skip=4G

read_rp06unit5 :
	dd if=/dev/$(DEV) of=rp06unit5 bs=512 iflag=count_bytes,skip_bytes count=309700K skip=5G

read_rp06unit6 :
	dd if=/dev/$(DEV) of=rp06unit6 bs=512 iflag=count_bytes,skip_bytes count=309700K skip=6G

read_rp06unit7 :
	dd if=/dev/$(DEV) of=rp06unit7 bs=512 iflag=count_bytes,skip_bytes count=309700K skip=7G

write_rp06unit0 :
	dd if=dskb.dsk of=/dev/$(DEV) bs=512 iflag=count_bytes oflag=seek_bytes count=309700K seek=0G

write_rp06unit1 :
	dd if=dskc.dsk of=/dev/$(DEV) bs=512 iflag=count_bytes oflag=seek_bytes count=309700K seek=1G
