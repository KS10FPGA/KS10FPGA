PROJECT   := esm_ks10
PART      := xc6slx45-2-fgg676

RTL       := rtl
ISE       := ise
#ISETEMP   := $(ISE)/temp
XILDIR    := `cygpath -u '$(XILINX)'`
XILEXE    := $(XILDIR)/ISE_DS/ISE/bin/nt64/
TOPMOD    := $(shell echo $(PROJECT) | tr a-z A-Z)

BITGEN    := $(XILEXE)/bitgen.exe
FUSE      := $(XILEXE)/fuse.exe
MAP       := $(XILEXE)/map.exe
NGD       := $(XILEXE)/ngdbuild.exe
PAR       := $(XILEXE)/par.exe
PROMGEN   := $(XILEXE)/promgen.exe
IMPACT    := $(XILEXE)/impact.exe
XST       := $(XILEXE)/xst.exe

WCFG      := ks10_useriot.wcfg

PRJFILE   := $(PROJECT).prj
TESTBENCH := $(PROJECT)_testbench
WORK      := work.testbench

LOAD      := MAINDEC-10-DSKAA.SEQ
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
#LOAD      := MAINDEC-10-DSKBA.SEQ
#LOAD      := MAINDEC-10-DSKCA.SEQ
#LOAD      := MAINDEC-10-DSKCB.SEQ
#LOAD      := MAINDEC-10-DSKCC.SEQ
#LOAD      := MAINDEC-10-DSKCD.SEQ
#LOAD      := MAINDEC-10-DSKCE-RD00.SEQ
#LOAD      := MAINDEC-10-DSKCF-RD00.SEQ	
#LOAD      := MAINDEC-10-DSKEA-RD00.SEQ		# fails early

#LOAD     := MAINDEC-10-DSDZA.SEQ
#LOAD     := fixed.SEQ
#LOAD     := MAINDEC-10-DSKCG.fixed.txt
#LOAD     := MAINDEC-10-DSKCG.txt

#LOAD     := smmon.txt

SRC := \
	$(RTL)/ks10/utils/edgetrig.v \
	$(RTL)/ks10/utils/sync.v \
	$(RTL)/ks10/cpu/useq/crom.v \
	$(RTL)/ks10/cpu/useq/drom.v \
	$(RTL)/ks10/cpu/useq/skip.v \
	$(RTL)/ks10/cpu/useq/stack.v \
	$(RTL)/ks10/cpu/useq/dispatch.v \
	$(RTL)/ks10/cpu/useq/useq.v \
	$(RTL)/ks10/cpu/alu.v \
	$(RTL)/ks10/cpu/apr.v \
	$(RTL)/ks10/cpu/bus.v \
	$(RTL)/ks10/cpu/byte_disp.v \
	$(RTL)/ks10/cpu/dbm.v \
	$(RTL)/ks10/cpu/dbus.v \
	$(RTL)/ks10/cpu/debug.v \
	$(RTL)/ks10/cpu/intf.v \
	$(RTL)/ks10/cpu/intr.v \
	$(RTL)/ks10/cpu/iolatch.v \
	$(RTL)/ks10/cpu/ni_disp.v \
	$(RTL)/ks10/cpu/pager.v \
	$(RTL)/ks10/cpu/pcflags.v \
	$(RTL)/ks10/cpu/pf_disp.v \
	$(RTL)/ks10/cpu/pxct.v \
	$(RTL)/ks10/cpu/ram1kx36.v \
	$(RTL)/ks10/cpu/ramfile.v \
	$(RTL)/ks10/cpu/regir.v \
	$(RTL)/ks10/cpu/scad.v \
	$(RTL)/ks10/cpu/timer.v \
	$(RTL)/ks10/cpu/timing.v \
	$(RTL)/ks10/cpu/vma.v \
	$(RTL)/ks10/cpu/cpu.v \
	$(RTL)/ks10/csl/csl.v \
	$(RTL)/ks10/mem/mem.v \
	$(RTL)/ks10/arb/arb.v \
	$(RTL)/ks10/uba/dz11/uart/uart_brg.v \
	$(RTL)/ks10/uba/dz11/uart/uart_rx.v \
	$(RTL)/ks10/uba/dz11/uart/uart_tx.v \
	$(RTL)/ks10/uba/dz11/uart/uart_bufrx.v \
	$(RTL)/ks10/uba/dz11/uart/uart_buftx.v \
	$(RTL)/ks10/uba/dz11/dzfifo.v \
	$(RTL)/ks10/uba/dz11/dz11.v \
	$(RTL)/ks10/uba/rh11/rpxx.v \
	$(RTL)/ks10/uba/rh11/sdaddr.v \
	$(RTL)/ks10/uba/rh11/rh11.v \
	$(RTL)/ks10/uba/uba.v \
	$(RTL)/ks10/ks10.v \
	$(RTL)/esm/esm_clk.v \
	$(RTL)/esm/esm_rst.v \
	$(RTL)/esm/esm_ks10.v

