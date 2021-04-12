#
# Clocks
#
create_clock -period "1.0 MHz"  [get_ports HPS_I2C0_SCL]
create_clock -period "1.0 MHz"  [get_ports HPS_I2C1_SCL]
create_clock -period "20.0 MHz" [get_ports SD_SCLK]
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
# SDHC Card
#

set_input_delay  -clock SD_SCLK -clock_fall 3 [get_ports SD_MISO]
set_output_delay -clock SD_SCLK 3             [get_ports SD_MOSI]
set_output_delay -clock SD_SCLK 3             [get_ports SD_SS_N]
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
 
#
# SSRAM
#

# CY7C1463KV33 tCDV
set_input_delay  -clock [get_clocks SSSRAM_CLK] -max  6.5 [get_ports {SSRAM_D*}]
set_input_delay  -clock [get_clocks {u0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -min  0.0 [get_ports {SSRAM_D*}]
# CY7C1463KV33 tAS
set_output_delay -clock {u0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} -max  1.5 [get_ports {SSRAM_A*}]
set_output_delay -clock {u0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} -max  1.5 [get_ports {SSRAM_WE_N}]
# CY7C1463KV33 tAH
set_output_delay -clock {u0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} -min -0.5 [get_ports {SSRAM_A*}]
set_output_delay -clock {u0|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} -min -0.5 [get_ports {SSRAM_WE_N}]

##
## PLL Clocks
##

derive_pll_clocks

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
