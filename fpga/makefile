PROJECT := ks10

RTL       := rtl
ISE       := ise
XILDIR    := `cygpath -u '$(XILINX)'`
FUSE      := $(XILDIR)/ISE_DS/ISE/bin/nt/fuse.exe
WCFG      := ks10_useriot.wcfg

PRJFILE   := $(PROJECT).prj
TESTBENCH := $(PROJECT)_testbench
WORK      := work.testbench

#LOAD      := MAINDEC-10-DSKAA.SEQ
#LOAD      := MAINDEC-10-DSKAB.SEQ
#LOAD      := MAINDEC-10-DSKAC.SEQ
#LOAD      := MAINDEC-10-DSKAD.SEQ
#LOAD      := MAINDEC-10-DSKAE.SEQ
#LOAD      := MAINDEC-10-DSKAF.SEQ
#LOAD      := MAINDEC-10-DSKAG.SEQ
#LOAD      := MAINDEC-10-DSKAH.SEQ		# runs 3.4 ms
#LOAD      := MAINDEC-10-DSKAI.SEQ
#LOAD      := MAINDEC-10-DSKAJ.SEQ
#LOAD      := MAINDEC-10-DSKAK.SEQ
#LOAD      := MAINDEC-10-DSKAL.SEQ
#LOAD      := MAINDEC-10-DSKAM.SEQ
#LOAD      := MAINDEC-10-DSKBA.SEQ		# FAIL
#LOAD      := MAINDEC-10-DSKCA.SEQ
#LOAD      := MAINDEC-10-DSKCB.SEQ
#LOAD      := MAINDEC-10-DSKCC.SEQ
#LOAD      := MAINDEC-10-DSKCD.SEQ
LOAD      := MAINDEC-10-DSKCE.SEQ

#LOAD     := MAINDEC-10-DSDZA.SEQ
#LOAD     := fixed.SEQ
#LOAD     := MAINDEC-10-DSKCG.fixed.txt
#LOAD     := MAINDEC-10-DSKCG.txt
#LOAD     := MAINDEC-10-DSKEA.txt
#LOAD     := smmon.txt

SRC := \
    $(RTL)/utils/utils.v \
	$(RTL)/cpu/useq/crom.v \
	$(RTL)/cpu/useq/drom.v \
	$(RTL)/cpu/useq/skip.v \
	$(RTL)/cpu/useq/stack.v \
	$(RTL)/cpu/useq/dispatch.v \
	$(RTL)/cpu/useq/useq.v \
	$(RTL)/cpu/alu.v \
	$(RTL)/cpu/apr.v \
	$(RTL)/cpu/bus.v \
	$(RTL)/cpu/byte_disp.v \
	$(RTL)/cpu/dbm.v \
	$(RTL)/cpu/dbus.v \
	$(RTL)/cpu/debug.v \
	$(RTL)/cpu/intf.v \
	$(RTL)/cpu/intr.v \
	$(RTL)/cpu/iolatch.v \
	$(RTL)/cpu/ni_disp.v \
	$(RTL)/cpu/pager.v \
	$(RTL)/cpu/pcflags.v \
	$(RTL)/cpu/pf_disp.v \
	$(RTL)/cpu/pxct.v \
	$(RTL)/cpu/ram1kx36.v \
	$(RTL)/cpu/ramfile.v \
	$(RTL)/cpu/regir.v \
	$(RTL)/cpu/scad.v \
	$(RTL)/cpu/timer.v \
	$(RTL)/cpu/timing.v \
	$(RTL)/cpu/vma.v \
	$(RTL)/cpu/cpu.v \
	$(RTL)/csl/csl.v \
	$(RTL)/mem/mem.v \
	$(RTL)/arb/arb.v \
	$(RTL)/uba/dz11/uart/uart_brg.v \
	$(RTL)/uba/dz11/uart/uart_rx.v \
	$(RTL)/uba/dz11/uart/uart_tx.v \
	$(RTL)/uba/dz11/uart/uart_bufrx.v \
	$(RTL)/uba/dz11/uart/uart_buftx.v \
	$(RTL)/uba/dz11/dzfifo.v \
	$(RTL)/uba/dz11/dz11.v \
	$(RTL)/uba/rh11/sd/sd.v \
	$(RTL)/uba/rh11/sd/sdspi.v \
	$(RTL)/uba/rh11/rpxx.v \
	$(RTL)/uba/rh11/sdaddr.v \
	$(RTL)/uba/rh11/rh11.v \
	$(RTL)/uba/uba.v \
	$(RTL)/ks10.v \
	$(RTL)/testbench.v

#	$(RTL)/uba/rh11/sd/sd.v \


