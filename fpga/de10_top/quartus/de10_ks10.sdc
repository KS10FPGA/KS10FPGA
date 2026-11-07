#
# Clocks
#

create_clock -period "1.0 MHz"  [get_ports HPS_I2C0_SCL]
create_clock -period "1.0 MHz"  [get_ports HPS_I2C1_SCL]
create_clock -period "50.0 MHz" [get_ports FPGA_CLK1_50]
create_clock -period "60.0 MHz" [get_ports HPS_USB_CLK]

#
# JTAG
#

#create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
#set_input_delay  -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
#set_input_delay  -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
#set_output_delay -clock altera_reserved_tck 3             [get_ports altera_reserved_tdo]

#
# SD Card detect and write protect
#

set_false_path   -from                        [get_ports SD_CD]
set_false_path   -from                        [get_ports SD_WP]

#
#
#
#

# soc_system:u0|KS10:ks10|clkT[1]
# soc_system:u0|KS10:ks10|clkT[2]
# soc_system:u0|KS10:ks10|clkT[3]
# soc_system:u0|KS10:ks10|clkT[4]
 
##
## PLL Clocks
##

derive_pll_clocks

#
# SDHC Card
#
#  SDSPI generates SD_SCLK from the CPU clock.  It is an output and nothing in
#  the FPGA is clocked by it.  Each half period is at least two CPU clocks, so
#  the fastest rate is 320 ns.  See stateTXL and stateTXH in sdspi.v.
#
#  MOSI and SS_N change on the falling edge.  MISO is sampled on the rising edge.
#  The multicycle paths select those edges.  Otherwise the CPU clock edges either
#  side of SD_SCLK are checked, and the logic only uses one in four.
#

set clkT1 {u0|ks10|PLL|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}

create_generated_clock -name SD_SCLK -master_clock $clkT1 -source [get_pins $clkT1] -divide_by 4 [get_ports SD_SCLK]

# SD Card: tISU = 5 ns, tIH = 5 ns, tODLY = 14 ns, tOH = 0 ns
set_output_delay -clock SD_SCLK -max  5.0 [get_ports {SD_MOSI SD_SS_N}]
set_output_delay -clock SD_SCLK -min -5.0 [get_ports {SD_MOSI SD_SS_N}]
set_input_delay  -clock SD_SCLK -clock_fall -max 14.0 [get_ports SD_MISO]
set_input_delay  -clock SD_SCLK -clock_fall -min  0.0 [get_ports SD_MISO]

set_multicycle_path -from [get_clocks $clkT1] -to [get_ports {SD_MOSI SD_SS_N}] -start -setup 2
set_multicycle_path -from [get_clocks $clkT1] -to [get_ports {SD_MOSI SD_SS_N}] -start -hold  3
set_multicycle_path -from [get_ports SD_MISO] -to [get_clocks $clkT1] -end -setup 2
set_multicycle_path -from [get_ports SD_MISO] -to [get_clocks $clkT1] -end -hold  3

#
# SSRAM
#
#  NOT ACTIVE.  These constraints are kept for reference only.  Without them
#  the SSRAM interface has no timing paths at all.  A build with them enabled
#  improved the reported SSRAM slack but failed DSMMA test 6 (PHYTST) on the
#  second pass: CPU reads returned the right half-word as zero, left half-word
#  correct, at varying addresses about 32 words apart.  The SSRAM held the
#  right data and the console read it correctly.  The cause is not known.  A
#  build without them passes DSMMA.  Run DSMMA (LH 400000, RH 6000 for a quick
#  check) after any rebuild that enables them.
#
#  SSRAM_CLK is the inverted 50 MHz clock, so it rises at 10, 30, 50 and 70 ns
#  in the 80 ns CPU cycle.  See mem.sv.
#
#  A read samples the address at 10 and 30 ns and captures the data in ssramDI
#  at 30 and 50 ns.  The first address comes from the T1 edge at 0 ns, so the
#  10 ns check on SSRAM_A is real.  It fails on the slow timing models and only
#  just passes on the fast ones.
#
#  A write samples the data at 50 and 70 ns.  The bus enables the data pins at
#  T1 so those paths have 50 ns.
#
#  ssramBRD is an estimate of the board delay.  The data sheet values are from
#  CY7C1463KV33 (133 MHz), Infineon 001-96065.
#

