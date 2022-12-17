#
# Copyright 2022 Rob Doyle
# SPDX-License-Identifier: GPL-2.0
#

FILEDIR   := files
T10BACKUP := ../../tools/tapeutils/t10backup
DIAGTAPE  := ks_diag_gs.tap

all : ks_diag_gs.tap
	[ -d $(FILEDIR) ] || mkdir $(FILEDIR); \
	$(T10BACKUP) -x diagnostics..beware.txt     -f $(DIAGTAPE) && mv diagnostics..beware.txt     $(FILEDIR)/beware.txt; \
	$(T10BACKUP) -x diagnostics..convrt.sav     -f $(DIAGTAPE) && mv diagnostics..convrt.sav     $(FILEDIR)/convrt.sav; \
	$(T10BACKUP) -x diagnostics..czdmgd.bin     -f $(DIAGTAPE) && mv diagnostics..czdmgd.bin     $(FILEDIR)/czdmgd.bin; \
	$(T10BACKUP) -x diagnostics..czm9ba.bin     -f $(DIAGTAPE) && mv diagnostics..czm9ba.bin     $(FILEDIR)/czm9ba.bin; \
	$(T10BACKUP) -x diagnostics..czqmcf.bin     -f $(DIAGTAPE) && mv diagnostics..czqmcf.bin     $(FILEDIR)/czqmcf.bin; \
	$(T10BACKUP) -x diagnostics..decx11.bin     -f $(DIAGTAPE) && mv diagnostics..decx11.bin     $(FILEDIR)/decx11.bin; \
	$(T10BACKUP) -x diagnostics..decx11.cnf     -f $(DIAGTAPE) && mv diagnostics..decx11.cnf     $(FILEDIR)/decx11.cnf; \
	$(T10BACKUP) -x diagnostics..decx11.map     -f $(DIAGTAPE) && mv diagnostics..decx11.map     $(FILEDIR)/decx11.map; \
	$(T10BACKUP) -x diagnostics..diag.dn22      -f $(DIAGTAPE) && mv diagnostics..diag.dn22      $(FILEDIR)/diag.dn22; \
	$(T10BACKUP) -x diagnostics..dmpbot.bin     -f $(DIAGTAPE) && mv diagnostics..dmpbot.bin     $(FILEDIR)/dmpbot.bin; \
	$(T10BACKUP) -x diagnostics..dscda.sav      -f $(DIAGTAPE) && mv diagnostics..dscda.sav      $(FILEDIR)/dscda.sav; \
	$(T10BACKUP) -x diagnostics..dsdua.sav      -f $(DIAGTAPE) && mv diagnostics..dsdua.sav      $(FILEDIR)/dsdua.sav; \
	$(T10BACKUP) -x diagnostics..dsdza.sav      -f $(DIAGTAPE) && mv diagnostics..dsdza.sav      $(FILEDIR)/dsdza.sav; \
	$(T10BACKUP) -x diagnostics..dskaa.sav      -f $(DIAGTAPE) && mv diagnostics..dskaa.sav      $(FILEDIR)/dskaa.sav; \
	$(T10BACKUP) -x diagnostics..dskab.sav      -f $(DIAGTAPE) && mv diagnostics..dskab.sav      $(FILEDIR)/dskab.sav; \
	$(T10BACKUP) -x diagnostics..dskac.sav      -f $(DIAGTAPE) && mv diagnostics..dskac.sav      $(FILEDIR)/dskac.sav; \
	$(T10BACKUP) -x diagnostics..dskad.sav      -f $(DIAGTAPE) && mv diagnostics..dskad.sav      $(FILEDIR)/dskad.sav; \
	$(T10BACKUP) -x diagnostics..dskae.sav      -f $(DIAGTAPE) && mv diagnostics..dskae.sav      $(FILEDIR)/dskae.sav; \
	$(T10BACKUP) -x diagnostics..dskaf.sav      -f $(DIAGTAPE) && mv diagnostics..dskaf.sav      $(FILEDIR)/dskaf.sav; \
	$(T10BACKUP) -x diagnostics..dskag.sav      -f $(DIAGTAPE) && mv diagnostics..dskag.sav      $(FILEDIR)/dskag.sav; \
	$(T10BACKUP) -x diagnostics..dskah.sav      -f $(DIAGTAPE) && mv diagnostics..dskah.sav      $(FILEDIR)/dskah.sav; \
	$(T10BACKUP) -x diagnostics..dskai.sav      -f $(DIAGTAPE) && mv diagnostics..dskai.sav      $(FILEDIR)/dskai.sav; \
	$(T10BACKUP) -x diagnostics..dskaj.sav      -f $(DIAGTAPE) && mv diagnostics..dskaj.sav      $(FILEDIR)/dskaj.sav; \
	$(T10BACKUP) -x diagnostics..dskak.sav      -f $(DIAGTAPE) && mv diagnostics..dskak.sav      $(FILEDIR)/dskak.sav; \
	$(T10BACKUP) -x diagnostics..dskal.sav      -f $(DIAGTAPE) && mv diagnostics..dskal.sav      $(FILEDIR)/dskal.sav; \
	$(T10BACKUP) -x diagnostics..dskam.sav      -f $(DIAGTAPE) && mv diagnostics..dskam.sav      $(FILEDIR)/dskam.sav; \
	$(T10BACKUP) -x diagnostics..dskba.sav      -f $(DIAGTAPE) && mv diagnostics..dskba.sav      $(FILEDIR)/dskba.sav; \
	$(T10BACKUP) -x diagnostics..dskca.sav      -f $(DIAGTAPE) && mv diagnostics..dskca.sav      $(FILEDIR)/dskca.sav; \
	$(T10BACKUP) -x diagnostics..dskcb.sav      -f $(DIAGTAPE) && mv diagnostics..dskcb.sav      $(FILEDIR)/dskcb.sav; \
	$(T10BACKUP) -x diagnostics..dskcc.sav      -f $(DIAGTAPE) && mv diagnostics..dskcc.sav      $(FILEDIR)/dskcc.sav; \
	$(T10BACKUP) -x diagnostics..dskcd.sav      -f $(DIAGTAPE) && mv diagnostics..dskcd.sav      $(FILEDIR)/dskcd.sav; \
	$(T10BACKUP) -x diagnostics..dskce.sav      -f $(DIAGTAPE) && mv diagnostics..dskce.sav      $(FILEDIR)/dskce.sav; \
	$(T10BACKUP) -x diagnostics..dskcf.sav      -f $(DIAGTAPE) && mv diagnostics..dskcf.sav      $(FILEDIR)/dskcf.sav; \
	$(T10BACKUP) -x diagnostics..dskcg.sav      -f $(DIAGTAPE) && mv diagnostics..dskcg.sav      $(FILEDIR)/dskcg.sav; \
	$(T10BACKUP) -x diagnostics..dskda.sav      -f $(DIAGTAPE) && mv diagnostics..dskda.sav      $(FILEDIR)/dskda.sav; \
	$(T10BACKUP) -x diagnostics..dskea.sav      -f $(DIAGTAPE) && mv diagnostics..dskea.sav      $(FILEDIR)/dskea.sav; \
	$(T10BACKUP) -x diagnostics..dskeb.sav      -f $(DIAGTAPE) && mv diagnostics..dskeb.sav      $(FILEDIR)/dskeb.sav; \
	$(T10BACKUP) -x diagnostics..dskec.sav      -f $(DIAGTAPE) && mv diagnostics..dskec.sav      $(FILEDIR)/dskec.sav; \
	$(T10BACKUP) -x diagnostics..dskfa.sav      -f $(DIAGTAPE) && mv diagnostics..dskfa.sav      $(FILEDIR)/dskfa.sav; \
	$(T10BACKUP) -x diagnostics..dskma.sav      -f $(DIAGTAPE) && mv diagnostics..dskma.sav      $(FILEDIR)/dskma.sav; \
	$(T10BACKUP) -x diagnostics..dslpa.sav      -f $(DIAGTAPE) && mv diagnostics..dslpa.sav      $(FILEDIR)/dslpa.sav; \
	$(T10BACKUP) -x diagnostics..dslta.sav      -f $(DIAGTAPE) && mv diagnostics..dslta.sav      $(FILEDIR)/dslta.sav; \
	$(T10BACKUP) -x diagnostics..dsmma.sav      -f $(DIAGTAPE) && mv diagnostics..dsmma.sav      $(FILEDIR)/dsmma.sav; \
	$(T10BACKUP) -x diagnostics..dsmmb.sav      -f $(DIAGTAPE) && mv diagnostics..dsmmb.sav      $(FILEDIR)/dsmmb.sav; \
	$(T10BACKUP) -x diagnostics..dsmmc.sav      -f $(DIAGTAPE) && mv diagnostics..dsmmc.sav      $(FILEDIR)/dsmmc.sav; \
	$(T10BACKUP) -x diagnostics..dsmmd.sav      -f $(DIAGTAPE) && mv diagnostics..dsmmd.sav      $(FILEDIR)/dsmmd.sav; \
	$(T10BACKUP) -x diagnostics..dsrha.sav      -f $(DIAGTAPE) && mv diagnostics..dsrha.sav      $(FILEDIR)/dsrha.sav; \
	$(T10BACKUP) -x diagnostics..dsrma.sav      -f $(DIAGTAPE) && mv diagnostics..dsrma.sav      $(FILEDIR)/dsrma.sav; \
	$(T10BACKUP) -x diagnostics..dsrmb.sav      -f $(DIAGTAPE) && mv diagnostics..dsrmb.sav      $(FILEDIR)/dsrmb.sav; \
	$(T10BACKUP) -x diagnostics..dsrpa.sav      -f $(DIAGTAPE) && mv diagnostics..dsrpa.sav      $(FILEDIR)/dsrpa.sav; \
	$(T10BACKUP) -x diagnostics..dstua.sav      -f $(DIAGTAPE) && mv diagnostics..dstua.sav      $(FILEDIR)/dstua.sav; \
	$(T10BACKUP) -x diagnostics..dstub.sav      -f $(DIAGTAPE) && mv diagnostics..dstub.sav      $(FILEDIR)/dstub.sav; \
	$(T10BACKUP) -x diagnostics..dsuba.sav      -f $(DIAGTAPE) && mv diagnostics..dsuba.sav      $(FILEDIR)/dsuba.sav; \
	$(T10BACKUP) -x diagnostics..dsxla.inp      -f $(DIAGTAPE) && mv diagnostics..dsxla.inp      $(FILEDIR)/dsxla.inp; \
	$(T10BACKUP) -x diagnostics..dump0.dmp      -f $(DIAGTAPE) && mv diagnostics..dump0.dmp      $(FILEDIR)/dump0.dmp; \
	$(T10BACKUP) -x diagnostics..dzdmeb.bin     -f $(DIAGTAPE) && mv diagnostics..dzdmeb.bin     $(FILEDIR)/dzdmeb.bin; \
	$(T10BACKUP) -x diagnostics..dzdmfb.bin     -f $(DIAGTAPE) && mv diagnostics..dzdmfb.bin     $(FILEDIR)/dzdmfb.bin; \
	$(T10BACKUP) -x diagnostics..dzdmhb.bin     -f $(DIAGTAPE) && mv diagnostics..dzdmhb.bin     $(FILEDIR)/dzdmhb.bin; \
	$(T10BACKUP) -x diagnostics..gkaaa0.bic     -f $(DIAGTAPE) && mv diagnostics..gkaaa0.bic     $(FILEDIR)/gkaaa0.bic; \
	$(T10BACKUP) -x diagnostics..gkabc0.bic     -f $(DIAGTAPE) && mv diagnostics..gkabc0.bic     $(FILEDIR)/gkabc0.bic; \
	$(T10BACKUP) -x diagnostics..ks10.mcl       -f $(DIAGTAPE) && mv diagnostics..ks10.mcl       $(FILEDIR)/ks10.mcl; \
	$(T10BACKUP) -x diagnostics..ks10.mcr       -f $(DIAGTAPE) && mv diagnostics..ks10.mcr       $(FILEDIR)/ks10.mcr; \
	$(T10BACKUP) -x diagnostics..ks10.ram       -f $(DIAGTAPE) && mv diagnostics..ks10.ram       $(FILEDIR)/ks10.ram; \
	$(T10BACKUP) -x diagnostics..ks10.rsq       -f $(DIAGTAPE) && mv diagnostics..ks10.rsq       $(FILEDIR)/ks10.rsq; \
	$(T10BACKUP) -x diagnostics..ks10.uld       -f $(DIAGTAPE) && mv diagnostics..ks10.uld       $(FILEDIR)/ks10.uld; \
	$(T10BACKUP) -x diagnostics..red-tape-3.txt -f $(DIAGTAPE) && mv diagnostics..red-tape-3.txt $(FILEDIR)/red-tape-3.txt; \
	$(T10BACKUP) -x diagnostics..smapt.hlp      -f $(DIAGTAPE) && mv diagnostics..smapt.hlp      $(FILEDIR)/smapt.hlp; \
	$(T10BACKUP) -x diagnostics..smapt.sav      -f $(DIAGTAPE) && mv diagnostics..smapt.sav      $(FILEDIR)/smapt.sav; \
	$(T10BACKUP) -x diagnostics..smbc2.exe      -f $(DIAGTAPE) && mv diagnostics..smbc2.exe      $(FILEDIR)/smbc2.exe; \
	$(T10BACKUP) -x diagnostics..smbc2.sav      -f $(DIAGTAPE) && mv diagnostics..smbc2.sav      $(FILEDIR)/smbc2.sav; \
	$(T10BACKUP) -x diagnostics..smcpu.cmd      -f $(DIAGTAPE) && mv diagnostics..smcpu.cmd      $(FILEDIR)/smcpu.cmd; \
	$(T10BACKUP) -x diagnostics..smddt.hlp      -f $(DIAGTAPE) && mv diagnostics..smddt.hlp      $(FILEDIR)/smddt.hlp; \
	$(T10BACKUP) -x diagnostics..smddt.sav      -f $(DIAGTAPE) && mv diagnostics..smddt.sav      $(FILEDIR)/smddt.sav; \
	$(T10BACKUP) -x diagnostics..smfile.exe     -f $(DIAGTAPE) && mv diagnostics..smfile.exe     $(FILEDIR)/smfile.exe; \
	$(T10BACKUP) -x diagnostics..smfile.hlp     -f $(DIAGTAPE) && mv diagnostics..smfile.hlp     $(FILEDIR)/smfile.hlp; \
	$(T10BACKUP) -x diagnostics..smfile.txt     -f $(DIAGTAPE) && mv diagnostics..smfile.txt     $(FILEDIR)/smfile.txt; \
	$(T10BACKUP) -x diagnostics..smflt.cmd      -f $(DIAGTAPE) && mv diagnostics..smflt.cmd      $(FILEDIR)/smflt.cmd; \
	$(T10BACKUP) -x diagnostics..smmag.exe      -f $(DIAGTAPE) && mv diagnostics..smmag.exe      $(FILEDIR)/smmag.exe; \
	$(T10BACKUP) -x diagnostics..smmag.sav      -f $(DIAGTAPE) && mv diagnostics..smmag.sav      $(FILEDIR)/smmag.sav; \
	$(T10BACKUP) -x diagnostics..smmon.exe      -f $(DIAGTAPE) && mv diagnostics..smmon.exe      $(FILEDIR)/smmon.exe; \
	$(T10BACKUP) -x diagnostics..smmon.sav      -f $(DIAGTAPE) && mv diagnostics..smmon.sav      $(FILEDIR)/smmon.sav; \
	$(T10BACKUP) -x diagnostics..smtape.dir     -f $(DIAGTAPE) && mv diagnostics..smtape.dir     $(FILEDIR)/smtape.dir; \
	$(T10BACKUP) -x diagnostics..smtape.mta     -f $(DIAGTAPE) && mv diagnostics..smtape.mta     $(FILEDIR)/smtape.mta; \
	$(T10BACKUP) -x diagnostics..smtape.ram     -f $(DIAGTAPE) && mv diagnostics..smtape.ram     $(FILEDIR)/smtape.ram; \
	$(T10BACKUP) -x diagnostics..smtape.rdi     -f $(DIAGTAPE) && mv diagnostics..smtape.rdi     $(FILEDIR)/smtape.rdi; \
	$(T10BACKUP) -x diagnostics..smtape.sav     -f $(DIAGTAPE) && mv diagnostics..smtape.sav     $(FILEDIR)/smtape.sav; \
	$(T10BACKUP) -x diagnostics..smusr.cmd      -f $(DIAGTAPE) && mv diagnostics..smusr.cmd      $(FILEDIR)/smusr.cmd; \
	$(T10BACKUP) -x diagnostics..subsm.sav      -f $(DIAGTAPE) && mv diagnostics..subsm.sav      $(FILEDIR)/subsm.sav; \
	$(T10BACKUP) -x diagnostics..subusr.sav     -f $(DIAGTAPE) && mv diagnostics..subusr.sav     $(FILEDIR)/subusr.sav; \
	$(T10BACKUP) -x diagnostics..zdldb0.bin     -f $(DIAGTAPE) && mv diagnostics..zdldb0.bin     $(FILEDIR)/zdldb0.bin; \
	$(T10BACKUP) -x diagnostics..zdpbbx.bin     -f $(DIAGTAPE) && mv diagnostics..zdpbbx.bin     $(FILEDIR)/zdpbbx.bin; \
	$(T10BACKUP) -x diagnostics..zdpcbx.bin     -f $(DIAGTAPE) && mv diagnostics..zdpcbx.bin     $(FILEDIR)/zdpcbx.bin; \
	$(T10BACKUP) -x diagnostics..zdpdbx.bin     -f $(DIAGTAPE) && mv diagnostics..zdpdbx.bin     $(FILEDIR)/zdpdbx.bin; \
	$(T10BACKUP) -x diagnostics..zdpea0.bin     -f $(DIAGTAPE) && mv diagnostics..zdpea0.bin     $(FILEDIR)/zdpea0.bin; \
	$(T10BACKUP) -x diagnostics..zdpfb0.bin     -f $(DIAGTAPE) && mv diagnostics..zdpfb0.bin     $(FILEDIR)/zdpfb0.bin

ks_diag_gs.tap : ks_diag_gs.tap.gz
	gunzip -c ks_diag_gs.tap.gz > ks_diag_gs.tap

clean :
	rm -rf files ks_diag_gs.tap *~ .*~

echo :
	echo $(FILES)