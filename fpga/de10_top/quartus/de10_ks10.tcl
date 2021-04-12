# Copyright (C) 2018  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details.

# Quartus Prime: Generate Tcl File for Project
# File: de10_ks10.tcl
# Generated on: Tue Jan 19 01:47:12 2021

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "de10_ks10"]} {
		puts "Project de10_ks10 is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists de10_ks10]} {
		project_open -revision de10_ks10 de10_ks10
	} else {
		project_new -revision de10_ks10 de10_ks10
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone V"
	set_global_assignment -name DEVICE 5CSEBA6U23I7
	set_global_assignment -name LAST_QUARTUS_VERSION "18.1.0 Lite Edition"
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "17:14:54 MARCH 04,2015"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name VERILOG_MACRO SYNTHESIS
	set_global_assignment -name VERILOG_MACRO SSRAMx18
	set_global_assignment -name VERILOG_MACRO DZ11
	set_global_assignment -name VERILOG_MACRO RH11
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP "-40"
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name USE_DLL_FREQUENCY_FOR_DQS_DELAY_CHAIN ON
	set_global_assignment -name UNIPHY_SEQUENCER_DQS_CONFIG_ENABLE ON
	set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
	set_global_assignment -name ECO_REGENERATE_REPORT ON
	set_global_assignment -name VERILOG_SHOW_LMF_MAPPING_MESSAGES OFF
	set_global_assignment -name NUM_PARALLEL_PROCESSORS 6
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name VERILOG_FILE de10_ks10.v
	set_global_assignment -name VERILOG_FILE ../../ks10/ks10.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dup11/duprxcsr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dup11/dupparcsr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dz11/dzuart.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dz11/dztdr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dz11/dztcr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dz11/dzscan.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dz11/dzrbuf.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dz11/dzmsr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dz11/dzintr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dz11/dzcsr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dz11/dz11.v
	set_global_assignment -name VERILOG_FILE ../../ks10/utils/usrt/usrt_tx.v
	set_global_assignment -name VERILOG_FILE ../../ks10/utils/usrt/usrt_rx.v
	set_global_assignment -name VERILOG_FILE ../../ks10/utils/uart/uart_tx.v
	set_global_assignment -name VERILOG_FILE ../../ks10/utils/uart/uart_rx.v
	set_global_assignment -name VERILOG_FILE ../../ks10/utils/uart/uart_brg.v
	set_global_assignment -name VERILOG_FILE ../../ks10/utils/sync.v
	set_global_assignment -name VERILOG_FILE ../../ks10/utils/fifo.v
	set_global_assignment -name VERILOG_FILE ../../ks10/utils/edgetrig.v
	set_global_assignment -name VERILOG_FILE ../../ks10/utils/crc16.v
	set_global_assignment -name VERILOG_FILE ../../ks10/uba/ubatmo.v
	set_global_assignment -name VERILOG_FILE ../../ks10/uba/ubasr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/uba/ubapage.v
	set_global_assignment -name VERILOG_FILE ../../ks10/uba/ubanxd.v
	set_global_assignment -name VERILOG_FILE ../../ks10/uba/ubamr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/uba/ubaintr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/uba/uba.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp26/lp26.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp20/lpramd.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp20/lppdat.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp20/lppctr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp20/lpintr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp20/lpdma.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp20/lpcsrb.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp20/lpcsra.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp20/lpcksm.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp20/lpcctr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp20/lpcbuf.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp20/lpbctr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp20/lpbar.v
	set_global_assignment -name VERILOG_FILE ../../ks10/lp20/lp20.v
	set_global_assignment -name VERILOG_FILE ../../ks10/kmc11/kmcseq.v
	set_global_assignment -name VERILOG_FILE ../../ks10/kmc11/kmcnprc.v
	set_global_assignment -name VERILOG_FILE ../../ks10/kmc11/kmcmpram.v
	set_global_assignment -name VERILOG_FILE ../../ks10/kmc11/kmcmisc.v
	set_global_assignment -name VERILOG_FILE ../../ks10/kmc11/kmcmem.v
	set_global_assignment -name VERILOG_FILE ../../ks10/kmc11/kmcmaint.v
	set_global_assignment -name VERILOG_FILE ../../ks10/kmc11/kmcintr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/kmc11/kmcdmux.v
	set_global_assignment -name VERILOG_FILE ../../ks10/kmc11/kmcclk.v
	set_global_assignment -name VERILOG_FILE ../../ks10/kmc11/kmcbrg.v
	set_global_assignment -name VERILOG_FILE ../../ks10/kmc11/kmcalu.v
	set_global_assignment -name VERILOG_FILE ../../ks10/kmc11/kmc11.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dup11/duptxdbuf.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dup11/duptxcsr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dup11/duptx.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dup11/duprx.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dup11/dupintr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dup11/dupclk.v
	set_global_assignment -name VERILOG_FILE ../../ks10/dup11/dup11.v
	set_global_assignment -name VERILOG_FILE ../../ks10/debug/debug.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/useq/useq.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/useq/stack.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/useq/skip.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/useq/drom.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/useq/dispatch.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/useq/crom.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/vma.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/timing.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/timer.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/scad.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/regir.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/ramfile.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/pxct.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/pi.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/pcflags.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/pager.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/nxm.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/nxd.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/intf.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/disp_pf.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/disp_ni.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/disp_byte.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/dbus.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/dbm.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/cpu.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/bus.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/apr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/cpu/alu.v
	set_global_assignment -name VERILOG_FILE ../../ks10/arb/arb.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/sd/sdspi.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/sd/sd.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rpxx.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rpof.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rpmr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rpla.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rphcrc.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rper3.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rper2.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rper1.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rpds.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rpdc.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rpda.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rpctrl.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rpcs1.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rpxx/rpaddr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rhwc.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rhnem.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rhintr.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rhdb.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rhcs2.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rhcs1.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rhba.v
	set_global_assignment -name VERILOG_FILE ../../ks10/rh11/rh11.v
	set_global_assignment -name VERILOG_FILE ../../ks10/mem/memstat.v
	set_global_assignment -name VERILOG_FILE ../../ks10/mem/mem.v
	set_global_assignment -name VERILOG_FILE ../../ks10/csl/csl.v
	set_global_assignment -name VERILOG_FILE ../../ks10/utils/last.v
	set_global_assignment -name SDC_FILE de10_ks10.sdc
	set_global_assignment -name QIP_FILE soc_system/synthesis/soc_system.qip
	set_global_assignment -name SOURCE_FILE db/de10_ks10.cmp.rdb
	set_location_assignment PIN_V11 -to FPGA_CLK1_50
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to FPGA_CLK1_50
	set_location_assignment PIN_U10 -to HDMI_I2C_SCL
	set_location_assignment PIN_AA4 -to HDMI_I2C_SDA
	set_location_assignment PIN_T13 -to HDMI_I2S
	set_location_assignment PIN_T11 -to HDMI_LRCLK
	set_location_assignment PIN_U11 -to HDMI_MCLK
	set_location_assignment PIN_T12 -to HDMI_SCLK
	set_location_assignment PIN_AG5 -to HDMI_TX_CLK
	set_location_assignment PIN_AD19 -to HDMI_TX_DE
	set_location_assignment PIN_AD12 -to HDMI_TX_D[0]
	set_location_assignment PIN_AE12 -to HDMI_TX_D[1]
	set_location_assignment PIN_W8 -to HDMI_TX_D[2]
	set_location_assignment PIN_Y8 -to HDMI_TX_D[3]
	set_location_assignment PIN_AD11 -to HDMI_TX_D[4]
	set_location_assignment PIN_AD10 -to HDMI_TX_D[5]
	set_location_assignment PIN_AE11 -to HDMI_TX_D[6]
	set_location_assignment PIN_Y5 -to HDMI_TX_D[7]
	set_location_assignment PIN_AF10 -to HDMI_TX_D[8]
	set_location_assignment PIN_Y4 -to HDMI_TX_D[9]
	set_location_assignment PIN_AE9 -to HDMI_TX_D[10]
	set_location_assignment PIN_AB4 -to HDMI_TX_D[11]
	set_location_assignment PIN_AE7 -to HDMI_TX_D[12]
	set_location_assignment PIN_AF6 -to HDMI_TX_D[13]
	set_location_assignment PIN_AF8 -to HDMI_TX_D[14]
	set_location_assignment PIN_AF5 -to HDMI_TX_D[15]
	set_location_assignment PIN_AE4 -to HDMI_TX_D[16]
	set_location_assignment PIN_AH2 -to HDMI_TX_D[17]
	set_location_assignment PIN_AH4 -to HDMI_TX_D[18]
	set_location_assignment PIN_AH5 -to HDMI_TX_D[19]
	set_location_assignment PIN_AH6 -to HDMI_TX_D[20]
	set_location_assignment PIN_AG6 -to HDMI_TX_D[21]
	set_location_assignment PIN_AF9 -to HDMI_TX_D[22]
	set_location_assignment PIN_AE8 -to HDMI_TX_D[23]
	set_location_assignment PIN_T8 -to HDMI_TX_HS
	set_location_assignment PIN_AF11 -to HDMI_TX_INT
	set_location_assignment PIN_V13 -to HDMI_TX_VS
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_I2C_SCL
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_I2C_SDA
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_I2S
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_LRCLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_MCLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_SCLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_CLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_DE
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[8]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[9]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[10]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[11]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[12]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[13]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[14]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[15]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[16]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[17]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[18]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[19]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[20]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[21]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[22]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_D[23]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_HS
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_INT
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HDMI_TX_VS
	set_location_assignment PIN_AH17 -to KEY[0]
	set_location_assignment PIN_AH16 -to KEY[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY[1]
	set_location_assignment PIN_Y24 -to SW[0]
	set_location_assignment PIN_W24 -to SW[1]
	set_location_assignment PIN_W21 -to SW[2]
	set_location_assignment PIN_W20 -to SW[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[3]
	set_location_assignment PIN_AG11 -to SD_CD
	set_location_assignment PIN_E8 -to SD_WP
	set_location_assignment PIN_W12 -to SD_SCLK
	set_location_assignment PIN_V12 -to SD_MOSI
	set_location_assignment PIN_D8 -to SD_MISO
	set_location_assignment PIN_D11 -to SD_SS_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SD_CD
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SD_WP
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SD_SCLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SD_MOSI
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SD_MISO
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SD_SS_N
	set_location_assignment PIN_AA11 -to DZ_RXD[0]
	set_location_assignment PIN_Y11 -to DZ_RXD[1]
	set_location_assignment PIN_AF27 -to DZ_RXD[2]
	set_location_assignment PIN_AF13 -to DZ_RXD[3]
	set_location_assignment PIN_AC24 -to DZ_RXD[4]
	set_location_assignment PIN_AB26 -to DZ_RXD[5]
	set_location_assignment PIN_AG28 -to DZ_RXD[6]
	set_location_assignment PIN_AA15 -to DZ_RXD[7]
	set_location_assignment PIN_AA26 -to DZ_TXD[0]
	set_location_assignment PIN_AA13 -to DZ_TXD[1]
	set_location_assignment PIN_AE25 -to DZ_TXD[2]
	set_location_assignment PIN_AG13 -to DZ_TXD[3]
	set_location_assignment PIN_AD26 -to DZ_TXD[4]
	set_location_assignment PIN_AB25 -to DZ_TXD[5]
	set_location_assignment PIN_AF28 -to DZ_TXD[6]
	set_location_assignment PIN_Y15 -to DZ_TXD[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_RXD[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_RXD[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_RXD[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_RXD[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_RXD[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_RXD[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_RXD[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_RXD[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_TXD[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_TXD[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_TXD[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_TXD[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_TXD[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_TXD[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_TXD[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DZ_TXD[7]
	set_location_assignment PIN_W15 -to RP_LEDS[0]
	set_location_assignment PIN_AA24 -to RP_LEDS[1]
	set_location_assignment PIN_V16 -to RP_LEDS[2]
	set_location_assignment PIN_V15 -to RP_LEDS[3]
	set_location_assignment PIN_AF26 -to RP_LEDS[4]
	set_location_assignment PIN_AE26 -to RP_LEDS[5]
	set_location_assignment PIN_Y16 -to RP_LEDS[6]
	set_location_assignment PIN_AA23 -to RP_LEDS[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RP_LEDS[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RP_LEDS[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RP_LEDS[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RP_LEDS[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RP_LEDS[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RP_LEDS[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RP_LEDS[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RP_LEDS[7]
	set_location_assignment PIN_C12 -to SSRAM_CLK
	set_location_assignment PIN_AH8 -to SSRAM_WE_N
	set_location_assignment PIN_AC22 -to SSRAM_ADV
	set_location_assignment PIN_AE24 -to SSRAM_D[0]
	set_location_assignment PIN_AD23 -to SSRAM_D[1]
	set_location_assignment PIN_AE6 -to SSRAM_D[2]
	set_location_assignment PIN_AE23 -to SSRAM_D[3]
	set_location_assignment PIN_AG14 -to SSRAM_D[4]
	set_location_assignment PIN_AD5 -to SSRAM_D[5]
	set_location_assignment PIN_AH3 -to SSRAM_D[6]
	set_location_assignment PIN_AH14 -to SSRAM_D[7]
	set_location_assignment PIN_AH13 -to SSRAM_D[8]
	set_location_assignment PIN_AG10 -to SSRAM_D[9]
	set_location_assignment PIN_Y18 -to SSRAM_D[10]
	set_location_assignment PIN_Y17 -to SSRAM_D[11]
	set_location_assignment PIN_AG9 -to SSRAM_D[12]
	set_location_assignment PIN_AA18 -to SSRAM_D[13]
	set_location_assignment PIN_W14 -to SSRAM_D[14]
	set_location_assignment PIN_U14 -to SSRAM_D[15]
	set_location_assignment PIN_AA19 -to SSRAM_D[16]
	set_location_assignment PIN_W11 -to SSRAM_D[17]
	set_location_assignment PIN_AH22 -to SSRAM_A[0]
	set_location_assignment PIN_AH21 -to SSRAM_A[1]
	set_location_assignment PIN_AG21 -to SSRAM_A[2]
	set_location_assignment PIN_AH23 -to SSRAM_A[3]
	set_location_assignment PIN_AA20 -to SSRAM_A[4]
	set_location_assignment PIN_AF22 -to SSRAM_A[5]
	set_location_assignment PIN_D12 -to SSRAM_A[6]
	set_location_assignment PIN_AD20 -to SSRAM_A[7]
	set_location_assignment PIN_AF25 -to SSRAM_A[8]
	set_location_assignment PIN_AG23 -to SSRAM_A[9]
	set_location_assignment PIN_AB23 -to SSRAM_A[10]
	set_location_assignment PIN_Y19 -to SSRAM_A[11]
	set_location_assignment PIN_U13 -to SSRAM_A[12]
	set_location_assignment PIN_AG26 -to SSRAM_A[13]
	set_location_assignment PIN_AH27 -to SSRAM_A[14]
	set_location_assignment PIN_AG25 -to SSRAM_A[15]
	set_location_assignment PIN_AH26 -to SSRAM_A[16]
	set_location_assignment PIN_AH24 -to SSRAM_A[17]
	set_location_assignment PIN_AG8 -to SSRAM_A[18]
	set_location_assignment PIN_AC23 -to SSRAM_A[19]
	set_location_assignment PIN_AF23 -to SSRAM_A[20]
	set_location_assignment PIN_AG24 -to SSRAM_A[21]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_CLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_WE_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_ADV
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[8]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[9]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[10]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[11]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[12]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[13]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[14]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[15]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[16]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_D[17]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[8]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[9]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[10]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[11]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[12]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[13]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[14]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[15]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[16]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[17]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[18]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[19]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[20]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SSRAM_A[21]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_CLK
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_WE_N
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_ADV
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[0]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[1]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[2]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[3]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[4]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[5]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[6]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[7]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[8]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[9]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[10]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[11]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[12]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[13]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[14]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[15]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[16]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_D[17]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[0]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[1]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[2]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[3]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[4]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[5]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[6]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[7]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[8]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[9]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[10]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[11]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[12]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[13]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[14]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[15]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[16]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[17]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[18]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[19]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[20]
	set_instance_assignment -name SLEW_RATE 1 -to SSRAM_A[21]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_CLK
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_WE_N
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_ADV
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[3]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[4]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[5]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[6]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[7]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[8]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[9]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[10]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[11]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[12]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[13]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[14]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[15]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[16]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_D[17]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[3]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[4]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[5]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[6]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[7]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[8]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[9]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[10]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[11]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[12]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[13]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[14]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[15]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[16]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[17]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[18]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[19]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[20]
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SSRAM_A[21]
	set_location_assignment PIN_AE19 -to ESD_DI
	set_location_assignment PIN_AE20 -to ESD_DO
	set_location_assignment PIN_AE17 -to ESD_SCLK
	set_location_assignment PIN_AG15 -to ESD_BDIO
	set_location_assignment PIN_AH18 -to BRST_N
	set_location_assignment PIN_AF20 -to BCS_N
	set_location_assignment PIN_AF18 -to BRD_N
	set_location_assignment PIN_AG18 -to BWR_N
	set_location_assignment PIN_AH19 -to BA[0]
	set_location_assignment PIN_AG19 -to BA[1]
	set_location_assignment PIN_AF21 -to BA[2]
	set_location_assignment PIN_AG20 -to BA[3]
	set_location_assignment PIN_AE22 -to BA[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ESD_DI
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ESD_DO
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ESD_SCLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ESD_BDIO
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to BRST_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to BCS_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to BRD_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to BWR_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to BA[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to BA[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to BA[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to BA[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to BA[4]
	set_location_assignment PIN_AF4 -to SW_RESET_N
	set_location_assignment PIN_AF15 -to SW_BOOT_N
	set_location_assignment PIN_AH11 -to SW_HALT_N
	set_location_assignment PIN_AF7 -to LED_PWR_N
	set_location_assignment PIN_AH12 -to LED_RESET_N
	set_location_assignment PIN_AE15 -to LED_BOOT_N
	set_location_assignment PIN_AG16 -to LED_HALT_N
	set_location_assignment PIN_AH9 -to SPARE0
	set_location_assignment PIN_AD17 -to SPARE1
	set_location_assignment PIN_AF17 -to SPARE2
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW_RESET_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW_BOOT_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW_HALT_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED_PWR_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED_RESET_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED_BOOT_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED_HALT_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SPARE0
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SPARE1
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SPARE2
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[0] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[1] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[2] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[3] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[4] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[5] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[6] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[7] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[8] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[9] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[10] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[11] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[12] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[13] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ADDR[14] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_BA[0] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_BA[1] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_BA[2] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_CAS_N -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_CKE -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_CK_N -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_CK_P -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_CS_N -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DM[0] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DM[1] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DM[2] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DM[3] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[0] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[1] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[2] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[3] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[4] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[5] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[6] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[7] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[8] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[9] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[10] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[11] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[12] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[13] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[14] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[15] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[16] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[17] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[18] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[19] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[20] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[21] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[22] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[23] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[24] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[25] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[26] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[27] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[28] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[29] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[30] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_DQ[31] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_N[0] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_N[1] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_N[2] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_N[3] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_P[0] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_P[1] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_P[2] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to HPS_DDR3_DQS_P[3] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_ODT -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_RAS_N -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_RESET_N -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_RZQ -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to HPS_DDR3_WE_N -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TXCLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TXEN
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TXD[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TXD[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TXD[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TXD[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RXCLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RXD[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RXD[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RXD[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RXD[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RXDV
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_MDC
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_MDIO
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_INT_N
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_GSENSOR_INT
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C0_SCL
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C0_SDA
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C1_SCL
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C1_SDA
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_KEY
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_LED
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_LTC_GPIO
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_CLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_CMD
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_D[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_D[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_D[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_D[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SPI_CLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SPI_MISO
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SPI_MOSI
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SPI_SS
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_UART_RX
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_UART_TX
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_CLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_D[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_D[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_D[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_D[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_D[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_D[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_D[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_D[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_STP
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DIR
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_NXT
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_CONV_USB_N
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[0] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[0] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[1] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[1] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[2] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[2] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[3] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[3] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[4] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[4] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[5] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[5] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[6] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[6] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[7] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[7] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[8] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[8] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[9] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[9] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[10] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[10] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[11] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[11] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[12] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[12] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[13] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[13] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[14] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[14] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[15] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[15] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[16] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[16] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[17] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[17] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[18] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[18] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[19] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[19] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[20] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[20] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[21] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[21] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[22] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[22] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[23] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[23] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[24] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[24] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[25] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[25] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[26] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[26] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[27] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[27] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[28] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[28] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[29] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[29] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[30] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[30] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[31] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQ[31] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[0] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[0] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[1] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[1] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[2] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[2] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[3] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_P[3] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[0] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[0] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[1] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[1] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[2] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[2] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[3] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DQS_N[3] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITHOUT CALIBRATION" -to HPS_DDR3_CK_P -tag __hps_sdram_p0
	set_instance_assignment -name D5_DELAY 2 -to HPS_DDR3_CK_P -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITHOUT CALIBRATION" -to HPS_DDR3_CK_N -tag __hps_sdram_p0
	set_instance_assignment -name D5_DELAY 2 -to HPS_DDR3_CK_N -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[0] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[10] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[11] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[12] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[13] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[14] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[1] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[2] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[3] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[4] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[5] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[6] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[7] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[8] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ADDR[9] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_BA[0] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_BA[1] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_BA[2] -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_CAS_N -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_CKE -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_CS_N -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_ODT -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_RAS_N -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_WE_N -tag __hps_sdram_p0
	set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to HPS_DDR3_RESET_N -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DM[0] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DM[1] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DM[2] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to HPS_DDR3_DM[3] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[0] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[1] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[2] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[3] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[4] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[5] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[6] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[7] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[8] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[9] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[10] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[11] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[12] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[13] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[14] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[15] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[16] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[17] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[18] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[19] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[20] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[21] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[22] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[23] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[24] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[25] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[26] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[27] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[28] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[29] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[30] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQ[31] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DM[0] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DM[1] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DM[2] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DM[3] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_P[0] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_P[1] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_P[2] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_P[3] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_N[0] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_N[1] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_N[2] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_DQS_N[3] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[0] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[10] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[11] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[12] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[13] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[14] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[1] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[2] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[3] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[4] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[5] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[6] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[7] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[8] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ADDR[9] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_BA[0] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_BA[1] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_BA[2] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_CAS_N -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_CKE -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_CS_N -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_ODT -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_RAS_N -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_WE_N -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_RESET_N -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_CK_P -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR3_CK_N -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_mem_stable_n -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_n -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[0].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[0] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[0] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[1].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[1] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[1] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[2].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[2] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[2] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[3].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[3] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[3] -tag __hps_sdram_p0
	set_instance_assignment -name ENABLE_BENEFICIAL_SKEW_OPTIMIZATION_FOR_NON_GLOBAL_CLOCKS ON -to u0|hps_0|hps_io|border|hps_sdram_inst -tag __hps_sdram_p0
	set_instance_assignment -name PLL_COMPENSATION_MODE DIRECT -to u0|hps_0|hps_io|border|hps_sdram_inst|pll0|fbout -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_mem_stable_n -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_n -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[0].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[0] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[0] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[1].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[1] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[1] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[2].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[2] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[2] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[3].read_capture_clk_buffer -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[3] -tag __hps_sdram_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[3] -tag __hps_sdram_p0
	set_instance_assignment -name ENABLE_BENEFICIAL_SKEW_OPTIMIZATION_FOR_NON_GLOBAL_CLOCKS ON -to u0|hps|hps_io|border|hps_sdram_inst -tag __hps_sdram_p0
	set_instance_assignment -name PLL_COMPENSATION_MODE DIRECT -to u0|hps|hps_io|border|hps_sdram_inst|pll0|fbout -tag __hps_sdram_p0
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