#set ssramOUT {SSRAM_A[*] SSRAM_WE_N SSRAM_ADV SSRAM_D[*]}
#set ssramBRD 1.0
#
#create_generated_clock -name SSRAM_CLK -source [get_ports FPGA_CLK1_50] -invert [get_ports SSRAM_CLK]
#
## SSRAM: tCDV = 6.5 ns, tDOH = 2.5 ns
#set_input_delay  -clock SSRAM_CLK -max [expr {6.5 + 2.0 * $ssramBRD}] [get_ports {SSRAM_D[*]}]
#set_input_delay  -clock SSRAM_CLK -min 2.5                            [get_ports {SSRAM_D[*]}]
#
## SSRAM: tAS = tWES = tDS = 1.5 ns, tAH = tWEH = tDH = 0.5 ns
#set_output_delay -clock SSRAM_CLK -max [expr {1.5 + $ssramBRD}] [get_ports $ssramOUT]
#set_output_delay -clock SSRAM_CLK -min -0.5                     [get_ports $ssramOUT]
#
#set_multicycle_path -from [get_clocks $clkT1] -to [get_ports {SSRAM_D[*]}] -end -setup 3
#set_multicycle_path -from [get_clocks $clkT1] -to [get_ports {SSRAM_D[*]}] -end -hold  2

##
## Set Clock Latency
##

##
## Set Clock Uncertainty
##

derive_clock_uncertainty

##
## Set Input Delay
##

##
## Set Output Delay
##

##
## Set Clock Groups
##

##
## False paths
##

#
# Ethernet pins
#

set_false_path -from * -to [get_ports HPS_ENET_TXCLK]
set_false_path -from * -to [get_ports HPS_ENET_TXEN]
set_false_path -from * -to [get_ports HPS_ENET_TXD[0]]
set_false_path -from * -to [get_ports HPS_ENET_TXD[1]]
set_false_path -from * -to [get_ports HPS_ENET_TXD[2]]
set_false_path -from * -to [get_ports HPS_ENET_TXD[3]]
set_false_path -from       [get_ports HPS_ENET_RXCLK]  -to *
set_false_path -from       [get_ports HPS_ENET_RXDV]   -to *
set_false_path -from       [get_ports HPS_ENET_RXD[0]] -to *
set_false_path -from       [get_ports HPS_ENET_RXD[1]] -to *
set_false_path -from       [get_ports HPS_ENET_RXD[2]] -to *
set_false_path -from       [get_ports HPS_ENET_RXD[3]] -to *
set_false_path -from * -to [get_ports HPS_ENET_MDC]
set_false_path -from * -to [get_ports HPS_ENET_MDIO]
set_false_path -from       [get_ports HPS_ENET_MDIO]       -to *

#
# SDIO pins
#

set_false_path -from * -to [get_ports HPS_SD_CLK]
set_false_path -from       [get_ports HPS_SD_CMD] -to *
set_false_path -from * -to [get_ports HPS_SD_CMD]
set_false_path -from       [get_ports HPS_SD_D[0]] -to *
set_false_path -from * -to [get_ports HPS_SD_D[0]]
set_false_path -from       [get_ports HPS_SD_D[1]] -to *
set_false_path -from * -to [get_ports HPS_SD_D[1]]
set_false_path -from       [get_ports HPS_SD_D[2]] -to *
set_false_path -from * -to [get_ports HPS_SD_D[2]]
set_false_path -from       [get_ports HPS_SD_D[3]] -to *
set_false_path -from * -to [get_ports HPS_SD_D[3]]

#
# USB pins
#

