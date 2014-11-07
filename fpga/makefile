#
# Project name.   Also top-level entity name (upper case)
#

PROJECT      := esm_ks10
RTLTOP       := ESM_KS10
SIMTOP       := testbench

#
# FPGA partnumber
#

PART         := xc6slx45-2-fgg676

#
# Directory structure
#

RTL          := rtl
ISE          := ise
TESTFILES    := $(RTL)/testbench
USEQ         := $(RTL)/ks10/cpu/useq
TESTSUITE    := testsuite

#
# Xilinx tools
#

XILDIR       := $(shell cygpath -u '$(XILINX)')
XILEXE       := $(XILDIR)/ISE_DS/ISE/bin/nt64
BITGEN       := $(XILEXE)/bitgen.exe
FUSE         := $(XILEXE)/fuse.exe
MAP          := $(XILEXE)/map.exe
NGD          := $(XILEXE)/ngdbuild.exe
PAR          := $(XILEXE)/par.exe
PROMGEN      := $(XILEXE)/promgen.exe
IMPACT       := $(XILEXE)/impact.exe
XST          := $(XILEXE)/xst.exe
INTSTYLE     := ise
XILPATH      := $(XILDIR)/ISE_DS/ISE/bin/nt64:$(XILDIR)/ISE_DS/ISE/lib/nt64:$(XILDIR)/ISE_DS/common/bin/nt64:$(XILDIR)/ISE_DS/common/lib/nt64

#
# iverilog
#

IVERILOG     := iverilog
VVP          := vvp

#
# Initialized Memory Contents (Simulation only)
#

#DIAG         := DSKAA		#    1.0 ms
#DIAG         := DSKAB		#    1.1 ms
#DIAG         := DSKAC		#    0.8 ms
#DIAG         := DSKAD		#    0.9 ms
#DIAG         := DSKAE		#    0.7 ms
#DIAG         := DSKAF		#    0.8 ms
#DIAG         := DSKAG		#    0.5 ms
#DIAG         := DSKAH		#   15.0 ms
#DIAG         := DSKAI		#    2.4 ms
#DIAG         := DSKAJ		#    2.8 ms
#DIAG         := DSKAK		#    4.2 ms
#DIAG         := DSKAL		#    4.7 ms
#DIAG         := DSKAM		#    2.3 ms
#DIAG         := DSKBA-RD00  	#    1.0 ms FAIL
#DIAG         := DSKCA		#    1.9 ms
#DIAG         := DSKCB		#    1.3 ms
#DIAG         := DSKCC		#    2.1 ms
#DIAG         := DSKCD		#    5.2 ms
#DIAG         := DSKCE-RD00	#    5.7 ms
#DIAG         := DSKCF-RD00	#   10.6 ms	
#DIAG         := DSKCG		# 1350.0 ms FAIL
#DIAG         := DSKDA-RD00	#    5.3 ms FAIL
#DIAG         := DSKEA-RD00	#  452.5 ms FAIL
#DIAG         := DSUBA-RD00	#  108.0 ms
#DIAG         := DSDZA-RD00	# 2411.8 ms
#DIAG         := DSRPA-RD00	#  ???.? ms FAIL

PREFIX       := MAINDEC-10-

DIAGBASE     := $(shell echo "$(DIAG)" | sed -e 's/-.*//')     # strip the RD00-XXXX suffix

