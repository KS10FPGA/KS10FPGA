
#
# Generic rule for building most diagnostics. There are some special
# rules below for diagnostics that require special handling.
#

ALL_DAT := \
	$(TMPDIR)/dskaa.dat \
	$(TMPDIR)/dskab.dat \
	$(TMPDIR)/dskac.dat \
	$(TMPDIR)/dskad.dat \
	$(TMPDIR)/dskae.dat \
	$(TMPDIR)/dskaf.dat \
	$(TMPDIR)/dskag.dat \
	$(TMPDIR)/dskah.dat \
	$(TMPDIR)/dskai.dat \
	$(TMPDIR)/dskaj.dat \
	$(TMPDIR)/dskak.dat \
	$(TMPDIR)/dskal.dat \
	$(TMPDIR)/dskam.dat \
	$(TMPDIR)/dskba.dat \
	$(TMPDIR)/dskca.dat \
	$(TMPDIR)/dskcb.dat \
	$(TMPDIR)/dskcc.dat \
	$(TMPDIR)/dskcd.dat \
	$(TMPDIR)/dskce.dat \
	$(TMPDIR)/dskcf.dat \
	$(TMPDIR)/dskcg.dat \
	$(TMPDIR)/dskda.dat \
	$(TMPDIR)/dskea.dat \
	$(TMPDIR)/dskeb.dat \
	$(TMPDIR)/dskec.dat \
	$(TMPDIR)/dskfa.dat \
	$(TMPDIR)/dsdua.dat \
	$(TMPDIR)/dskma.dat \
	$(TMPDIR)/dslpa.dat \
	$(TMPDIR)/dslta.dat \
	$(TMPDIR)/dsmma.dat \
	$(TMPDIR)/dsmmb.dat \
	$(TMPDIR)/dsmmc.dat \
	$(TMPDIR)/dsmmd.dat \
	$(TMPDIR)/dsrma.dat \
	$(TMPDIR)/dsrmb.dat \
	$(TMPDIR)/dsrpa.dat \

#
# Note: in the rule below, '$(basename $(@F))' expands into 'dskaa', or 'dskab',
# or whatever the target diagnostic name is (without the directory name or '.dat'
# extension).
#

$(ALL_DAT) : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) $(DIAGTAPE) $(TMPDIR)/dsqda.dat $(TMPDIR)/dsqdb.dat $(TMPDIR)/dsqdc.dat $(TMPDIR)/dsqda.patch.dat
	cd $(TMPDIR); \
	../$(T10BACKUP) -i -x diagnostics..$(basename $(@F)).sav -f ../$(DIAGTAPE); \
	../$(SAV2VERILOG) $(basename $(@F)).sav $(basename $(@F)).tmp.dat; \
	cat dsqda.dat dsqdb.dat dsqdc.dat $(basename $(@F)).tmp.dat dsqda.patch.dat | awk -f ../$(MERGE18) -vfilename=$(basename $(@F)).dat > $(basename $(@F)).dat; \
	rm -f $(basename $(@F)).sav $(basename $(@F)).tmp.dat

#
# DSDZA (DZ11 Diagnostics)
#
# The DZ11 needs patched because the diagnostic uses software timing loops
# to verify the baud rate. The KS10 FPGA is significantly faster than the
# DEC KS10 and the timing has to be modified accordingly.
#

$(TMPDIR)/dsdza.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) $(DIAGTAPE) $(TMPDIR)/dsqda.dat $(TMPDIR)/dsqdb.dat $(TMPDIR)/dsqdc.dat $(TMPDIR)/dsqda.patch.dat $(TMPDIR)/dsdza.patch.dat
	cd $(TMPDIR); \
	../$(T10BACKUP) -i -x diagnostics..dsdza.sav -f ../$(DIAGTAPE); \
	../$(SAV2VERILOG) dsdza.sav dsdza.tmp.dat; \
	cat dsqda.dat dsqdb.dat dsqdc.dat dsdza.tmp.dat dsqda.patch.dat dsdza.patch.dat | awk -f ../$(MERGE18) -vfilename=dsdza.dat > dsdza.dat; \
	rm -f dsdza.sav dsdza.tmp.dat

#
# DSTUA (RH11/TM03/TU45 Tape Drive)
#
#  Special rule to build DSTUA
#  The listing file that I have and the executable on the diagnostic tape do not match.
#  Use the SAV file ($(MAINDEC)/latest-dstua.sav) that I got from Richard Cornwell.
#