INC := \
	$(RTL)/cpu/useq/crom.vh  \
	$(RTL)/cpu/useq/drom.vh  \
	$(RTL)/cpu/alu.vh \
	$(RTL)/cpu/apr.vh \
	$(RTL)/cpu/pager.vh \
	$(RTL)/cpu/pcflags.vh \
	$(RTL)/cpu/pxct.vh \
	$(RTL)/cpu/regir.vh \
	$(RTL)/cpu/vma.vh \
	$(RTL)/uba/dz11/uart/uart_brg.vh \
	$(RTL)/uba/dz11/dz11.vh \
	$(RTL)/uba/rh11/sd/sdspi.vh \
	$(RTL)/uba/rh11/sd/sd.vh \
	$(RTL)/uba/rh11/rpxx.vh \
	$(RTL)/uba/rh11/rh11.vh \
	$(RTL)/uba/uba.vh \
	$(RTL)/ks10.vh

DAT := \
	$(RTL)/cpu/useq/crom.dat \
	$(RTL)/cpu/useq/drom.dat \
	$(RTL)/ssram.dat

DOC := \
	$(RTL)/status.txt

UCF := \
	$(RTL)/$(PROJECT).ucf

BLD := \
	$(ISE)/ks10.xise \
	$(ISE)/ks10.gise \
	$(ISE)/ks10.wcfg

asdf :  $(INC) $(SRC) $(BLD) $(DAT) $(UCF) $(DOC)
	echo $(INC) $(SRC) $(BLD) $(DAT) $(UCF) $(DOC)

$(RTL)/cpu/useq/crom.dat  : $(RTL)/cpu/useq/ks10.mcr $(RTL)/cpu/useq/crom.awk makefile
	awk -f $(RTL)/cpu/useq/crom.awk $(RTL)/cpu/useq/ks10.mcr > $(RTL)/cpu/useq/crom.dat

$(RTL)/cpu/useq/drom.dat  : $(RTL)/cpu/useq/ks10.mcr $(RTL)/cpu/useq/drom.awk makefile
	awk -f $(RTL)/cpu/useq/drom.awk $(RTL)/cpu/useq/ks10.mcr > $(RTL)/cpu/useq/drom.dat

$(RTL)/ssram.dat : $(RTL)/$(LOAD) $(RTL)/ssram.awk makefile
	awk -f $(RTL)/ssram.awk -vfilename=$(LOAD) $(RTL)/$(LOAD) > $(RTL)/ssram.dat

clean: 
	rcsclean $(RTL)/*
	rcsclean $(RTL)/arb/*
	rcsclean $(RTL)/csl/*
	rcsclean $(RTL)/cpu/*
	rcsclean $(RTL)/mem/*
	rcsclean $(RTL)/uba/dz11/uart/*
	rcsclean $(RTL)/uba/dz11/*
	rcsclean $(RTL)/uba/rh11/sd/*
	rcsclean $(RTL)/uba/rh11/*
	rcsclean $(RTL)/uba/*
	rcsclean $(RTL)/cpu/useq/*
	rm -f    $(RTL)/cpu/useq/*.dat
	rm -f    $(RTL)/*.dat
	find . -type f -name "*~" | xargs rm -fv

archive_src: $(SRC)
	tar -czvf ks10_src_`date '+%y%m%d'`.tgz $(SRC)

archive_all:
	tar -czvf ks10_all_`date '+%y%m%d'`.tgz *

$(ISE)/$(PRJFILE) : makefile
	echo "Creating "$(ISE)/$(PRJFILE) > /dev/stderr
	echo "" > $@;
	for FILE in $(SRC); \
	do \
	    echo 'verilog work "../'$$FILE'"' >> $@; \
	done

$(ISE)/$(TESTBENCH) : $(ISE)/$(PRJFILE) makefile
	cd ise; \
	$(FUSE) \
	-intstyle ise \
	-incremental \
	-prj $(PRJFILE) \
	-o $(TESTBENCH) \
	work.testbench

test : $(ISE)/$(TESTBENCH).exe
	$(ISE)/$(TESTBENCH).exe \
	-gui \
	-intstyle ise \
	-tclbatch $(TESTBENCH).cmd \
	-wdb $(TESTBENCH).wdb


#./t10backup.exe   -x smmon.sav -f ks_diag_gs.tap

#	-prj testbench_beh.prj \
#	-lib unisims_ver \
#	-lib unimacro_ver \
#	-lib xilinxcorelib_ver \
#	-lib secureip \
#	echo 'verilog work "C:/Xilinx/13.1/ISE_DS/ISE//verilog/src/glbl.v"' >> $@