DIAGFILES := \
        $(TESTFILES)/${PREFIX}DSKAA.SEQ \
        $(TESTFILES)/${PREFIX}DSKAB.SEQ \
        $(TESTFILES)/${PREFIX}DSKAC.SEQ \
        $(TESTFILES)/${PREFIX}DSKAD.SEQ \
        $(TESTFILES)/${PREFIX}DSKAE.SEQ \
        $(TESTFILES)/${PREFIX}DSKAF.SEQ \
        $(TESTFILES)/${PREFIX}DSKAG.SEQ \
        $(TESTFILES)/${PREFIX}DSKAH.SEQ \
        $(TESTFILES)/${PREFIX}DSKAI.SEQ \
        $(TESTFILES)/${PREFIX}DSKAJ.SEQ \
        $(TESTFILES)/${PREFIX}DSKAK.SEQ \
        $(TESTFILES)/${PREFIX}DSKAL.SEQ \
        $(TESTFILES)/${PREFIX}DSKAM.SEQ \
        $(TESTFILES)/${PREFIX}DSKBA.SEQ \
        $(TESTFILES)/${PREFIX}DSKCA.SEQ \
        $(TESTFILES)/${PREFIX}DSKCB.SEQ \
        $(TESTFILES)/${PREFIX}DSKCC.SEQ \
        $(TESTFILES)/${PREFIX}DSKCD.SEQ \
        $(TESTFILES)/${PREFIX}DSKCE-RD00.SEQ \
        $(TESTFILES)/${PREFIX}DSKCF-RD00.SEQ \
        $(TESTFILES)/${PREFIX}DSKCG.SEQ \
        $(TESTFILES)/${PREFIX}DSKDA-RD00.SEQ \
        $(TESTFILES)/${PREFIX}DSKEA-RD00.SEQ \
        $(TESTFILES)/${PREFIX}DSDZA-RD00.SEQ

#
# Verilog source files
#

RTL_SRC := \
	$(RTL)/ks10/utils/edgetrig.v \
	$(RTL)/ks10/utils/sync.v \
	$(RTL)/ks10/clk/clk.v \
	$(RTL)/ks10/csl/csl.v \
	$(RTL)/ks10/mem/mem.v \
	$(RTL)/ks10/arb/arb.v \
	$(RTL)/ks10/cpu/useq/crom.v \
	$(RTL)/ks10/cpu/useq/drom.v \
	$(RTL)/ks10/cpu/useq/skip.v \
	$(RTL)/ks10/cpu/useq/stack.v \
	$(RTL)/ks10/cpu/useq/dispatch.v \
	$(RTL)/ks10/cpu/useq/useq.v \
	$(RTL)/ks10/cpu/alu.v \
	$(RTL)/ks10/cpu/apr.v \
	$(RTL)/ks10/cpu/bus.v \
	$(RTL)/ks10/cpu/disp_byte.v \
	$(RTL)/ks10/cpu/disp_ni.v \
	$(RTL)/ks10/cpu/disp_pf.v \
	$(RTL)/ks10/cpu/dbm.v \
	$(RTL)/ks10/cpu/dbus.v \
	$(RTL)/ks10/cpu/debug.v \
	$(RTL)/ks10/cpu/intf.v \
	$(RTL)/ks10/cpu/nxd.v \
	$(RTL)/ks10/cpu/nxm.v \
	$(RTL)/ks10/cpu/pager.v \
	$(RTL)/ks10/cpu/pcflags.v \
	$(RTL)/ks10/cpu/pi.v \
	$(RTL)/ks10/cpu/pxct.v \
	$(RTL)/ks10/cpu/ram1kx36.v \
	$(RTL)/ks10/cpu/ramfile.v \
	$(RTL)/ks10/cpu/regir.v \
	$(RTL)/ks10/cpu/scad.v \
	$(RTL)/ks10/cpu/timer.v \
	$(RTL)/ks10/cpu/timing.v \
	$(RTL)/ks10/cpu/vma.v \
	$(RTL)/ks10/cpu/cpu.v \
	$(RTL)/ks10/uba/dz11/uart/uart_brg.v \
	$(RTL)/ks10/uba/dz11/uart/uart_rx.v \
	$(RTL)/ks10/uba/dz11/uart/uart_tx.v \
	$(RTL)/ks10/uba/dz11/dzcsr.v \
	$(RTL)/ks10/uba/dz11/dzmsr.v \
	$(RTL)/ks10/uba/dz11/dztcr.v \
	$(RTL)/ks10/uba/dz11/dztdr.v \
	$(RTL)/ks10/uba/dz11/dzintr.v \
	$(RTL)/ks10/uba/dz11/dzrbuf.v \
	$(RTL)/ks10/uba/dz11/dzscan.v \
	$(RTL)/ks10/uba/dz11/dzuart.v \
	$(RTL)/ks10/uba/dz11/dz11.v \
	$(RTL)/ks10/uba/rh11/rpxx.v \
	$(RTL)/ks10/uba/rh11/sdaddr.v \
	$(RTL)/ks10/uba/rh11/rh11.v \
	$(RTL)/ks10/uba/rh11/rhba.v \
	$(RTL)/ks10/uba/rh11/rhwc.v \
	$(RTL)/ks10/uba/rh11/rhcs1.v \
	$(RTL)/ks10/uba/rh11/rhcs2.v \
	$(RTL)/ks10/uba/rh11/sd/sd.v \
	$(RTL)/ks10/uba/rh11/sd/sdspi.v \
	$(RTL)/ks10/uba/uba.v \
	$(RTL)/ks10/uba/ubasr.v \
	$(RTL)/ks10/uba/ubapag.v \
	$(RTL)/ks10/uba/ubanxd.v \
	$(RTL)/ks10/uba/ubaintr.v \
	$(RTL)/ks10/ks10.v \
	$(RTL)/esm/esm_ks10.v