$(TMPDIR)/dstua.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) $(DIAGTAPE) $(TMPDIR)/dsqda.dat $(TMPDIR)/dsqdb.dat $(TMPDIR)/dsqdc.dat $(TMPDIR)/dsqda.patch.dat $(MAINDEC)/latest-dstua.sav
	cd $(TMPDIR); \
	../$(SAV2VERILOG) ../$(MAINDEC)/latest-dstua.sav dstua.tmp.dat; \
	cat dsqda.dat dsqdb.dat dsqdc.dat dstua.tmp.dat dsqda.patch.dat | awk -f ../$(MERGE18) -vfilename=dstua.dat > dstua.dat; \
	rm -f dstua.tmp.dat

#
# DSTUB (Tape Drive)
#
#  Special rule to build DSTUB
#  The listing file that I have and the executable on the diagnostic tape do not match.
#  Use the SAV file ($(MAINDEC)/latest-dstub.sav) that I got from Richard Cornwell.
#

$(TMPDIR)/dstub.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) $(DIAGTAPE) $(TMPDIR)/dsqda.dat $(TMPDIR)/dsqdb.dat $(TMPDIR)/dsqdc.dat $(TMPDIR)/dsqda.patch.dat $(MAINDEC)/latest-dstub.sav
	cd $(TMPDIR); \
	../$(SAV2VERILOG) ../$(MAINDEC)/latest-dstub.sav dstub.tmp.dat; \
	cat dsqda.dat dsqdb.dat dsqdc.dat dstub.tmp.dat dsqda.patch.dat | awk -f ../$(MERGE18) -vfilename=dstub.dat > dstub.dat; \
	rm -f dstub.tmp.dat

#
# DSUBA (Unibus Adapter)
#
#  DSUBA can be patched to set the starting diagnostic number.
#  This was used during debugging the UBA and UBEs.
#

$(TMPDIR)/dsuba.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) $(DIAGTAPE) $(TMPDIR)/dsqda.dat $(TMPDIR)/dsqdb.dat $(TMPDIR)/dsqdc.dat $(TMPDIR)/dsqda.patch.dat
	cd $(TMPDIR); \
	../$(T10BACKUP) -i -x diagnostics..dsuba.sav -f ../$(DIAGTAPE); \
	../$(SAV2VERILOG) dsuba.sav dsuba.tmp.dat; \
	cat dsqda.dat dsqdb.dat dsqdc.dat dsuba.tmp.dat dsqda.patch.dat dsuba.patch.dat | awk -f ../$(MERGE18) -vfilename=dsuba.dat > dsuba.dat; \
	rm -f dsuba.sav dsuba.tmp.dat

#
# DSQDA (SUBSM)
#

$(TMPDIR)/dsqda.dat : $(T10BACKUP) $(DIAGTAPE)
	mkdir -p $(TMPDIR)
	cd $(TMPDIR); \
	../$(T10BACKUP) -i -x diagnostics..subsm.sav -f ../$(DIAGTAPE); \
	../$(SAV2VERILOG) subsm.sav dsqda.dat; \
	rm -f subsm.sav

#
# DSQDB (SMDDT)
#

$(TMPDIR)/dsqdb.dat : $(T10BACKUP) $(DIAGTAPE) $(TMPDIR)/dsqda.dat
	cd $(TMPDIR); \
	../$(T10BACKUP) -i -x diagnostics..smddt.sav -f ../$(DIAGTAPE); \
	../$(SAV2VERILOG) smddt.sav dsqdb.dat; \
	rm -f smddt.sav

#
# DSQDC (SMMON)
#

$(TMPDIR)/dsqdc.dat : $(T10BACKUP) $(DIAGTAPE) $(TMPDIR)/dsqdb.dat
	cd $(TMPDIR); \
	../$(T10BACKUP) -i -x diagnostics..smmon.sav -f ../$(DIAGTAPE); \
	../$(SAV2VERILOG) smmon.sav dsqdc.dat; \
	rm -f smmon.sav

#
# Patch DSQDA to change the timeout on the console.
#

$(TMPDIR)/dsqda.patch.dat : makefile
	echo -e "000000180\t\t// mem[007304] = 000000000600" >  $(TMPDIR)/dsqda.patch.dat
	echo -e "000000040\t\t// mem[007366] = 000000000100" >> $(TMPDIR)/dsqda.patch.dat

#
# Enable paging
#  Unity map table
#  WREBR 030000
#  JRST  030600
#

