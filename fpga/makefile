#
# Project name.   Also top-level entity name (upper case)
#

PROJECT  := esm_ks10
RTLTOP   := ESM_KS10
SIMTOP   := testbench

#
# FPGA partnumber
#

PART     := xc6slx45-2-fgg676

#
# Xilinx tools
#

XILDIR   := $(shell cygpath -u '$(XILINX)')
XILEXE   := $(XILDIR)/ISE_DS/ISE/bin/nt64
BITGEN   := $(XILEXE)/bitgen.exe
FUSE     := $(XILEXE)/fuse.exe
MAP      := $(XILEXE)/map.exe
NGD      := $(XILEXE)/ngdbuild.exe
PAR      := $(XILEXE)/par.exe
PROMGEN  := $(XILEXE)/promgen.exe
IMPACT   := $(XILEXE)/impact.exe
XST      := $(XILEXE)/xst.exe
INTSTYLE := ise
XILPATH  := $(XILDIR)/ISE_DS/ISE/bin/nt64:$(XILDIR)/ISE_DS/ISE/lib/nt64:$(XILDIR)/ISE_DS/common/bin/nt64:$(XILDIR)/ISE_DS/common/lib/nt64

#
# Other tools
#

IVERILOG := iverilog
VVP      := vvp
CLOC     := ./cloc-1.62.exe

# Fix pipelining (the tee command)
#
# Quoting the bash manual -
# Each command in a pipeline is executed in its own subshell.  The exit status
# of a pipeline is the exit status of the last command in the pipeline, unless
# the pipefail option is enabled. If pipefail is enabled, the pipeline’s return
# status is the value of the last (rightmost) command to exit with a non-zero
# status, or zero if all commands exit successfully.
#

.SHELLFLAGS = -o pipefail -c

#
# Initialized Memory Contents (Simulation only)
#

#DIAG     := DSKAA		#    1.0 ms
#DIAG     := DSKAB		#    1.1 ms
#DIAG     := DSKAC		#    0.8 ms
#DIAG     := DSKAD		#    0.9 ms
#DIAG     := DSKAE		#    0.7 ms
#DIAG     := DSKAF		#    0.8 ms
#DIAG     := DSKAG		#    0.5 ms
#DIAG     := DSKAH		#   15.0 ms
#DIAG     := DSKAI		#    2.4 ms
#DIAG     := DSKAJ		#    2.8 ms
#DIAG     := DSKAK		#    4.2 ms
#DIAG     := DSKAL		#    4.7 ms
#DIAG     := DSKAM		#    2.3 ms
#DIAG     := DSKBA-RD00  	#    1.0 ms FAIL
#DIAG     := DSKCA		#    1.9 ms
#DIAG     := DSKCB		#    1.3 ms
#DIAG     := DSKCC		#    2.1 ms
#DIAG     := DSKCD		#    5.2 ms
#DIAG     := DSKCE-RD00	#    5.7 ms
#DIAG     := DSKCF-RD00	#   10.6 ms	
#DIAG     := DSKCG		# 1350.0 ms FAIL
#DIAG     := DSKDA-RD00	#    5.3 ms FAIL
#DIAG     := DSKEA-RD00	# 1046.0 ms
#DIAG     := DSKEB-RD00	#  ???.? ms FAIL
#DIAG     := DSKEC-RD00	#  ???.? ms FAIL
#DIAG     := DSKFA   	#  ???.? ms FAIL
#DIAG     := DSMMA   	#  ???.? ms FAIL
#DIAG     := DSMMB   	#  ???.? ms FAIL
#DIAG     := DSMMC   	#  ???.? ms FAIL
#DIAG     := DSMMD   	#  ???.? ms FAIL
#DIAG     := DSUBA-RD00	#  138.0 ms
#DIAG     := DSDZA-RD00	# 2411.8 ms
#DIAG     := DSRPA-RD00	#  ???.? ms FAIL

DIAGBASE := $(shell echo "$(DIAG)" | sed -e 's/-.*//')     # strip the RD00-XXXX suffix

#
# Macro Definitions
#
#   -D ENABLE_TIMER	Enable 1 ms timer.  Slows simulation.  (See testbench)
#   -D SIM_SMMON	Boot to SMMON instead of diagnostic app (See testbench)
#   -D SIM_CTY		Simulate the CTY (See testbench)
#   -D STOP_ON_COMPLETE Stop simulation when test is complete (See debug.v)
#   -D STOP_ON_STUCK_PC Stop simulating when PC gets stuck.
#   -D DEBUG_DSKAA	Diagnostic information (See debug.v)
#   -D DEBUG=DSKAA	Diagnostic information (See debug.v)
#   -D CHIPSCOPE_CPU    Instrument the CPU
#   -D CHIPSCOPE_SD     Instrument the SD Controller
#   -D CHIPSCOPE_MEM    Instrument the Memory Controller
#