SIM_SRC := \
	$(RTL)/esm/cy7c1460av33.v \
	$(RTL)/esm/esm_testbench.v

#
# Verilog inlcude files
#

INC := \
	$(RTL)/ks10/cpu/useq/crom.vh  \
	$(RTL)/ks10/cpu/useq/drom.vh  \
	$(RTL)/ks10/cpu/alu.vh \
	$(RTL)/ks10/cpu/apr.vh \
	$(RTL)/ks10/cpu/bus.vh \
	$(RTL)/ks10/cpu/debug_dskah.vh \
	$(RTL)/ks10/cpu/debug_dskba.vh \
	$(RTL)/ks10/cpu/debug_dskcg.vh \
	$(RTL)/ks10/cpu/debug_dskea.vh \
	$(RTL)/ks10/cpu/debug_dsuba.vh \
	$(RTL)/ks10/cpu/debug_dsdza.vh \
	$(RTL)/ks10/cpu/debug_default.vh \
	$(RTL)/ks10/cpu/pager.vh \
	$(RTL)/ks10/cpu/pcflags.vh \
	$(RTL)/ks10/cpu/pxct.vh \
	$(RTL)/ks10/cpu/regir.vh \
	$(RTL)/ks10/cpu/vma.vh \
	$(RTL)/ks10/uba/dz11/dz11.vh \
	$(RTL)/ks10/uba/dz11/dzcsr.vh \
	$(RTL)/ks10/uba/dz11/dzlpr.vh \
	$(RTL)/ks10/uba/dz11/dzrbuf.vh \
	$(RTL)/ks10/uba/dz11/dztcr.vh \
	$(RTL)/ks10/uba/dz11/dztdr.vh \
	$(RTL)/ks10/uba/dz11/dzuart.vh \
	$(RTL)/ks10/uba/rh11/sd/sdspi.vh \
	$(RTL)/ks10/uba/rh11/sd/sd.vh \
	$(RTL)/ks10/uba/rh11/rhba.vh \
	$(RTL)/ks10/uba/rh11/rhwc.vh \
	$(RTL)/ks10/uba/rh11/rhcs1.vh \
	$(RTL)/ks10/uba/rh11/rhcs2.vh \
	$(RTL)/ks10/uba/rh11/rpcs1.vh \
	$(RTL)/ks10/uba/rh11/rpda.vh \
	$(RTL)/ks10/uba/rh11/rpds.vh \
	$(RTL)/ks10/uba/rh11/rper1.vh \
	$(RTL)/ks10/uba/rh11/rpof.vh \
	$(RTL)/ks10/uba/rh11/rpxx.vh \
	$(RTL)/ks10/uba/rh11/rh11.vh \
	$(RTL)/ks10/uba/uba.vh \
	$(RTL)/ks10/uba/ubasr.vh \
	$(RTL)/ks10/uba/ubabus.vh \
	$(RTL)/ks10/ks10.vh

DAT := \
	$(RTL)/ks10/cpu/useq/crom.dat \
	$(RTL)/ks10/cpu/useq/drom.dat \
	$(RTL)/testbench/ssram.dat

DOC := \
	$(RTL)/status.txt \
	$(RTL)/fixme.txt

BLD := \
	$(ISE)/esm_ks10.xise \
	$(ISE)/esm_ks10.gise \
	$(ISE)/esm_ks10.wcfg