$(TMPDIR)/paging.patch.dat : makefile
	echo -e "000000180\t\t// mem[000600] = 540000540001" >  $(TMPDIR)/pagen.patch.dat
	echo -e "000000181\t\t// mem[000601] = 540002540003" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000182\t\t// mem[000602] = 540004540005" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000183\t\t// mem[000603] = 540006540007" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000184\t\t// mem[000604] = 540010540011" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000185\t\t// mem[000605] = 540012540013" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000186\t\t// mem[000606] = 540014540015" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000187\t\t// mem[000607] = 540016540017" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000188\t\t// mem[000610] = 540020540021" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000189\t\t// mem[000611] = 540022540023" >> $(TMPDIR)/pagen.patch.dat
	echo -e "00000018a\t\t// mem[000612] = 540024540025" >> $(TMPDIR)/pagen.patch.dat
	echo -e "00000018b\t\t// mem[000613] = 540026540027" >> $(TMPDIR)/pagen.patch.dat
	echo -e "00000018c\t\t// mem[000614] = 540030540031" >> $(TMPDIR)/pagen.patch.dat
	echo -e "00000018d\t\t// mem[000615] = 540032540033" >> $(TMPDIR)/pagen.patch.dat
	echo -e "00000018e\t\t// mem[000616] = 540034540035" >> $(TMPDIR)/pagen.patch.dat
	echo -e "00000018f\t\t// mem[000617] = 540036540037" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000190\t\t// mem[000620] = 540040540041" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000191\t\t// mem[000621] = 540042540043" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000192\t\t// mem[000622] = 540044540045" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000193\t\t// mem[000623] = 540046540047" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000194\t\t// mem[000624] = 540050540051" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000195\t\t// mem[000625] = 540052540053" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000196\t\t// mem[000626] = 540054540055" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000197\t\t// mem[000627] = 540056540057" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000198\t\t// mem[000630] = 540060540061" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000000199\t\t// mem[000631] = 540062540063" >> $(TMPDIR)/pagen.patch.dat
	echo -e "00000019a\t\t// mem[000632] = 540064540065" >> $(TMPDIR)/pagen.patch.dat
	echo -e "00000019b\t\t// mem[000633] = 540066540067" >> $(TMPDIR)/pagen.patch.dat
	echo -e "00000019c\t\t// mem[000634] = 540070540071" >> $(TMPDIR)/pagen.patch.dat
	echo -e "00000019d\t\t// mem[000635] = 540072540073" >> $(TMPDIR)/pagen.patch.dat
	echo -e "00000019e\t\t// mem[000636] = 540074540075" >> $(TMPDIR)/pagen.patch.dat
	echo -e "00000019f\t\t// mem[000637] = 540076540077" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001a0\t\t// mem[000640] = 540100540101" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001a1\t\t// mem[000641] = 540102540103" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001a2\t\t// mem[000642] = 540104540105" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001a3\t\t// mem[000643] = 540106540107" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001a4\t\t// mem[000644] = 540110540111" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001a5\t\t// mem[000645] = 540112540113" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001a6\t\t// mem[000646] = 540114540115" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001a7\t\t// mem[000647] = 540116540117" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001a8\t\t// mem[000650] = 540120540121" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001a9\t\t// mem[000651] = 540122540123" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001aa\t\t// mem[000652] = 540124540125" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001ab\t\t// mem[000653] = 540126540127" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001ac\t\t// mem[000654] = 540130540131" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001ad\t\t// mem[000655] = 540132540133" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001ae\t\t// mem[000656] = 540134540135" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001af\t\t// mem[000657] = 540136540137" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001b0\t\t// mem[000660] = 540140540141" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001b1\t\t// mem[000661] = 540142540143" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001b2\t\t// mem[000662] = 540144540145" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001b3\t\t// mem[000663] = 540146540147" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001b4\t\t// mem[000664] = 540150540151" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001b5\t\t// mem[000665] = 540152540153" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001b6\t\t// mem[000666] = 540154540155" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001b7\t\t// mem[000667] = 540156540157" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001b8\t\t// mem[000670] = 540160540161" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001b9\t\t// mem[000671] = 540162540163" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001ba\t\t// mem[000672] = 540164540165" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001bb\t\t// mem[000673] = 540166540167" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001bc\t\t// mem[000674] = 540170540171" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001bd\t\t// mem[000675] = 540172540173" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001be\t\t// mem[000676] = 540174540175" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001bf\t\t// mem[000677] = 540176540177" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001c0\t\t// mem[000700] = 540200540201" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001c1\t\t// mem[000701] = 540202540203" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001c2\t\t// mem[000702] = 540204540205" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001c3\t\t// mem[000703] = 540206540207" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001c4\t\t// mem[000704] = 540210540211" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001c5\t\t// mem[000705] = 540212540213" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001c6\t\t// mem[000706] = 540214540215" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001c7\t\t// mem[000707] = 540216540217" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001c8\t\t// mem[000710] = 540220540221" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001c9\t\t// mem[000711] = 540222540223" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001ca\t\t// mem[000712] = 540224540225" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001cb\t\t// mem[000713] = 540226540227" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001cc\t\t// mem[000714] = 540230540231" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001cd\t\t// mem[000715] = 540232540233" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001ce\t\t// mem[000716] = 540234540235" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001cf\t\t// mem[000717] = 540236540237" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001d0\t\t// mem[000720] = 540240540241" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001d1\t\t// mem[000721] = 540242540243" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001d2\t\t// mem[000722] = 540244540245" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001d3\t\t// mem[000723] = 540246540247" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001d4\t\t// mem[000724] = 540250540251" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001d5\t\t// mem[000725] = 540252540253" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001d6\t\t// mem[000726] = 540254540255" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001d7\t\t// mem[000727] = 540256540257" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001d8\t\t// mem[000730] = 540260540261" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001d9\t\t// mem[000731] = 540262540263" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001da\t\t// mem[000732] = 540264540265" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001db\t\t// mem[000733] = 540266540267" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001dc\t\t// mem[000734] = 540270540271" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001dd\t\t// mem[000735] = 540272540273" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001de\t\t// mem[000736] = 540274540275" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001df\t\t// mem[000737] = 540276540277" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001e0\t\t// mem[000740] = 540300540301" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001e1\t\t// mem[000741] = 540302540303" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001e2\t\t// mem[000742] = 540304540305" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001e3\t\t// mem[000743] = 540306540307" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001e4\t\t// mem[000744] = 540310540311" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001e5\t\t// mem[000745] = 540312540313" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001e6\t\t// mem[000746] = 540314540315" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001e7\t\t// mem[000747] = 540316540317" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001e8\t\t// mem[000750] = 540320540321" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001e9\t\t// mem[000751] = 540322540323" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001ea\t\t// mem[000752] = 540324540325" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001eb\t\t// mem[000753] = 540326540327" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001ec\t\t// mem[000754] = 540330540331" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001ed\t\t// mem[000755] = 540332540333" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001ee\t\t// mem[000756] = 540334540335" >> $(TMPDIR)/pagen.patch.dat
	echo -e "0000001ef\t\t// mem[000757] = 540336540337" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000003001\t\t// mem[030001] = 701200020000" >> $(TMPDIR)/pagen.patch.dat
	echo -e "000003002\t\t// mem[030002] = 254000030600" >> $(TMPDIR)/pagen.patch.dat