#	-D SIM_SMMON \
#	-D CHIPSCOPE_CPU \
#	-D CHIPSCOPE_MEM \

DEBUG_ARGS := \
	-D SIM_CTY \
	-D ENABLE_TIMER \
	-D STOP_ON_STUCK_PC \
	-D STOP_ON_COMPLETE \
	-D DEBUG_$(DIAGBASE) \
	-D DEBUG=$(DIAGBASE) \
	-D DIAG=$(DIAG)

#
#
#

PREFIX := MAINDEC-10-

#
# Diagnostic Files
#

DIAG_FILES := \
        rtl/testbench/${PREFIX}DSKAA.SEQ \
        rtl/testbench/${PREFIX}DSKAB.SEQ \
        rtl/testbench/${PREFIX}DSKAC.SEQ \
        rtl/testbench/${PREFIX}DSKAD.SEQ \
        rtl/testbench/${PREFIX}DSKAE.SEQ \
        rtl/testbench/${PREFIX}DSKAF.SEQ \
        rtl/testbench/${PREFIX}DSKAG.SEQ \
        rtl/testbench/${PREFIX}DSKAH.SEQ \
        rtl/testbench/${PREFIX}DSKAI.SEQ \
        rtl/testbench/${PREFIX}DSKAJ.SEQ \
        rtl/testbench/${PREFIX}DSKAK.SEQ \
        rtl/testbench/${PREFIX}DSKAL.SEQ \
        rtl/testbench/${PREFIX}DSKAM.SEQ \
        rtl/testbench/${PREFIX}DSKBA.SEQ \
        rtl/testbench/${PREFIX}DSKCA.SEQ \
        rtl/testbench/${PREFIX}DSKCB.SEQ \
        rtl/testbench/${PREFIX}DSKCC.SEQ \
        rtl/testbench/${PREFIX}DSKCD.SEQ \
        rtl/testbench/${PREFIX}DSKCE-RD00.SEQ \
        rtl/testbench/${PREFIX}DSKCF-RD00.SEQ \
        rtl/testbench/${PREFIX}DSKCG.SEQ \
        rtl/testbench/${PREFIX}DSKDA-RD00.SEQ \
        rtl/testbench/${PREFIX}DSKEA-RD00.SEQ \
        rtl/testbench/${PREFIX}DSKEB.SEQ \
        rtl/testbench/${PREFIX}DSKEC.SEQ \
        rtl/testbench/${PREFIX}DSMMA.SEQ \
        rtl/testbench/${PREFIX}DSMMB.SEQ \
        rtl/testbench/${PREFIX}DSMMC.SEQ \
        rtl/testbench/${PREFIX}DSMMD.SEQ \
        rtl/testbench/${PREFIX}DSDZA-RD00.SEQ \
        rtl/testbench/${PREFIX}DSUBA-RD00.SEQ \
        rtl/testbench/${PREFIX}DSRPA-RD00.SEQ

#
# Verilog source files
#

