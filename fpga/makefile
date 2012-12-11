RTL  := rtl
ISE  := ISE

ARB  := $(RTL)/arb
CSL  := $(RTL)/csl
CPU  := $(RTL)/cpu
ISE  := $(ISE)
MEM  := $(RTL)/mem
UBA  := $(RTL)/uba
UC   := $(CPU)/useq
LOAD := MAINDEC-10-DSKEA.txt
#LOAD := smmon.txt

SRC := \
	$(UC)/crom.vh  \
	$(UC)/crom.v   \
	$(UC)/crom.dat \
	$(UC)/drom.vh  \
	$(UC)/drom.v   \
	$(UC)/drom.dat \
	$(UC)/skip.v   \
	$(UC)/stack.v  \
	$(UC)/dispatch.v   \
	$(UC)/useq.v \
	$(CPU)/ac_block.v \
	$(CPU)/alu.v \
	$(CPU)/apr.v \
	$(CPU)/bus.v \
	$(CPU)/byte_disp.v \
	$(CPU)/cache.v \
	$(CPU)/dbm.v \
	$(CPU)/dbus.v \
	$(CPU)/debug.v \
	$(CPU)/intf.v \
	$(CPU)/intr.v \
	$(CPU)/iolatch.v \
	$(CPU)/ni_disp.v \
	$(CPU)/pager.v \
	$(CPU)/pcflags.v \
	$(CPU)/pf_disp.v \
	$(CPU)/pxct.v \
	$(CPU)/ram1kx36.v \
	$(CPU)/ramfile.v \
	$(CPU)/regir.v \
	$(CPU)/scad.v \
	$(CPU)/timer.v \
	$(CPU)/timing.v \
	$(CPU)/traps.v \
	$(CPU)/vma.v \
	$(CPU)/cpu.v \
	$(CSL)/csl.v \
	$(MEM)/mem.v \
	$(ARB)/arb.v \
	$(UBA)/dz11/uart/demet.vhd \
	$(UBA)/dz11/uart/ascii_types.vhd \
	$(UBA)/dz11/uart/uart_types.vhd \
	$(UBA)/dz11/uart/uart_brg.vhd \
	$(UBA)/dz11/uart/uart_rx.vhd \
	$(UBA)/dz11/uart/uart_tx.vhd \
	$(UBA)/dz11/fifo.v \
	$(UBA)/dz11/dz11.v \
	$(UBA)/ubapag.v \
	$(UBA)/uba.v \
	$(RTL)/ks10.v \
	$(RTL)/ks10.ucf \
	$(RTL)/status.txt \
	$(RTL)/ssram.dat \
	$(RTL)/testbench.v

BLD := \
	$(ISE)/ks10.xise \
	$(ISE)/ks10.gise \
	$(ISE)/ks10.wcfg

asdf : $(SRC) $(BLD)
	echo $(SRC) $(BLD)

$(UC)/crom.dat  : $(UC)/ks10.mcr $(UC)/crom.awk makefile
	awk -f $(UC)/crom.awk $(UC)/ks10.mcr > $(UC)/crom.dat

$(UC)/drom.dat  : $(UC)/ks10.mcr $(UC)/drom.awk makefile
	awk -f $(UC)/drom.awk $(UC)/ks10.mcr > $(UC)/drom.dat

$(RTL)/ssram.dat : $(RTL)/$(LOAD) $(RTL)/ssram.awk makefile
	awk -f $(RTL)/ssram.awk -vfilename=$(LOAD) $(RTL)/$(LOAD) > $(RTL)/ssram.dat

clean: 
	rcsclean $(RTL)/*
	rcsclean $(ARB)/*
	rcsclean $(CSL)/*
	rcsclean $(CPU)/*
	rcsclean $(MEM)/*
	rcsclean $(UBA)/dz11/uart/*
	rcsclean $(UBA)/dz11/*
	rcsclean $(UBA)/*
	rcsclean $(UC)/*
	rm -f    $(UC)/*.dat
	rm -f    $(RTL)/*.dat
	find . -type f -name "*~" | xargs rm -fv

archive_src: $(SRC)
	tar -czvf ks10_src_`date '+%y%m%d'`.tgz $(SRC)

archive_all:
	tar -czvf ks10_all_`date '+%y%m%d'`.tgz *

fuse := /cygdrive/c/Xilinx/13.3/ISE_DS/ISE/bin/nt64/fuse.exe

testbench_isim_beh.exe fuse :
	cd ise;$(fuse) \
	-intstyle ise \
	-incremental \
	-lib unisims_ver \
	-lib unimacro_ver \
	-lib xilinxcorelib_ver \
	-lib secureip \
	-o E:/PDPx/pdp10/KS10/fpga/ise/testbench_isim_beh.exe \
	-prj E:/PDPx/pdp10/KS10/fpga/ise/testbench_beh.prj \
	work.testbench

testbench :
	ise/testbench_isim_beh.exe -gui