#
# Filter file arguments
#

FILTER_ARGS := \
	'<filters xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="filter.xsd">' \
	'    <filter task="map" file="Map" num="284"  type="warning"></filter>'  \
	'    <filter task="xst" file="Xst" num="647"  type="warning"></filter>'  \
	'    <filter task="xst" file="Xst" num="1710" type="warning"></filter>'  \
	'    <filter task="xst" file="Xst" num="1895" type="warning"></filter>'  \
	'    <filter task="xst" file="Xst" num="2677" type="warning"></filter>'  \
	'</filters>'

build: $(ISE)/$(PROJECT).mcs

#
# Create the "Control ROM" microcode for microsequencer
#

$(USEQ)/crom.dat: $(USEQ)/ks10.mcr $(USEQ)/crom.awk
	awk -f $(USEQ)/crom.awk $(USEQ)/ks10.mcr > $(USEQ)/crom.dat

#
# Create the "Dispatch ROM" microcode for microsequencer
#

$(USEQ)/drom.dat: $(USEQ)/ks10.mcr $(USEQ)/drom.awk
	awk -f $(USEQ)/drom.awk $(USEQ)/ks10.mcr > $(USEQ)/drom.dat

#
# Initialize the SSRAM with MAINDEC (simulation only)
# Note special rule for force ssram.dat to rebuild
#

$(TESTFILES)/ssram.dat : FORCE
FORCE:

$(TESTFILES)/ssram.dat : $(TESTFILES)/${PREFIX}$(DIAG).SEQ $(TESTFILES)/ssram.awk makefile
	awk -f $(TESTFILES)/ssram.awk -vfilename=${PREFIX}$(DIAG).SEQ $(TESTFILES)/${PREFIX}$(DIAG).SEQ > $(TESTFILES)/ssram.dat

$(ISE)/$(PROJECT).filter: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for FIL in $(FILTER_ARGS); \
	do \
	    echo $$FIL >> $@; \
	done

$(ISE)/$(PROJECT).xst: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(XST_CMDS); \
	do \
	    echo $$CMD >> $@; \
	done

$(ISE)/$(PROJECT).prj: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for FILE in $(RTL_SRC); \
	do \
	    echo 'verilog work "../'$$FILE'"' >> $@; \
	done

$(ISE)/$(PROJECT)_isim.prj: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for FILE in $(RTL_SRC); \
	do \
	    echo 'verilog work "../'$$FILE'"' >> $@; \
	done
	@for FILE in $(SIM_SRC); \
	do \
	    echo 'verilog work "../'$$FILE'"' >> $@; \
	done
	echo 'verilog work "$(XILINX)/ISE_DS/ISE/verilog/src/glbl.v"' >> $@;

$(ISE)/$(PROJECT)_isim.cmd: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(ISIM_CMDS); \
	do \
	    echo $$CMD >> $@; \
	done

$(ISE)/$(PROJECT)_impact.cmd: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(IMPACT_CMDS); \
	do \
	    echo $$CMD >> $@; \
	done

#
# FUSE
#

FUSE_ARGS := \
        -d DEBUG_$(DIAGBASE) \
	-d DEBUG=$(DIAGBASE) \
        -d SMALL_MEM \
        -d XILINX \
	-intstyle $(INTSTYLE) \
	-incremental \
	-o   $(PROJECT)_isim.exe \
	-prj $(PROJECT)_isim.prj \
	-lib unisims_ver \
	-lib unimacro_ver \
	-lib secureip \
	-lib xilinxcorelib_ver \
	work.$(SIMTOP) \
	work.glbl

$(ISE)/$(PROJECT)_isim.exe: $(ISE)/$(PROJECT)_isim.prj $(RTL_SRC) $(SIM_SRC) $(INC) $(DAT) makefile
	cd $(ISE); \
	$(FUSE) $(FUSE_ARGS)

#
# ISIM Commands
#

ISIM_CMDS := \
	'onerror {resume}' \
	'isim set maxtraceablesize 1180000'

ISIM_ARGS := \
	-intstyle $(INTSTYLE) \
	-gui \
	-tclbatch $(PROJECT)_isim.cmd \
	-view $(PROJECT).wcfg \
	-wdb c:/temp/$(PROJECT).wdb