RTL_FILES := \
	rtl/ks10/utils/edgetrig.v \
	rtl/ks10/utils/sync.v \
	rtl/ks10/clk/clk.v \
	rtl/ks10/csl/csl.v \
	rtl/ks10/mem/mem.v \
	rtl/ks10/arb/arb.v \
	rtl/ks10/cpu/useq/crom.v \
	rtl/ks10/cpu/useq/drom.v \
	rtl/ks10/cpu/useq/skip.v \
	rtl/ks10/cpu/useq/stack.v \
	rtl/ks10/cpu/useq/dispatch.v \
	rtl/ks10/cpu/useq/useq.v \
	rtl/ks10/cpu/alu.v \
	rtl/ks10/cpu/apr.v \
	rtl/ks10/cpu/bus.v \
	rtl/ks10/cpu/disp_byte.v \
	rtl/ks10/cpu/disp_ni.v \
	rtl/ks10/cpu/disp_pf.v \
	rtl/ks10/cpu/dbm.v \
	rtl/ks10/cpu/dbus.v \
	rtl/ks10/cpu/debug.v \
	rtl/ks10/cpu/intf.v \
	rtl/ks10/cpu/nxd.v \
	rtl/ks10/cpu/nxm.v \
	rtl/ks10/cpu/pager.v \
	rtl/ks10/cpu/pcflags.v \
	rtl/ks10/cpu/pi.v \
	rtl/ks10/cpu/pxct.v \
	rtl/ks10/cpu/ramfile.v \
	rtl/ks10/cpu/regir.v \
	rtl/ks10/cpu/scad.v \
	rtl/ks10/cpu/timer.v \
	rtl/ks10/cpu/timing.v \
	rtl/ks10/cpu/vma.v \
	rtl/ks10/cpu/cpu.v \
	rtl/ks10/uba/dz11/uart/uart_brg.v \
	rtl/ks10/uba/dz11/uart/uart_rx.v \
	rtl/ks10/uba/dz11/uart/uart_tx.v \
	rtl/ks10/uba/dz11/dzcsr.v \
	rtl/ks10/uba/dz11/dzmsr.v \
	rtl/ks10/uba/dz11/dztcr.v \
	rtl/ks10/uba/dz11/dztdr.v \
	rtl/ks10/uba/dz11/dzintr.v \
	rtl/ks10/uba/dz11/dzrbuf.v \
	rtl/ks10/uba/dz11/dzscan.v \
	rtl/ks10/uba/dz11/dzuart.v \
	rtl/ks10/uba/dz11/dz11.v \
	rtl/ks10/uba/rh11/rh11.v \
	rtl/ks10/uba/rh11/rhba.v \
	rtl/ks10/uba/rh11/rhdb.v \
	rtl/ks10/uba/rh11/rhwc.v \
	rtl/ks10/uba/rh11/rhcs1.v \
	rtl/ks10/uba/rh11/rhcs2.v \
	rtl/ks10/uba/rh11/rpxx/sdaddr.v \
	rtl/ks10/uba/rh11/rpxx/rpcs1.v \
	rtl/ks10/uba/rh11/rpxx/rpda.v \
	rtl/ks10/uba/rh11/rpxx/rpdc.v \
	rtl/ks10/uba/rh11/rpxx/rpds.v \
	rtl/ks10/uba/rh11/rpxx/rper1.v \
	rtl/ks10/uba/rh11/rpxx/rpof.v \
	rtl/ks10/uba/rh11/rpxx/rpxx.v \
	rtl/ks10/uba/rh11/sd/sd.v \
	rtl/ks10/uba/rh11/sd/sdspi.v \
	rtl/ks10/uba/uba.v \
	rtl/ks10/uba/ubamr.v \
	rtl/ks10/uba/ubasr.v \
	rtl/ks10/uba/ubaloop.v \
	rtl/ks10/uba/ubapage.v \
	rtl/ks10/uba/ubanxd.v \
	rtl/ks10/uba/ubatmo.v \
	rtl/ks10/uba/ubaintr.v \
	rtl/ks10/ks10.v \
	rtl/esm/esm_ks10.v

#
# Simulation testbench files
#

SIM_FILES := \
	rtl/esm/cy7c1460av33.v \
	rtl/esm/esm_testbench.v

#
# If were simulating SMMON, add the SMMON files.  Otherwise don't.
#

MON_FILES := 

ifneq (, $(findstring SIM_SMMON, $(DEBUG_ARGS)))

MON_FILES += \
	rtl/testbench/MAINDEC-10-DSQDA-RD00.SEQ \
	rtl/testbench/MAINDEC-10-DSQDB-RD00.SEQ \
	rtl/testbench/MAINDEC-10-DSQDC-RD00.SEQ

endif

#
# Verilog include files
#