#
# Patch the timout on the UART test
#
# The DZ11 needs patched because the diagnostic uses software timing loops
# to verify the baud rate. The KS10 FPGA is significantly faster than the
# DEC KS10 and the timing has to be modified accordingly.
#

$(TMPDIR)/dsdza.patch.dat : makefile
	echo -e ""                                                           >  $(TMPDIR)/dsdza.patch.dat
	echo -e "@3ba8"                                                      >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035650] = 000000006000 ( 0:   50 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035651] = 000000006000 ( 1:   75 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035652] = 000000006000 ( 2:  110 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035653] = 000000006000 ( 3:  134 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035654] = 000000006000 ( 4:  150 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035655] = 000000006000 ( 5:  300 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035656] = 000000006000 ( 6:  600 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035657] = 000000006000 ( 7: 1200 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035660] = 000000006000 ( 8: 1800 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035661] = 000000006000 ( 9: 2000 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035662] = 000000006000 (10: 2400 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035663] = 000000006000 (11: 3600 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035664] = 000000006000 (12: 4800 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035665] = 000000006000 (13: 7200 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "0000000c0\t\t// mem[035666] = 0000000000c0 (14: 9600 baud)" >> $(TMPDIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035667] = 000000006000 (15:19200 baud)" >> $(TMPDIR)/dsdza.patch.dat

#
# Start with different tests
#
#	echo -e "000003669\t\t// mem[034376] = 000000033151"                 >>  $(TMPDIR)/dsdza.patch.dat

#
# Patches for DSUBA
#

$(TMPDIR)/dsuba.patch.dat : makefile
	echo -e ""                                                          >  $(TMPDIR)/dsuba.patch.dat
#
# Start with different tests
#
#	echo -e "000000000\t\t// mem[047000] = 000000000000 (memlow)"       >> $(TMPDIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000031372 (DSUBA TEST11)" >> $(TMPDIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000031721 (DSUBA TEST15)" >> $(TMPDIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000032056 (DSUBA TEST17)" >> $(TMPDIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000032772 (DSUBA TEST33)" >> $(TMPDIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000033154 (DSUBA TEST37)" >> $(TMPDIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000033375 (DSUBA TEST44)" >> $(TMPDIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000033474 (DSUBA TEST46)" >> $(TMPDIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000033526 (DSUBA TEST47)" >> $(TMPDIR)/dsuba.patch.dat
#