isim: $(ISE)/$(PROJECT)_isim.exe $(ISE)/$(PROJECT)_isim.cmd $(ISE)/$(PROJECT).wcfg makefile
	@cd $(ISE); \
	export PATH=$(XILPATH):$$PATH; \
	./$(PROJECT)_isim.exe $(ISIM_ARGS) &

#
# xst
#
# xst options:
#
#   -filter                    : Filter File
#   -intstyle                  : Integration Style
#   -write_timing_constraints  : Write timing constraints
#

XST_OPTS := \
	-filter $(PROJECT).filter \
	-intstyle $(INTSTYLE) 

XST_CMDS := \
	'set -xsthdpdir "xst"' \
	'run' \
	'-ifn $(PROJECT).prj' \
	'-iuc NO' \
	'-ofn $(PROJECT).ngc' \
	'-ofmt ngc' \
	'-p $(PART)' \
	'-top $(RTLTOP)' \
	'-opt_mode Speed' \
	'-opt_level 2' \
	'-power NO' \
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

$(ISE)/$(PROJECT).ngc $(ISE)/$(PROJECT).ngr: $(ISE)/$(PROJECT).xst $(ISE)/$(PROJECT).prj $(ISE)/$(PROJECT).filter $(RTL)/esm/$(PROJECT).ucf $(RTL_SRC) $(INC) $(DAT) makefile
	cd $(ISE); \
	$(XST) $(XST_OPTS) -ifn $(PROJECT).xst -ofn $(PROJECT)_xst.log

#
# ngdbuild
#
# "NGDBuild reads in a netlist file in EDIF or NGC format and creates a Xilinx® Native
# Generic Database (NGD) file that contains a logical description of the design in terms of
# logic elements, such as AND gates, OR gates, LUTs, flip-flops, and RAMs"
#
# usage:
#   ngdbuild [options] design_name [ngd_file[.ngd]]
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
	-filter $(PROJECT).filter \
	-intstyle $(INTSTYLE) \
	-nt timestamp \
	-p $(PART) \
	-uc ../$(RTL)/esm/$(PROJECT).ucf

$(ISE)/$(PROJECT).ngd: $(ISE)/$(PROJECT).ngc $(RTL)/esm/$(PROJECT).ucf $(ISE)/$(PROJECT).filter makefile
	cd $(ISE); \
	$(NGD) $(NGD_OPTS) $(PROJECT).ngc $(PROJECT).ngd

#
# MAP
#
# The MAP program maps a logical design to a Xilinx® FPGA. The
# input to MAP is an NGD file, which is generated using the
# NGDBuild program.
#
# usage:
#    map [options] infile[.ngd] [pcf_file.pcf]
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
#   -o                    : Output File Name
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
#

MAP_OPTS:= \
	-filter $(PROJECT).filter \
	-global_opt off \
	-intstyle $(INTSTYLE) \
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

$(ISE)/$(PROJECT)_map.ncd $(ISE)/$(PROJECT).pcf: $(ISE)/$(PROJECT).ngd $(ISE)/$(PROJECT).filter makefile
	cd ise; \
	$(MAP) $(MAP_OPTS) -o $(PROJECT)_map.ncd $(PROJECT).ngd $(PROJECT).pcf

#
# Place and Route
#
# PAR accepts a mapped NCD file as input, places and routes the design,
# and outputs an NCD file to be used by the bitstream generator (BitGen).
#
# usage:
#   par [options] infile[.ncd] outfile [pcf_file[.pcf]]
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
	-filter $(PROJECT).filter \
	-intstyle $(INTSTYLE) \
	-mt 4 \
	-ol high \
	-w \
	-xe n

$(ISE)/$(PROJECT).ncd: $(ISE)/$(PROJECT)_map.ncd $(ISE)/$(PROJECT).pcf $(ISE)/$(PROJECT).filter makefile
	cd ise; \
	$(PAR) $(PAR_OPTS) $(PROJECT)_map.ncd $(PROJECT).ncd $(PROJECT).pcf