INC_FILES := \
	rtl/ks10/cpu/useq/crom.vh  \
	rtl/ks10/cpu/useq/drom.vh  \
	rtl/ks10/cpu/alu.vh \
	rtl/ks10/cpu/apr.vh \
	rtl/ks10/cpu/bus.vh \
	rtl/ks10/cpu/debug_dskah.vh \
	rtl/ks10/cpu/debug_dskba.vh \
	rtl/ks10/cpu/debug_dskcg.vh \
	rtl/ks10/cpu/debug_dskea.vh \
	rtl/ks10/cpu/debug_dskec.vh \
	rtl/ks10/cpu/debug_dsuba.vh \
	rtl/ks10/cpu/debug_dsdza.vh \
	rtl/ks10/cpu/debug_smmon.vh \
	rtl/ks10/cpu/debug_default.vh \
	rtl/ks10/cpu/pager.vh \
	rtl/ks10/cpu/pcflags.vh \
	rtl/ks10/cpu/pxct.vh \
	rtl/ks10/cpu/regir.vh \
	rtl/ks10/cpu/vma.vh \
	rtl/ks10/uba/dz11/dz11.vh \
	rtl/ks10/uba/dz11/dzcsr.vh \
	rtl/ks10/uba/dz11/dzlpr.vh \
	rtl/ks10/uba/dz11/dzrbuf.vh \
	rtl/ks10/uba/dz11/dztcr.vh \
	rtl/ks10/uba/dz11/dztdr.vh \
	rtl/ks10/uba/dz11/dzuart.vh \
	rtl/ks10/uba/rh11/rhba.vh \
	rtl/ks10/uba/rh11/rhdb.vh \
	rtl/ks10/uba/rh11/rhwc.vh \
	rtl/ks10/uba/rh11/rhcs1.vh \
	rtl/ks10/uba/rh11/rhcs2.vh \
	rtl/ks10/uba/rh11/rpxx/rpcs1.vh \
	rtl/ks10/uba/rh11/rpxx/rpda.vh \
	rtl/ks10/uba/rh11/rpxx/rpdc.vh \
	rtl/ks10/uba/rh11/rpxx/rpds.vh \
	rtl/ks10/uba/rh11/rpxx/rper1.vh \
	rtl/ks10/uba/rh11/rpxx/rpof.vh \
	rtl/ks10/uba/rh11/rpxx/rpxx.vh \
	rtl/ks10/uba/rh11/sd/sdspi.vh \
	rtl/ks10/uba/rh11/sd/sd.vh \
	rtl/ks10/uba/rh11/rh11.vh \
	rtl/ks10/uba/uba.vh \
	rtl/ks10/uba/ubamr.vh \
	rtl/ks10/uba/ubasr.vh \
	rtl/ks10/uba/ubabus.vh \
	rtl/ks10/uba/ubapage.vh \
	rtl/ks10/ks10.vh

#
# Microcode and memory initialization
#

CROM_DAT := \
	rtl/ks10/cpu/useq/crom.dat

DROM_DAT := \
	rtl/ks10/cpu/useq/drom.dat

RAMFILE_DAT := \
	rtl/ks10/cpu/ramfile.dat

DAT_FILES := \
	$(CROM_DAT) \
	$(DROM_DAT) \
	$(RAMFILE_DAT)

#
# Documentation files
#

DOC_FILES := \
	rtl/status.txt \
	rtl/fixme.txt

#
# Build files
#

BLD_FILES := \
	ise/esm_ks10.xise \
	ise/esm_ks10.gise \
	ise/esm_ks10.wcfg

#
# Filter file arguments
#

FILTER_ARGS := \
	'<filters xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="filter.xsd">' \
	'    <filter task="map"   file="Map"   num="284"  type="warning"></filter>' \
	'    <filter task="xst"   file="Xst"   num="647"  type="warning"></filter>' \
	'    <filter task="xst"   file="Xst"   num="1710" type="warning"></filter>' \
	'    <filter task="xst"   file="Xst"   num="1895" type="warning"></filter>' \
	'    <filter task="xst"   file="Xst"   num="2261" type="info"   ></filter>' \
	'    <filter task="xst"   file="Xst"   num="2677" type="warning"></filter>' \
	'    <filter task="place" file="Place" num="1109" type="warning"></filter>' \
	'    <filter task="place" file="Place" num="1137" type="warning"></filter>' \
	'    <filter task="place" file="Place" num="1197" type="warning"></filter>' \
	'    <filter task="place" file="Place" num="1206" type="warning"></filter>' \
	'</filters>'

build: ise/$(PROJECT).mcs

#
# Create the "Control ROM" microcode for microsequencer
#

rtl/ks10/cpu/useq/crom.dat: rtl/ks10/cpu/useq/ks10.mcr rtl/ks10/cpu/useq/crom.awk
	awk -f rtl/ks10/cpu/useq/crom.awk rtl/ks10/cpu/useq/ks10.mcr > rtl/ks10/cpu/useq/crom.dat

#
# Create the "Dispatch ROM" microcode for microsequencer
#

rtl/ks10/cpu/useq/drom.dat: rtl/ks10/cpu/useq/ks10.mcr rtl/ks10/cpu/useq/drom.awk
	awk -f rtl/ks10/cpu/useq/drom.awk rtl/ks10/cpu/useq/ks10.mcr > rtl/ks10/cpu/useq/drom.dat

#
# Create the "RAMFILE" initialization
#

rtl/ks10/cpu/ramfile.dat: rtl/ks10/cpu/ramfile.awk
	awk -f rtl/ks10/cpu/ramfile .awk > rtl/ks10/cpu/ramfile.dat

#
# Initialize the SSRAM with MAINDEC (simulation only)
# Note special rule for force $(DIAG).dat to rebuild
#

rtl/testbench/$(DIAG).dat : FORCE
FORCE:

rtl/testbench/$(DIAG).dat : $(MON_FILES) rtl/testbench/${PREFIX}$(DIAG).SEQ rtl/testbench/ssram.awk makefile
	cat $(MON_FILES) rtl/testbench/${PREFIX}$(DIAG).SEQ | \
	awk -f rtl/testbench/ssram.awk -vfilename=${PREFIX}$(DIAG).SEQ > rtl/testbench/$(DIAG).dat

ise/$(PROJECT).filter: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for FIL in $(FILTER_ARGS); \
	do \
	    echo $$FIL >> $@; \
	done

ise/$(PROJECT).xst: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(XST_CMDS); \
	do \
	    echo $$CMD >> $@; \
	done

ise/$(PROJECT).prj: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for FILE in $(RTL_FILES); \
	do \
	    echo 'verilog work "../'$$FILE'"' >> $@; \
	done
ifneq (, $(findstring CHIPSCOPE_SD, $(DEBUG_ARGS)))
	@echo verilog work \"../rtl/xilinx/chipscope_sd_ila/chipscope_sd_ila.v\" >> $@
	@echo verilog work \"../rtl/xilinx/chipscope_sd_icon/chipscope_sd_icon.v\" >> $@
endif
ifneq (, $(findstring CHIPSCOPE_CPU, $(DEBUG_ARGS)))
	@echo verilog work \"../rtl/xilinx/chipscope_cpu_ila/chipscope_cpu_ila.v\" >> $@
	@echo verilog work \"../rtl/xilinx/chipscope_cpu_icon/chipscope_cpu_icon.v\" >> $@
	@echo verilog work \"../rtl/xilinx/chipscope_cpu_vio/chipscope_cpu_vio.v\"  >> $@
endif
ifneq (, $(findstring CHIPSCOPE_MEM, $(DEBUG_ARGS)))
	@echo verilog work \"../rtl/xilinx/chipscope_mem_ila/chipscope_mem_ila.v\" >> $@
	@echo verilog work \"../rtl/xilinx/chipscope_mem_icon/chipscope_mem_icon.v\" >> $@
endif

ise/$(PROJECT)_isim.prj: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for FILE in $(RTL_FILES); \
	do \
	    echo 'verilog work "../'$$FILE'"' >> $@; \
	done
	@for FILE in $(SIM_FILES); \
	do \
	    echo 'verilog work "../'$$FILE'"' >> $@; \
	done
	echo 'verilog work "$(XILINX)/ISE_DS/ISE/verilog/src/glbl.v"' >> $@;

ise/$(PROJECT)_isim.cmd: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(ISIM_CMDS); \
	do \
	    echo $$CMD >> $@; \
	done

ise/$(PROJECT)_impact.cmd: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(IMPACT_CMDS); \
	do \
	    echo $$CMD >> $@; \
	done

#
# FUSE
#  The Xilinx simulator has a different switch for defining macros.
#  Pipe DEBUG_ARGS though sed
#

FUSE_ARGS := \
	$(shell echo "$(DEBUG_ARGS)" | sed -e 's/-D/-d/g') \
	-d SMALL_MEM \
	-d XILINX \
	-d SSRAM_DAT=\"\"../rtl/testbench/$(DIAG).dat\"\" \
	-d RAMFILE_DAT=\"\"../$(RAMFILE_DAT)\"\" \
	-d CROM_DAT=\"\"../$(CROM_DAT)\"\" \
	-d DROM_DAT=\"\"../$(DROM_DAT)\"\" \
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

ise/$(PROJECT)_isim.exe: ise/$(PROJECT)_isim.prj $(RTL_FILES) $(SIM_FILES) $(INC_FILES) $(DAT_FILES) makefile
	@cd ise; \
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

isim: ise/$(PROJECT)_isim.exe ise/$(PROJECT)_isim.cmd ise/$(PROJECT).wcfg rtl/testbench/$(DIAG).dat makefile
	@cd ise; \
	export PATH=$(XILPATH):$$PATH; \
	./$(PROJECT)_isim.exe $(ISIM_ARGS) &

#
# xst
#
# xst options:
#
#   -filter                    : Filter File
#   -intstyle                  : Integration Style
#   -sd                        : Core Search Directory
#   -write_timing_constraints  : Write timing constraints
#

XST_OPTS := \
	-filter $(PROJECT).filter \
	-intstyle $(INTSTYLE)

XST_DEFS := \
	XILINX \
	SYNTHESIS

ifneq (, $(findstring CHIPSCOPE_SD, $(DEBUG_ARGS)))
XST_DEFS += \
	CHIPSCOPE_SD
endif

ifneq (, $(findstring CHIPSCOPE_CPU, $(DEBUG_ARGS)))
XST_DEFS += \
	CHIPSCOPE_CPU
