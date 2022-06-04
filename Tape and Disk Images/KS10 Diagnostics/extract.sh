#!/bin/sh
DIAG=ks_diag_gs.tap
[ -d files ] || mkdir files
[ -f $DIAG.gz ] && gunzip -k $DIAG.gz
../../tools/tapeutils/t10backup -x diagnostics..beware.txt     -f $DIAG && mv diagnostics..beware.txt     files/beware.txt
../../tools/tapeutils/t10backup -x diagnostics..convrt.sav     -f $DIAG && mv diagnostics..convrt.sav     files/convrt.sav
../../tools/tapeutils/t10backup -x diagnostics..czdmgd.bin     -f $DIAG && mv diagnostics..czdmgd.bin     files/czdmgd.bin
../../tools/tapeutils/t10backup -x diagnostics..czm9ba.bin     -f $DIAG && mv diagnostics..czm9ba.bin     files/czm9ba.bin
../../tools/tapeutils/t10backup -x diagnostics..czqmcf.bin     -f $DIAG && mv diagnostics..czqmcf.bin     files/czqmcf.bin
../../tools/tapeutils/t10backup -x diagnostics..decx11.bin     -f $DIAG && mv diagnostics..decx11.bin     files/decx11.bin
../../tools/tapeutils/t10backup -x diagnostics..decx11.cnf     -f $DIAG && mv diagnostics..decx11.cnf     files/decx11.cnf
../../tools/tapeutils/t10backup -x diagnostics..decx11.map     -f $DIAG && mv diagnostics..decx11.map     files/decx11.map
../../tools/tapeutils/t10backup -x diagnostics..diag.dn22      -f $DIAG && mv diagnostics..diag.dn22      files/diag.dn22
../../tools/tapeutils/t10backup -x diagnostics..dmpbot.bin     -f $DIAG && mv diagnostics..dmpbot.bin     files/dmpbot.bin
../../tools/tapeutils/t10backup -x diagnostics..dscda.sav      -f $DIAG && mv diagnostics..dscda.sav      files/dscda.sav
../../tools/tapeutils/t10backup -x diagnostics..dsdua.sav      -f $DIAG && mv diagnostics..dsdua.sav      files/dsdua.sav
../../tools/tapeutils/t10backup -x diagnostics..dsdza.sav      -f $DIAG && mv diagnostics..dsdza.sav      files/dsdza.sav
../../tools/tapeutils/t10backup -x diagnostics..dskaa.sav      -f $DIAG && mv diagnostics..dskaa.sav      files/dskaa.sav
../../tools/tapeutils/t10backup -x diagnostics..dskab.sav      -f $DIAG && mv diagnostics..dskab.sav      files/dskab.sav
../../tools/tapeutils/t10backup -x diagnostics..dskac.sav      -f $DIAG && mv diagnostics..dskac.sav      files/dskac.sav
../../tools/tapeutils/t10backup -x diagnostics..dskad.sav      -f $DIAG && mv diagnostics..dskad.sav      files/dskad.sav
../../tools/tapeutils/t10backup -x diagnostics..dskae.sav      -f $DIAG && mv diagnostics..dskae.sav      files/dskae.sav
../../tools/tapeutils/t10backup -x diagnostics..dskaf.sav      -f $DIAG && mv diagnostics..dskaf.sav      files/dskaf.sav
../../tools/tapeutils/t10backup -x diagnostics..dskag.sav      -f $DIAG && mv diagnostics..dskag.sav      files/dskag.sav
../../tools/tapeutils/t10backup -x diagnostics..dskah.sav      -f $DIAG && mv diagnostics..dskah.sav      files/dskah.sav
../../tools/tapeutils/t10backup -x diagnostics..dskai.sav      -f $DIAG && mv diagnostics..dskai.sav      files/dskai.sav
../../tools/tapeutils/t10backup -x diagnostics..dskaj.sav      -f $DIAG && mv diagnostics..dskaj.sav      files/dskaj.sav
../../tools/tapeutils/t10backup -x diagnostics..dskak.sav      -f $DIAG && mv diagnostics..dskak.sav      files/dskak.sav
../../tools/tapeutils/t10backup -x diagnostics..dskal.sav      -f $DIAG && mv diagnostics..dskal.sav      files/dskal.sav
../../tools/tapeutils/t10backup -x diagnostics..dskam.sav      -f $DIAG && mv diagnostics..dskam.sav      files/dskam.sav
../../tools/tapeutils/t10backup -x diagnostics..dskba.sav      -f $DIAG && mv diagnostics..dskba.sav      files/dskba.sav
../../tools/tapeutils/t10backup -x diagnostics..dskca.sav      -f $DIAG && mv diagnostics..dskca.sav      files/dskca.sav
../../tools/tapeutils/t10backup -x diagnostics..dskcb.sav      -f $DIAG && mv diagnostics..dskcb.sav      files/dskcb.sav
../../tools/tapeutils/t10backup -x diagnostics..dskcc.sav      -f $DIAG && mv diagnostics..dskcc.sav      files/dskcc.sav
../../tools/tapeutils/t10backup -x diagnostics..dskcd.sav      -f $DIAG && mv diagnostics..dskcd.sav      files/dskcd.sav
../../tools/tapeutils/t10backup -x diagnostics..dskce.sav      -f $DIAG && mv diagnostics..dskce.sav      files/dskce.sav
../../tools/tapeutils/t10backup -x diagnostics..dskcf.sav      -f $DIAG && mv diagnostics..dskcf.sav      files/dskcf.sav
../../tools/tapeutils/t10backup -x diagnostics..dskcg.sav      -f $DIAG && mv diagnostics..dskcg.sav      files/dskcg.sav
../../tools/tapeutils/t10backup -x diagnostics..dskda.sav      -f $DIAG && mv diagnostics..dskda.sav      files/dskda.sav
../../tools/tapeutils/t10backup -x diagnostics..dskea.sav      -f $DIAG && mv diagnostics..dskea.sav      files/dskea.sav
../../tools/tapeutils/t10backup -x diagnostics..dskeb.sav      -f $DIAG && mv diagnostics..dskeb.sav      files/dskeb.sav
../../tools/tapeutils/t10backup -x diagnostics..dskec.sav      -f $DIAG && mv diagnostics..dskec.sav      files/dskec.sav
../../tools/tapeutils/t10backup -x diagnostics..dskfa.sav      -f $DIAG && mv diagnostics..dskfa.sav      files/dskfa.sav
../../tools/tapeutils/t10backup -x diagnostics..dskma.sav      -f $DIAG && mv diagnostics..dskma.sav      files/dskma.sav
../../tools/tapeutils/t10backup -x diagnostics..dslpa.sav      -f $DIAG && mv diagnostics..dslpa.sav      files/dslpa.sav
../../tools/tapeutils/t10backup -x diagnostics..dslta.sav      -f $DIAG && mv diagnostics..dslta.sav      files/dslta.sav
../../tools/tapeutils/t10backup -x diagnostics..dsmma.sav      -f $DIAG && mv diagnostics..dsmma.sav      files/dsmma.sav
../../tools/tapeutils/t10backup -x diagnostics..dsmmb.sav      -f $DIAG && mv diagnostics..dsmmb.sav      files/dsmmb.sav
../../tools/tapeutils/t10backup -x diagnostics..dsmmc.sav      -f $DIAG && mv diagnostics..dsmmc.sav      files/dsmmc.sav
../../tools/tapeutils/t10backup -x diagnostics..dsmmd.sav      -f $DIAG && mv diagnostics..dsmmd.sav      files/dsmmd.sav
../../tools/tapeutils/t10backup -x diagnostics..dsrha.sav      -f $DIAG && mv diagnostics..dsrha.sav      files/dsrha.sav
../../tools/tapeutils/t10backup -x diagnostics..dsrma.sav      -f $DIAG && mv diagnostics..dsrma.sav      files/dsrma.sav
../../tools/tapeutils/t10backup -x diagnostics..dsrmb.sav      -f $DIAG && mv diagnostics..dsrmb.sav      files/dsrmb.sav
../../tools/tapeutils/t10backup -x diagnostics..dsrpa.sav      -f $DIAG && mv diagnostics..dsrpa.sav      files/dsrpa.sav
../../tools/tapeutils/t10backup -x diagnostics..dstua.sav      -f $DIAG && mv diagnostics..dstua.sav      files/dstua.sav
../../tools/tapeutils/t10backup -x diagnostics..dstub.sav      -f $DIAG && mv diagnostics..dstub.sav      files/dstub.sav
../../tools/tapeutils/t10backup -x diagnostics..dsuba.sav      -f $DIAG && mv diagnostics..dsuba.sav      files/dsuba.sav
../../tools/tapeutils/t10backup -x diagnostics..dsxla.inp      -f $DIAG && mv diagnostics..dsxla.inp      files/dsxla.inp
../../tools/tapeutils/t10backup -x diagnostics..dump0.dmp      -f $DIAG && mv diagnostics..dump0.dmp      files/dump0.dmp
../../tools/tapeutils/t10backup -x diagnostics..dzdmeb.bin     -f $DIAG && mv diagnostics..dzdmeb.bin     files/dzdmeb.bin
../../tools/tapeutils/t10backup -x diagnostics..dzdmfb.bin     -f $DIAG && mv diagnostics..dzdmfb.bin     files/dzdmfb.bin
../../tools/tapeutils/t10backup -x diagnostics..dzdmhb.bin     -f $DIAG && mv diagnostics..dzdmhb.bin     files/dzdmhb.bin
../../tools/tapeutils/t10backup -x diagnostics..gkaaa0.bic     -f $DIAG && mv diagnostics..gkaaa0.bic     files/gkaaa0.bic
../../tools/tapeutils/t10backup -x diagnostics..gkabc0.bic     -f $DIAG && mv diagnostics..gkabc0.bic     files/gkabc0.bic
../../tools/tapeutils/t10backup -x diagnostics..ks10.mcl       -f $DIAG && mv diagnostics..ks10.mcl       files/ks10.mcl
../../tools/tapeutils/t10backup -x diagnostics..ks10.mcr       -f $DIAG && mv diagnostics..ks10.mcr       files/ks10.mcr
../../tools/tapeutils/t10backup -x diagnostics..ks10.ram       -f $DIAG && mv diagnostics..ks10.ram       files/ks10.ram
../../tools/tapeutils/t10backup -x diagnostics..ks10.rsq       -f $DIAG && mv diagnostics..ks10.rsq       files/ks10.rsq
../../tools/tapeutils/t10backup -x diagnostics..ks10.uld       -f $DIAG && mv diagnostics..ks10.uld       files/ks10.uld
../../tools/tapeutils/t10backup -x diagnostics..red-tape-3.txt -f $DIAG && mv diagnostics..red-tape-3.txt files/red-tape-3.txt
../../tools/tapeutils/t10backup -x diagnostics..smapt.hlp      -f $DIAG && mv diagnostics..smapt.hlp      files/smapt.hlp
../../tools/tapeutils/t10backup -x diagnostics..smapt.sav      -f $DIAG && mv diagnostics..smapt.sav      files/smapt.sav
../../tools/tapeutils/t10backup -x diagnostics..smbc2.exe      -f $DIAG && mv diagnostics..smbc2.exe      files/smbc2.exe
../../tools/tapeutils/t10backup -x diagnostics..smbc2.sav      -f $DIAG && mv diagnostics..smbc2.sav      files/smbc2.sav
../../tools/tapeutils/t10backup -x diagnostics..smcpu.cmd      -f $DIAG && mv diagnostics..smcpu.cmd      files/smcpu.cmd
../../tools/tapeutils/t10backup -x diagnostics..smddt.hlp      -f $DIAG && mv diagnostics..smddt.hlp      files/smddt.hlp
../../tools/tapeutils/t10backup -x diagnostics..smddt.sav      -f $DIAG && mv diagnostics..smddt.sav      files/smddt.sav
../../tools/tapeutils/t10backup -x diagnostics..smfile.exe     -f $DIAG && mv diagnostics..smfile.exe     files/smfile.exe
../../tools/tapeutils/t10backup -x diagnostics..smfile.hlp     -f $DIAG && mv diagnostics..smfile.hlp     files/smfile.hlp
../../tools/tapeutils/t10backup -x diagnostics..smfile.txt     -f $DIAG && mv diagnostics..smfile.txt     files/smfile.txt
../../tools/tapeutils/t10backup -x diagnostics..smflt.cmd      -f $DIAG && mv diagnostics..smflt.cmd      files/smflt.cmd
../../tools/tapeutils/t10backup -x diagnostics..smmag.exe      -f $DIAG && mv diagnostics..smmag.exe      files/smmag.exe
../../tools/tapeutils/t10backup -x diagnostics..smmag.sav      -f $DIAG && mv diagnostics..smmag.sav      files/smmag.sav
../../tools/tapeutils/t10backup -x diagnostics..smmon.exe      -f $DIAG && mv diagnostics..smmon.exe      files/smmon.exe
../../tools/tapeutils/t10backup -x diagnostics..smmon.sav      -f $DIAG && mv diagnostics..smmon.sav      files/smmon.sav
../../tools/tapeutils/t10backup -x diagnostics..smtape.dir     -f $DIAG && mv diagnostics..smtape.dir     files/smtape.dir
../../tools/tapeutils/t10backup -x diagnostics..smtape.mta     -f $DIAG && mv diagnostics..smtape.mta     files/smtape.mta
../../tools/tapeutils/t10backup -x diagnostics..smtape.ram     -f $DIAG && mv diagnostics..smtape.ram     files/smtape.ram
../../tools/tapeutils/t10backup -x diagnostics..smtape.rdi     -f $DIAG && mv diagnostics..smtape.rdi     files/smtape.rdi
../../tools/tapeutils/t10backup -x diagnostics..smtape.sav     -f $DIAG && mv diagnostics..smtape.sav     files/smtape.sav
../../tools/tapeutils/t10backup -x diagnostics..smusr.cmd      -f $DIAG && mv diagnostics..smusr.cmd      files/smusr.cmd
../../tools/tapeutils/t10backup -x diagnostics..subsm.sav      -f $DIAG && mv diagnostics..subsm.sav      files/subsm.sav
../../tools/tapeutils/t10backup -x diagnostics..subusr.sav     -f $DIAG && mv diagnostics..subusr.sav     files/subusr.sav
../../tools/tapeutils/t10backup -x diagnostics..zdldb0.bin     -f $DIAG && mv diagnostics..zdldb0.bin     files/zdldb0.bin
../../tools/tapeutils/t10backup -x diagnostics..zdpbbx.bin     -f $DIAG && mv diagnostics..zdpbbx.bin     files/zdpbbx.bin
../../tools/tapeutils/t10backup -x diagnostics..zdpcbx.bin     -f $DIAG && mv diagnostics..zdpcbx.bin     files/zdpcbx.bin
../../tools/tapeutils/t10backup -x diagnostics..zdpdbx.bin     -f $DIAG && mv diagnostics..zdpdbx.bin     files/zdpdbx.bin
../../tools/tapeutils/t10backup -x diagnostics..zdpea0.bin     -f $DIAG && mv diagnostics..zdpea0.bin     files/zdpea0.bin
../../tools/tapeutils/t10backup -x diagnostics..zdpfb0.bin     -f $DIAG && mv diagnostics..zdpfb0.bin     files/zdpfb0.bin