set_false_path -from       [get_ports HPS_USB_CLK]  -to *
set_false_path -from       [get_ports HPS_USB_D[0]] -to *
set_false_path -from * -to [get_ports HPS_USB_D[0]]
set_false_path -from       [get_ports HPS_USB_D[1]] -to *
set_false_path -from * -to [get_ports HPS_USB_D[1]]
set_false_path -from       [get_ports HPS_USB_D[2]] -to *
set_false_path -from * -to [get_ports HPS_USB_D[2]]
set_false_path -from       [get_ports HPS_USB_D[3]] -to *
set_false_path -from * -to [get_ports HPS_USB_D[3]]
set_false_path -from       [get_ports HPS_USB_D[4]] -to *
set_false_path -from * -to [get_ports HPS_USB_D[4]]
set_false_path -from       [get_ports HPS_USB_D[5]] -to *
set_false_path -from * -to [get_ports HPS_USB_D[5]]
set_false_path -from       [get_ports HPS_USB_D[6]] -to *
set_false_path -from * -to [get_ports HPS_USB_D[6]]
set_false_path -from       [get_ports HPS_USB_D[7]] -to *
set_false_path -from * -to [get_ports HPS_USB_D[7]]
set_false_path -from * -to [get_ports HPS_USB_STP]
set_false_path -from       [get_ports HPS_USB_DIR]  -to *
set_false_path -from       [get_ports HPS_USB_NXT]  -to *

#
# SPI pins
#

set_false_path -from * -to [get_ports HPS_SPI_CLK]
set_false_path -from * -to [get_ports HPS_SPI_MOSI]
set_false_path -from       [get_ports HPS_SPI_MISO] -to *
set_false_path -from * -to [get_ports HPS_SPI_SS]

#
# UART0 pins
#

set_false_path -from       [get_ports HPS_UART_RX] -to *
set_false_path -from * -to [get_ports HPS_UART_TX]

#
# I2C0 pins
#

set_false_path -from       [get_ports HPS_I2C0_SDA] -to *
set_false_path -from * -to [get_ports HPS_I2C0_SDA]
set_false_path -from       [get_ports HPS_I2C0_SCL] -to *
set_false_path -from * -to [get_ports HPS_I2C0_SCL]

#
# I2C1 pins
#

set_false_path -from       [get_ports HPS_I2C1_SDA] -to *
set_false_path -from * -to [get_ports HPS_I2C1_SDA]
set_false_path -from       [get_ports HPS_I2C1_SCL] -to *
set_false_path -from * -to [get_ports HPS_I2C1_SCL]

#
# MISC pins
#

#set_false_path -from       [get_ports hps_io_hps_io_gpio_inst_GPIO09] -to *
#set_false_path -from * -to [get_ports hps_io_hps_io_gpio_inst_GPIO09]
#set_false_path -from       [get_ports hps_io_hps_io_gpio_inst_GPIO35] -to *
#set_false_path -from * -to [get_ports hps_io_hps_io_gpio_inst_GPIO35]
#set_false_path -from       [get_ports hps_io_hps_io_gpio_inst_GPIO40] -to *
#set_false_path -from * -to [get_ports hps_io_hps_io_gpio_inst_GPIO40]
#set_false_path -from       [get_ports hps_io_hps_io_gpio_inst_GPIO53] -to *
#set_false_path -from * -to [get_ports hps_io_hps_io_gpio_inst_GPIO53]
#set_false_path -from       [get_ports hps_io_hps_io_gpio_inst_GPIO54] -to *
#set_false_path -from * -to [get_ports hps_io_hps_io_gpio_inst_GPIO54]
#set_false_path -from       [get_ports hps_io_hps_io_gpio_inst_GPIO61] -to *
#set_false_path -from * -to [get_ports hps_io_hps_io_gpio_inst_GPIO61]

#set_false_path -from [get_clocks {clk clkx2}] -through [get_pins -compatibility_mode *] -to [get_clocks {clk clkx2}]

#
# DZ11 pins
#

set_false_path -from       [get_ports {DZ_RXD*}] -to *
set_false_path -from * -to [get_ports {DZ_TXD*}]

#
# Front Panel Pins
#

set_false_path -from       [get_ports SW_RESET_N] -to *
set_false_path -from       [get_ports SW_BOOT_N]  -to *
set_false_path -from       [get_ports SW_HALT_N]  -to *
set_false_path -from * -to [get_ports LED_PWR_N]
set_false_path -from * -to [get_ports LED_RESET_N]
set_false_path -from * -to [get_ports LED_BOOT_N]
set_false_path -from * -to [get_ports LED_HALT_N]

##
## Set Multicycle Path
##

##
## Set Maximum Delay
##

##
## Set Minimum Delay
##

##
## Set Input Transition
##

##
## Set Load
##