endif

ifneq (, $(findstring CHIPSCOPE_MEM, $(DEBUG_ARGS)))
XST_DEFS += \
	CHIPSCOPE_MEM
endif

XST_CMDS := \
	'set -xsthdpdir "xst"' \
	'run' \
	'-ifn $(PROJECT).prj' \
	'-use_new_parser yes' \
	'-ofn $(PROJECT).ngc' \
	'-ofmt ngc' \
	'-p $(PART)' \
	'-top $(RTLTOP)' \
	'-opt_mode Speed' \
	'-opt_level 2' \
	'-power NO' \
	'-iuc NO' \
	'-keep_hierarchy Soft' \
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
	'-define {$(XST_DEFS)}' \
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

ifneq (, $(findstring CHIPSCOPE_SD, $(DEBUG_ARGS)))
XST_CMDS += \
	'-sd {"../rtl/xilinx/chipscope_sd_ila" "../rtl/xilinx/chipscope_sd_icon"}'
endif

ifneq (, $(findstring CHIPSCOPE_CPU, $(DEBUG_ARGS)))
XST_CMDS += \
	'-sd {"../rtl/xilinx/chipscope_cpu_ila" "../rtl/xilinx/chipscope_cpu_icon" "../rtl/xilinx/chipscope_cpu_vio"}'
endif

ifneq (, $(findstring CHIPSCOPE_MEM, $(DEBUG_ARGS)))
XST_CMDS += \
	'-sd {"../rtl/xilinx/chipscope_mem_ila" "../rtl/xilinx/chipscope_mem_icon"}'
endif

ise/$(PROJECT).ngc ise/$(PROJECT).ngr: ise/$(PROJECT).xst ise/$(PROJECT).prj ise/$(PROJECT).filter rtl/esm/$(PROJECT).ucf $(RTL_FILES) $(INC_FILES) $(DAT_FILES) $(SIM_FILES) makefile
	@cd ise; \
	echo "################################################################################" | tee    $(PROJECT).log; \
	echo Running XST | tee -a $(PROJECT).log; \
	echo $(XST) $(XST_OPTS) -ifn $(PROJECT).xst -ofn $(PROJECT).syr | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(XST) $(XST_OPTS) -ifn $(PROJECT).xst -ofn $(PROJECT).syr | tee -a $(PROJECT).log

#
# ngdbuild
#
# "NGDBuild reads in a netlist file in EDIF or NGC format and creates a Xilinx Native
# Generic Database (NGD) file that contains a logical description of the design in terms of
# logic elements, such as AND gates, OR gates, LUTs, flip-flops, and RAMs"
#
# usage:
#   ngdbuild [options] design_name [ngd_file[.ngd]]
#
# Ngdbuild options:
#
#   -dd                   : Destination Directory
#   -sd                   : Core Search Directory
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
	-uc ../rtl/esm/$(PROJECT).ucf

ifneq (, $(findstring CHIPSCOPE_SD, $(DEBUG_ARGS)))
NGD_OPTS += \
	-sd ../rtl/xilinx/chipscope_sd_ila \
	-sd ../rtl/xilinx/chipscope_sd_icon
endif

ifneq (, $(findstring CHIPSCOPE_CPU, $(DEBUG_ARGS)))
NGD_OPTS += \
	-sd ../rtl/xilinx/chipscope_cpu_ila \
	-sd ../rtl/xilinx/chipscope_cpu_icon \
	-sd ../rtl/xilinx/chipscope_cpu_vio
endif

ifneq (, $(findstring CHIPSCOPE_MEM, $(DEBUG_ARGS)))
NGD_OPTS += \
	-sd ../rtl/xilinx/chipscope_mem_ila \
	-sd ../rtl/xilinx/chipscope_mem_icon \
endif


ise/$(PROJECT).ngd: ise/$(PROJECT).ngc rtl/esm/$(PROJECT).ucf ise/$(PROJECT).filter makefile
	@cd ise; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	echo Running NGDBUILD | tee -a $(PROJECT).log; \
	echo $(NGD) $(NGD_OPTS) $(PROJECT).ngc $(PROJECT).ngd | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(NGD) $(NGD_OPTS) $(PROJECT).ngc $(PROJECT).ngd | tee -a $(PROJECT).log

#
# MAP
#
# The MAP program maps a logical design to a Xilinx FPGA. The
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

ise/$(PROJECT)_map.ncd ise/$(PROJECT).pcf: ise/$(PROJECT).ngd ise/$(PROJECT).filter makefile
	@cd ise; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	echo Running MAP | tee -a $(PROJECT).log; \
	echo $(MAP) $(MAP_OPTS) -o $(PROJECT)_map.ncd $(PROJECT).ngd $(PROJECT).pcf | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(MAP) $(MAP_OPTS) -o $(PROJECT)_map.ncd $(PROJECT).ngd $(PROJECT).pcf | tee -a $(PROJECT).log

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