#
# bitgen
#
# Generate BIT file from NCD file.
#
# usage:
#   bitgen [options] infile[.ncd] [outfile] [pcf_file.pcf]
#
# bitgen options:
#
#   -g                    : Set configuration
#   -intstyle             : Integration style
#   -w                    : Overwrite existing output file
#

BITGEN_OPTS := \
	-w \
	-intstyle $(INTSTYLE) \
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

$(ISE)/$(PROJECT).bit: $(ISE)/$(PROJECT).ncd
	cd ise; \
	$(BITGEN) $(BITGEN_OPTS) $(PROJECT).ncd $(PROJECT).bit

#
# promgen
#
# Create the Intel Hex file for loading into the serial flash.
#
# usage:
#   promgen [options]
#
# promgen options:
#
#   -c                    : Checksum
#   -o                    : Output File Name
#   -p                    : PROM format
#   -s                    : PROM size
#   -spi                  : Disable bit swapping
#   -u                    : Load upward {addr filename}
#   -w                    : Overwrite existing output file
#

PROMGEN_OPTS := \
	-c ff \
	-o $(PROJECT).mcs \
	-p mcs \
	-s 4096 \
	-spi \
	-u 0000 $(PROJECT).bit \
	-w

$(ISE)/$(PROJECT).mcs: $(ISE)/$(PROJECT).bit makefile
	cd ise; \
	$(PROMGEN) $(PROMGEN_OPTS) 

#
# Run 'impact' to program the KS10 flash
#
# Gosh the documentation for impact is really poor.
#
# usage:
#   impact [options]
#

IMPACT_CMDS := \
	'setmode -bscan' \
	'setcable -p auto' \
	'identify -inferir' \
	'identifyMPM' \
	'attachflash -position 1 -spi S25FL032P' \
	'assignfiletoattachedflash -position 1 -file $(PROJECT).mcs' \
	'program -p 1 -dataWidth 1 -spionly -e -v -loadfpga' \
	'quit'

load: $(ISE)/$(PROJECT).mcs $(ISE)/$(PROJECT)_impact.cmd
	cd ise; \
	$(IMPACT) -batch $(PROJECT)_impact.cmd

#
# iverilog
#

$(TESTSUITE)/$(DIAG).vvp : $(SIM_SRC) $(RTL_SRC) $(INC) $(DAT) makefile
	$(IVERILOG) -s testbench -o $@ $(SIM_SRC) $(RTL_SRC)   \
	-D DEBUG_$(DIAGBASE) \
	-D DEBUG=$(DIAGBASE) \
	-I rtl/ks10 \
	-I rtl/ks10/uba \
	-I rtl/ks10/uba/rh11 \
	-I rtl/ks10/uba/rh11/sd \
	-I rtl/ks10/uba/dz11 \
	-I rtl/ks10/uba/dz11/uart \
	-I rtl/ks10/cpu \
	-I rtl/ks10/cpu/useq 

$(TESTSUITE)/$(DIAG).txt : $(TESTSUITE)/$(DIAG).vvp 
	$(VVP) -n $< > $(TESTSUITE)/$(DIAG).txt

#
# Clean everything
#

clean: clean_rtl clean_ise

#
# Clean RTL
#