#	$(RTL)/ks10/uba/rh11/sd/sd.v \
#	$(RTL)/ks10/uba/rh11/sd/sdspi.v \


INC := \
	$(RTL)/ks10/cpu/useq/crom.vh  \
	$(RTL)/ks10/cpu/useq/drom.vh  \
	$(RTL)/ks10/cpu/alu.vh \
	$(RTL)/ks10/cpu/apr.vh \
	$(RTL)/ks10/cpu/pager.vh \
	$(RTL)/ks10/cpu/pcflags.vh \
	$(RTL)/ks10/cpu/pxct.vh \
	$(RTL)/ks10/cpu/regir.vh \
	$(RTL)/ks10/cpu/vma.vh \
	$(RTL)/ks10/uba/dz11/uart/uart_brg.vh \
	$(RTL)/ks10/uba/dz11/dz11.vh \
	$(RTL)/ks10/uba/rh11/sd/sdspi.vh \
	$(RTL)/ks10/uba/rh11/sd/sd.vh \
	$(RTL)/ks10/uba/rh11/rpxx.vh \
	$(RTL)/ks10/uba/rh11/rh11.vh \
	$(RTL)/ks10/ks10.vh

DAT := \
	$(RTL)/ks10/cpu/useq/crom.dat \
	$(RTL)/ks10/cpu/useq/drom.dat \
	$(RTL)/testbench/ssram.dat

DOC := \
	$(RTL)/status.txt

UCF := \
	$(RTL)/esm/esm_ks10.ucf

BLD := \
	$(ISE)/ks10.xise \
	$(ISE)/ks10.gise \
	$(ISE)/ks10.wcfg

TESTBENCH := \
	$(RTL)/esm/esm_testbench.v


asdf :  $(INC) $(SRC) $(BLD) $(DAT) $(UCF) $(DOC)
	echo $(INC) $(SRC) $(BLD) $(DAT) $(UCF) $(DOC)

$(RTL)/ks10/cpu/useq/crom.dat  : $(RTL)/ks10/cpu/useq/ks10.mcr $(RTL)/ks10/cpu/useq/crom.awk makefile
	awk -f $(RTL)/ks10/cpu/useq/crom.awk $(RTL)/ks10/cpu/useq/ks10.mcr > $(RTL)/ks10/cpu/useq/crom.dat

$(RTL)/ks10/cpu/useq/drom.dat  : $(RTL)/ks10/cpu/useq/ks10.mcr $(RTL)/ks10/cpu/useq/drom.awk makefile
	awk -f $(RTL)/ks10/cpu/useq/drom.awk $(RTL)/ks10/cpu/useq/ks10.mcr > $(RTL)/ks10/cpu/useq/drom.dat