ise/$(PROJECT).ncd: ise/$(PROJECT)_map.ncd ise/$(PROJECT).pcf ise/$(PROJECT).filter makefile
	@cd ise; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	echo Running PAR | tee -a $(PROJECT).log; \
	echo $(PAR) $(PAR_OPTS) $(PROJECT)_map.ncd $(PROJECT).ncd $(PROJECT).pcf | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(PAR) $(PAR_OPTS) $(PROJECT)_map.ncd $(PROJECT).ncd $(PROJECT).pcf | tee -a $(PROJECT).log

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

ise/$(PROJECT).bit: ise/$(PROJECT).ncd
	@cd ise; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	echo Running BITGEN | tee -a $(PROJECT).log; \
	echo $(BITGEN) $(BITGEN_OPTS) $(PROJECT).ncd $(PROJECT).bit | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(BITGEN) $(BITGEN_OPTS) $(PROJECT).ncd $(PROJECT).bit | tee -a $(PROJECT).log

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

ise/$(PROJECT).mcs: ise/$(PROJECT).bit makefile
	@cd ise; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	echo Running PROMGEN | tee -a $(PROJECT).log; \
	echo $(PROMGEN) $(PROMGEN_OPTS) | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(PROMGEN) $(PROMGEN_OPTS) | tee -a $(PROJECT).log

#
# Run 'impact' to program the KS10 flash
#
# Gosh the documentation for impact is really poor.
#
# usage:
#   impact [options]
#
# Note:
#   This is keyed to my Digilent JTAG HS2 programmer. If you want to
#   auto probe for a JTAG device:
#
#   Replace
#	'setCable -target "digilent_plugin DEVICE=JtagHs2 FREQUENCY="' \
#
#   With
#	'setcable -p auto' \
#

IMPACT_CMDS := \
	'setmode -bscan' \
	'setCable -target "digilent_plugin DEVICE=JtagHs2 FREQUENCY="' \
	'identify -inferir' \
	'identifyMPM' \
	'attachflash -position 1 -spi S25FL032P' \
	'assignfiletoattachedflash -position 1 -file $(PROJECT).mcs' \
	'program -p 1 -dataWidth 1 -spionly -e -v -loadfpga' \
	'quit'

load: ise/$(PROJECT).mcs ise/$(PROJECT)_impact.cmd
	cd ise; \
	$(IMPACT) -batch $(PROJECT)_impact.cmd

reload: ise/$(PROJECT)_impact.cmd
	cd ise; \
	$(IMPACT) -batch $(PROJECT)_impact.cmd

#
# iverilog
#

testsuite/$(DIAG).vvp : $(SIM_FILES) $(RTL_FILES) $(INC_FILES) $(DAT_FILES) rtl/testbench/$(DIAG).dat  makefile
	$(IVERILOG) -s testbench -o $@ $(SIM_FILES) $(RTL_FILES) \
	$(DEBUG_ARGS) \
	-D SSRAM_DAT=\"rtl/testbench/$(DIAG).dat\" \
	-D RAMFILE_DAT=\"$(RAMFILE_DAT)\" \
	-D CROM_DAT=\"$(CROM_DAT)\" \
	-D DROM_DAT=\"$(DROM_DAT)\" \
	-I rtl/ks10 \
	-I rtl/ks10/uba \
	-I rtl/ks10/uba/rh11 \
	-I rtl/ks10/uba/rh11/rpxx \
	-I rtl/ks10/uba/rh11/sd \
	-I rtl/ks10/uba/dz11 \
	-I rtl/ks10/uba/dz11/uart \
	-I rtl/ks10/cpu \
	-I rtl/ks10/cpu/useq

testsuite/$(DIAG).txt : testsuite/$(DIAG).vvp
	$(VVP) -n $< > testsuite/$(DIAG).txt

#
# Clean everything
#

clean: clean_rtl clean_ise

#
# Clean RTL
#