clean_rtl: 
	rm -f $(RTL)/ks10/cpu/useq/*.dat
	rm -f $(RTL)/testbench/*.dat
	find . -type f -name "*~" | xargs rm -fv

#
# Clean ISE
#

clean_ise:
	rm -rf $(ISE)/xst \
               $(ISE)/_ngo \
               $(ISE)/_xmsgs \
               $(ISE)/isim \
               $(ISE)/iseconfig \
               $(ISE)/xlnx_auto_0_xdb      
	rm -f  $(ISE)/$(PROJECT).bgn \
	       $(ISE)/$(PROJECT).bit \
	       $(ISE)/$(PROJECT).bld \
	       $(ISE)/$(PROJECT).cfi \
               $(ISE)/$(PROJECT).cmd_log \
               $(ISE)/$(PROJECT).drc \
               $(ISE)/$(PROJECT).filter \
               $(ISE)/$(PROJECT).lso \
               $(ISE)/$(PROJECT).mcs \
               $(ISE)/$(PROJECT).ncd \
               $(ISE)/$(PROJECT).ngc \
               $(ISE)/$(PROJECT).ngc_xst.xrpt \
               $(ISE)/$(PROJECT).ngd \
               $(ISE)/$(PROJECT).ngr \
               $(ISE)/$(PROJECT).pad \
               $(ISE)/$(PROJECT).par \
               $(ISE)/$(PROJECT).pcf\
               $(ISE)/$(PROJECT).prj\
               $(ISE)/$(PROJECT).prm\
               $(ISE)/$(PROJECT).ptwx \
               $(ISE)/$(PROJECT).stx \
               $(ISE)/$(PROJECT).twr \
               $(ISE)/$(PROJECT).twx \
               $(ISE)/$(PROJECT).unroutes \
               $(ISE)/$(PROJECT).wdb \
               $(ISE)/$(PROJECT).xpi \
               $(ISE)/$(PROJECT).xst \
               $(ISE)/$(PROJECT)_bitgen.xwbt \
               $(ISE)/$(PROJECT)_envsettings.html \
               $(ISE)/$(PROJECT)_guide.ncd \
               $(ISE)/$(PROJECT)_impact.cmd \
               $(ISE)/$(PROJECT)_isim.cmd \
               $(ISE)/$(PROJECT)_isim.exe \
               $(ISE)/$(PROJECT)_isim.prj \
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
               $(ISE)/fuse.log \
               $(ISE)/fuse.xmsgs \
               $(ISE)/fuseRelaunch.cmd \
               $(ISE)/_impactbatch.log \
               $(ISE)/isim.cmd \
               $(ISE)/isim.log \
               $(ISE)/par_usage_statistics.html \
               $(ISE)/usage_statistics_webtalk.html \
               $(ISE)/webtalk.log \
               $(ISE)/webtalk_pn.xml \
               $(ISE)/xilinx_device_details.xml \
               $(ISE)/xilinxsim.ini

#
# rcsclean everything
#

rcsclean: rcsclean_rtl rcsclean_ise

#
# rcsclean ISE
#

rcsclean_ise: clean_ise
	rcsclean $(ISE)/*

#
# rcsclean RTL
#

rcsclean_rtl: clean_rtl
	-rcsclean $(RTL)/*
	-rcsclean $(RTL)/esm/*
	-rcsclean $(RTL)/testbench/*
	-rcsclean $(RTL)/ks10/*
	-rcsclean $(RTL)/ks10/arb/*
	-rcsclean $(RTL)/ks10/clk/*
	-rcsclean $(RTL)/ks10/csl/*
	-rcsclean $(RTL)/ks10/cpu/*
	-rcsclean $(RTL)/ks10/mem/*
	-rcsclean $(RTL)/ks10/utils/*
	-rcsclean $(RTL)/ks10/uba/dz11/uart/*
	-rcsclean $(RTL)/ks10/uba/dz11/*
	-rcsclean $(RTL)/ks10/uba/rh11/sd/*
	-rcsclean $(RTL)/ks10/uba/rh11/*
	-rcsclean $(RTL)/ks10/uba/*
	-rcsclean $(RTL)/ks10/cpu/useq/*
	-find . -type f | grep -v RCS | grep -v archive | grep \\.v$$

#
# Fetch design from RCS
#

rcsfetch: $(INC) $(RTL_SRC) $(SIM_SRC) $(BLD) $(DAT) $(DOC) $(DIAGFILES) $(RTL)/esm/$(PROJECT).ucf 

#
# Archive files
#

archive_all:
	tar --exclude=testsuite_*/* -czvf ks10_fpga_all_`date '+%y%m%d'`.tgz *

archive_dist: $(SRC)
	make rcsfetch
	tar  --exclude-vcs -czvf ks10_fpga_dist_`date '+%y%m%d'`.tgz *

#./t10backup.exe   -x smmon.sav -f ks_diag_gs.tap
#	-prj testbench_beh.prj \
#	-lib unisims_ver \
#	-lib unimacro_ver \
#	-lib xilinxcorelib_ver \
#	-lib secureip \
#	echo 'verilog work "C:/Xilinx/13.1/ISE_DS/ISE//verilog/src/glbl.v"' >> $@