$(RTL)/testbench/ssram.dat : $(RTL)/testbench/$(LOAD) $(RTL)/testbench/ssram.awk makefile
	awk -f $(RTL)/testbench/ssram.awk -vfilename=$(LOAD) $(RTL)/testbench/$(LOAD) > $(RTL)/testbench/ssram.dat

clean_rtl: 
	rcsclean $(RTL)/*
	rcsclean $(RTL)/testbench/*
	rcsclean $(RTL)/esm/*
	rcsclean $(RTL)/ks10/*
	rcsclean $(RTL)/ks10/arb/*
	rcsclean $(RTL)/ks10/csl/*
	rcsclean $(RTL)/ks10/cpu/*
	rcsclean $(RTL)/ks10/mem/*
	rcsclean $(RTL)/ks10/utils/*
	rcsclean $(RTL)/ks10/uba/dz11/uart/*
	rcsclean $(RTL)/ks10/uba/dz11/*
	rcsclean $(RTL)/ks10/uba/rh11/sd/*
	rcsclean $(RTL)/ks10/uba/rh11/*
	rcsclean $(RTL)/ks10/uba/*
	rcsclean $(RTL)/ks10/cpu/useq/*
	rm -f    $(RTL)/ks10/cpu/useq/*.dat
	rm -f    $(RTL)/testbench/*.dat
	find . -type f -name "*~" | xargs rm -fv

clean_ise:
	rcsclean $(ISE)/*
	rm -rf   $(ISE)/xst \
	         $(ISE)/_ngo \
	         $(ISE)/_xmsgs \
                 $(ISE)/iseconfig \
                 $(ISE)/xlnx_auto_0_xdb      
	rm -f    $(ISE)/$(PROJECT).bgn \
	         $(ISE)/$(PROJECT).bit \
	         $(ISE)/$(PROJECT).bld \
                 $(ISE)/$(PROJECT).cmd_log \
                 $(ISE)/$(PROJECT).drc \
                 $(ISE)/$(PROJECT).lso \
                 $(ISE)/$(PROJECT).ncd \
                 $(ISE)/$(PROJECT).ngc \
                 $(ISE)/$(PROJECT).ngd \
                 $(ISE)/$(PROJECT).ngr \
                 $(ISE)/$(PROJECT).pad \
                 $(ISE)/$(PROJECT).par \
                 $(ISE)/$(PROJECT).pcf\
                 $(ISE)/$(PROJECT).prj\
                 $(ISE)/$(PROJECT).ptwx \
                 $(ISE)/$(PROJECT).stx \
                 $(ISE)/$(PROJECT).twr \
                 $(ISE)/$(PROJECT).twx \
                 $(ISE)/$(PROJECT).unroutes \
                 $(ISE)/$(PROJECT).xpi \
                 $(ISE)/$(PROJECT).xst \
                 $(ISE)/$(PROJECT)_bitgen.xwbt \
                 $(ISE)/$(PROJECT)_envsettings.html \
                 $(ISE)/$(PROJECT)_guide.ncd \
                 $(ISE)/$(PROJECT)_map.map \
                 $(ISE)/$(PROJECT)_map.mrp \
                 $(ISE)/$(PROJECT)_map.ncd \
                 $(ISE)/$(PROJECT)_map.ngm \
                 $(ISE)/$(PROJECT)_map.xrpt \
                 $(ISE)/$(PROJECT)_ngdbuild.xrpt \
                 $(ISE)/$(PROJECT)_pad.csv \
                 $(ISE)/$(PROJECT)_pad.txt \
                 $(ISE)/$(PROJECT)_par.xrpt \
                 $(ISE)/$(PROJECT)_summary.html \
                 $(ISE)/$(PROJECT)_summary.xml \
                 $(ISE)/$(PROJECT)_usage.xml \
                 $(ISE)/$(PROJECT)_xst.log \
                 $(ISE)/$(PROJECT)_xst.xrpt \
                 $(ISE)/par_usage_statistics.html \
                 $(ISE)/usage_statistics_webtalk.html \
                 $(ISE)/webtalk.log \
                 $(ISE)/webtalk_pn.xml





archive_src: $(SRC)
	tar -czvf ks10_fpga_src_`date '+%y%m%d'`.tgz $(SRC)

archive_all:
	tar -czvf ks10_fpga_all_`date '+%y%m%d'`.tgz *

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

#
# Filter file
#
#	'    <filter task="xst" file="Xst" num="647" type="warning"></filter>'  \
#	'    <filter task="xst" file="Xst" num="2677" type="warning"></filter>' \

FILTER_FILE    := $(ISE)/$(PROJECT).filter

FILTER_ARGS    := \
	'<filters xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="filter.xsd">' \
	'</filters>'

$(FILTER_FILE) : makefile
	@echo "Creating "$(FILTER_FILE) > /dev/stderr
	@echo "" > $@
	@for FIL in $(FILTER_ARGS); \
	do \
	    echo $$FIL >> $@; \
	done

#
# xst
#
# xst options:
#
#   -filter               : Filter File
#   -intstyle             : Integration Style

#	'set -tmpdir "/tmp"' \

XST_OPTS := \
	-filter $(FILTER_FILE) \
	-intstyle ise 

XST_CMDS := \
	'set -xsthdpdir "$(ISE)/xst"' \
	'run' \
	'-ifn $(ISE)/$(PROJECT).prj' \
	'-ofn $(ISE)/$(PROJECT)' \
	'-ofmt ngc' \
	'-p $(PART)' \
	'-top $(TOPMOD)' \
	'-opt_mode Speed' \
	'-opt_level 2' \
	'-power NO' \
	'-iuc NO' \
	'-keep_hierarchy No' \
	'-netlist_hierarchy As_Optimized' \
	'-rtlview Yes' \
	'-glob_opt AllClockNets' \
	'-read_cores YES' \
	'-write_timing_constraints NO' \
	'-cross_clock_analysis NO' \
	'-hierarchy_separator /' \
	'-bus_delimiter <>' \
	'-case Maintain' \
	'-slice_utilization_ratio 100' \
	'-bram_utilization_ratio 100' \
	'-dsp_utilization_ratio 100' \
	'-lc Auto' \
	'-reduce_control_sets Auto' \
	'-fsm_extract YES -fsm_encoding Auto' \
	'-safe_implementation No' \
	'-fsm_style LUT' \
	'-ram_extract Yes' \
	'-ram_style Auto' \
	'-rom_extract Yes' \
	'-shreg_extract YES' \
	'-rom_style Auto' \
	'-auto_bram_packing NO' \
	'-resource_sharing NO' \
	'-async_to_sync YES' \
	'-shreg_min_size 2' \
	'-use_dsp48 Auto' \
	'-iobuf YES' \
	'-max_fanout 100000' \
	'-bufg 16' \
	'-register_duplication YES' \
	'-register_balancing Forward' \
	'-move_first_stage YES' \
	'-move_last_stage YES' \
	'-optimize_primitives NO' \
	'-use_clock_enable Auto' \
	'-use_sync_set Auto' \
	'-use_sync_reset Auto' \
	'-iob Auto' \
	'-equivalent_register_removal YES' \
	'-slice_utilization_ratio_maxmargin 5'

$(ISE)/$(PROJECT).xst : makefile
	echo "Creating "$(ISE)/$(PROJECT).xst > /dev/stderr
	echo "" > $@
	for CMD in $(XST_CMDS); \
	do \
	    echo $$CMD >> $@; \
	done

$(ISE)/$(PROJECT).prj : makefile
	echo "Creating "$(ISE)/$(PROJECT).prj > /dev/stderr
	echo "" > $@
	for FILE in $(SRC); \
	do \
	    echo 'verilog work "../'$$FILE'"' >> $@; \
	done

$(ISE)/$(PROJECT).ngc $(ISE)/$(PROJECT).ngr : $(ISE)/$(PROJECT).xst $(ISE)/$(PROJECT).prj $(FILTER_FILE) makefile
	$(XST) $(XST_OPTS) -ifn $(ISE)/$(PROJECT).xst -ofn $(ISE)/$(PROJECT)_xst.log
	mv $(PROJECT).lso $(ISE)/$(PROJECT).lso

#
# ngdbuild
#
# "NGDBuild reads in a netlist file in EDIF or NGC format and creates a Xilinx® Native
# Generic Database (NGD) file that contains a logical description of the design in terms of
# logic elements, such as AND gates, OR gates, LUTs, flip-flops, and RAMs"
#
# ngdbuild [options] design_name [ngd_file[.ngd]]
#
# Ngdbuild options:
#
#   -dd                   : Destination Directory
#   -filter               : Filter File
#   -intstyle             : Integration Style {ise|xflow|silent}
#   -nt                   : Netlist Translation Type {timestamp|on|off}
#   -p                    : Part number
#   -uc                   : User Constraints File
#

NGD_OPTS := \
	-dd _ngo \
	-filter $(FILTER_FILE) \
	-intstyle ise \
	-nt timestamp \
	-p $(PART) \
	-uc $(RTL)/esm/$(PROJECT).ucf 

$(ISE)/$(PROJECT).ngd : $(ISE)/$(PROJECT).ngc $(RTL)/esm/$(PROJECT).ucf $(FILTER_FILE) makefile
	$(NGD) $(NGD_OPTS) $(ISE)/$(PROJECT).ngc $(ISE)/$(PROJECT).ngd

#
# Map Options:
#
#   -filter               : Filter File
#   -global_opt           : Global optimizations {off|speed|area|power}
#   -intstyle             : Integration Style
#   -ir                   : Do Not Use RLOCs to Generate RPMs {all|off|place}
#   -lc                   : LUT Combining {off|auto|area}
#   -logic_opt            : Logic Optimization {on|off}
#   -mt                   : Multi-threading {off|2}
#   -ol                   : Overall Effort Level {std|high}
#   -p                    : Part number
#   -power                : Power Optimization
#   -pr                   : Pack Registers in I/O
#   -r                    : Register Ordering
#   -register_duplication : Duplicate Registers
#   -t                    : Placer Cost Table
#   -w                    : Overwrite files
#   -xe                   : Extra Effort Level
#   -xt                   : Extra Placer Cost Table

MAP_OPTS := \
	-filter $(FILTER_FILE) \
	-global_opt off \
	-intstyle ise \
	-ir off \
	-lc off \
	-logic_opt off \
	-mt 2 \
	-ol high \
	-p $(PART) \
	-power off \
	-pr off \
	-r 4 \
	-register_duplication off \
	-t 1 \
	-w \
	-xe n \
	-xt 0


#map -filter "J:/PDPx/pdp10/KS10/fpga/ise/iseconfig/filter.filter" -intstyle ise -p xc6slx45-fgg676-2 -w -logic_opt off -ol high -xe n -t 1 -xt 0 -register_duplication off -r 4 -global_opt off -mt 2 -ir off -pr off -lc off -power off -o ESM_KS10_map.ncd ESM_KS10.ngd ESM_KS10.pcf

$(ISE)/$(PROJECT)_map.ngd $(ISE)/$(PROJECT).pcf : $(ISE)/$(PROJECT).ngd $(FILTER_FILE) makefile
	$(MAP) $(MAP_OPTS) -o $(ISE)/$(PROJECT)_map.ncd $(ISE)/$(PROJECT).ngd $(ISE)/$(PROJECT).pcf

#
# Place and Route
#
# par [options] infile[.ncd] outfile [pcf_file[.pcf]]
#
# par options:
#
#   -filter               : Filter File
#   -intstyle             : Integration Style
#   -mt                   : Multi-threading {off|2|3|4}
#   -ol                   : Overall Effort Level {std|high}
#   -w                    : Overwrite files
#   -xe                   : Extra Effort Level {n|c}
#

PAR_OPTS := \
	-filter $(FILTER) \
	-intstyle ise \
	-mt 4 \
	-ol high \
	-w \
	-xe n

$(ISE)/$(PROJECT).ncd : $(ISE)/$(PROJECT)_map.ncd $(ISE)/$(PROJECT).pcf $(FILTER) makefile
	$(PAR) $(PAR_OPTS) $(ISE)/$(PROJECT)_map.ncd $(ISE)/$(PROJECT).ncd $(ISE)/$(PROJECT).pcf


#par -filter "J:/PDPx/pdp10/KS10/fpga/ise/iseconfig/filter.filter" -w -intstyle ise -ol high -xe n -mt 4 ESM_KS10_map.ncd ESM_KS10.ncd ESM_KS10.pcf


#
# Generate Bit file from NCD file.
#

BITGEN_OPTS := \
	-w \
	-intstyle ise \
	-g DebugBitstream:No \
	-g Binary:no \
	-g CRC:Enable \
	-g Reset_on_err:No \
	-g ConfigRate:2 \
	-g ProgPin:PullUp \
	-g TckPin:PullUp \
	-g TdiPin:PullUp \
	-g TdoPin:PullUp \
	-g TmsPin:PullUp \
	-g UnusedPin:PullDown \
	-g UserID:0xFFFFFFFF \
	-g ExtMasterCclk_en:No \
	-g SPI_buswidth:1 \
	-g TIMER_CFG:0xFFFF \
	-g multipin_wakeup:No \
	-g StartUpClk:Cclk \
	-g DONE_cycle:4 \
	-g GTS_cycle:5 \
	-g GWE_cycle:6 \
	-g LCK_cycle:NoWait \
	-g Security:None \
	-g DonePipe:No \
	-g DriveDone:No \
	-g en_sw_gsr:No \
	-g drive_awake:No \
	-g sw_clk:Startupclk \
	-g sw_gwe_cycle:5 \
	-g sw_gts_cycle:4

$(ISE)/$(PROJECT).bit : $(ISE)/$(PROJECT).ncd
	$(BITGEN) $(BITGEN_OPTS) $(ISE)/$(PROJECT).ncd $(ISE)/$(PROJECT).bit

#
# Create the Intel Hex file for loading into the serial flash.
#

PROMGEN_OPTS := \
	-w \
	-spi \
	-p mcs \
	-c ff \
	-s 4096 \
	-u 0000 

$(ISE)/$(PROJECT).mcs : $(ISE)/$(PROJECT).bit makefile
	$(PROMGEN) $(PROMGEN_OPTS) $(ISE)/$(PROJECT).bit -o $(ISE)/$(PROJECT).mcs

#
# Generate Impact command (batch) file.
# Gosh the documentation for impact is really poor.
#

$(ISE)/impact.cmd : makefile
	echo "setmode -bscan" > $@
	echo "setcable -p auto" >> $@
	echo "identify -inferir" >> $@
	echo "identifyMPM " >> $@
	echo "attachflash -position 1 -spi S25FL032P" >> $@
	echo "assignfiletoattachedflash -position 1 -file $(ISE)/$(PROJECT).mcs" >> $@
	echo "program -p 1 -dataWidth 1 -spionly -e -v -loadfpga " >> $@
	echo "quit" >> $@

#
# Run Xilinx Impact to program the KS10 S25FL032P SPI Flash
#

load : $(ISE)/$(PROJECT).mcs $(ISE)/impact.cmd
	$(IMPACT) -batch $(ISE)/impact.cmd


#./t10backup.exe   -x smmon.sav -f ks_diag_gs.tap

#	-prj testbench_beh.prj \
#	-lib unisims_ver \
#	-lib unimacro_ver \
#	-lib xilinxcorelib_ver \
#	-lib secureip \
#	echo 'verilog work "C:/Xilinx/13.1/ISE_DS/ISE//verilog/src/glbl.v"' >> $@