clean_rtl:
	rm -f rtl/ks10/cpu/ramfile.dat
	rm -f rtl/ks10/cpu/useq/crom.dat
	rm -f rtl/ks10/cpu/useq/drom.dat
	rm -f rtl/testbench/*.dat
	find . -type f -name "*~" | xargs rm -fv

#
# Clean ISE
#

clean_ise:
	rm -rf ise/xst \
               ise/_ngo \
               ise/_xmsgs \
               ise/isim \
               ise/iseconfig \
               ise/xlnx_auto_0_xdb
	rm -f  ise/$(PROJECT).bgn \
	       ise/$(PROJECT).bit \
	       ise/$(PROJECT).bld \
	       ise/$(PROJECT).cfi \
               ise/$(PROJECT).cmd_log \
               ise/$(PROJECT).drc \
               ise/$(PROJECT).filter \
               ise/$(PROJECT).log \
               ise/$(PROJECT).lso \
               ise/$(PROJECT).mcs \
               ise/$(PROJECT).ncd \
               ise/$(PROJECT).ngc \
               ise/$(PROJECT).ngc_xst.xrpt \
               ise/$(PROJECT).ngd \
               ise/$(PROJECT).ngr \
               ise/$(PROJECT).pad \
               ise/$(PROJECT).par \
               ise/$(PROJECT).pcf\
               ise/$(PROJECT).prj\
               ise/$(PROJECT).prm\
               ise/$(PROJECT).ptwx \
               ise/$(PROJECT).srp \
               ise/$(PROJECT).syr \
               ise/$(PROJECT).stx \
               ise/$(PROJECT).twr \
               ise/$(PROJECT).twx \
               ise/$(PROJECT).unroutes \
               ise/$(PROJECT).ut \
               ise/$(PROJECT).wdb \
               ise/$(PROJECT).xpi \
               ise/$(PROJECT).xst \
               ise/$(PROJECT)_bitgen.xwbt \
               ise/$(PROJECT)_envsettings.html \
               ise/$(PROJECT)_guide.ncd \
               ise/$(PROJECT)_impact.cmd \
               ise/$(PROJECT)_isim.cmd \
               ise/$(PROJECT)_isim.exe \
               ise/$(PROJECT)_isim.prj \
               ise/$(PROJECT)_map.map \
               ise/$(PROJECT)_map.mrp \
               ise/$(PROJECT)_map.ncd \
               ise/$(PROJECT)_map.ngm \
               ise/$(PROJECT)_map.xrpt \
               ise/$(PROJECT)_ngdbuild.xrpt \
               ise/$(PROJECT)_pad.csv \
               ise/$(PROJECT)_pad.txt \
               ise/$(PROJECT)_par.xrpt \
               ise/$(PROJECT)_summary.html \
               ise/$(PROJECT)_summary.xml \
               ise/$(PROJECT)_usage.xml \
               ise/$(PROJECT)_xst.xrpt \
               ise/fuse.log \
               ise/fuse.xmsgs \
               ise/fuseRelaunch.cmd \
               ise/_impactbatch.log \
               ise/isim.cmd \
               ise/isim.log \
               ise/par_usage_statistics.html \
               ise/usage_statistics_webtalk.html \
               ise/webtalk.log \
               ise/webtalk_pn.xml \
               ise/xilinx_device_details.xml \
               ise/xilinxsim.ini

#
# rcsclean everything
#

rcsclean: rcsclean_rtl rcsclean_ise

#
# rcsclean ISE
#

rcsclean_ise: clean_ise
	rcsclean ise/*

#
# rcsclean RTL
#

rcsclean_rtl: clean_rtl
	-rcsclean *
	-rcsclean rtl/*
	-rcsclean rtl/esm/*
	-rcsclean rtl/testbench/*
	-rcsclean rtl/ks10/*
	-rcsclean rtl/ks10/arb/*
	-rcsclean rtl/ks10/clk/*
	-rcsclean rtl/ks10/csl/*
	-rcsclean rtl/ks10/cpu/*
	-rcsclean rtl/ks10/mem/*
	-rcsclean rtl/ks10/utils/*
	-rcsclean rtl/ks10/uba/dz11/uart/*
	-rcsclean rtl/ks10/uba/dz11/*
	-rcsclean rtl/ks10/uba/rh11/rpxx/*
	-rcsclean rtl/ks10/uba/rh11/sd/*
	-rcsclean rtl/ks10/uba/rh11/*
	-rcsclean rtl/ks10/uba/*
	-rcsclean rtl/ks10/cpu/useq/*
	-find rtl -type f | grep -v RCS | grep -v archive | grep \\.v$$

#
# Fetch design from RCS
#

rcsfetch: $(INC_FILES) $(RTL_FILES) $(SIM_FILES) $(BLD_FILES) $(DAT_FILES) $(DOC_FILES) $(DIAG_FILES) rtl/esm/$(PROJECT).ucf

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

#
# Count Lines of Code
#

cloc :
	$(CLOC) --by-file --force-lang=Verilog-SystemVerilog,vh rtl
	$(CLOC) --by-file --exclude-dir=driverlib ../code

