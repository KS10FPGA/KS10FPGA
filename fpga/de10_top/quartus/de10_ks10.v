////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 System
//
// Details
//
//   de10_ks10.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2020 Rob Doyle
//
// This source file may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// This source file is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published by the
// Free Software Foundation; version 2.1 of the License.
//
// This source is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
// for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, download it from
// http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////////////////

`default_nettype none

`timescale 1ns/1ps

//`define HDMI
  
module de10_ks10 (
      // Clock
      input  wire         FPGA_CLK1_50,         // 50 MHz Clock
      // HDMI Interface
`ifdef HDMI                  
      inout  wire         HDMI_I2C_SCL,         // HDMI I2C clock
      inout  wire         HDMI_I2C_SDA,         // HDMI I2C data
      inout  wire         HDMI_I2S,             // HDMI I2S audio data
      inout  wire         HDMI_LRCLK,           // HDMI I2S left/right
      inout  wire         HDMI_MCLK,            // HDMI I2S master clock
      inout  wire         HDMI_SCLK,            // HDMI I2S audio clock
      output wire         HDMI_TX_CLK,          // HDMI video clock
      output wire [23: 0] HDMI_TX_D,            // HDMI video data
      output wire         HDMI_TX_DE,           // HDMI data enable
      output wire         HDMI_TX_HS,           // HDMI horizontal sync
      input  wire         HDMI_TX_INT,          // HDMI interrupt
      output wire         HDMI_TX_VS,           // HDMI vertical sync
`endif                  
      // HPS DDR3 Interface
      output wire [14: 0] HPS_DDR3_ADDR,        // DDR3 address
      output wire [ 2: 0] HPS_DDR3_BA,          // DDR3 bank address
      output wire         HPS_DDR3_CAS_N,       // DDR3 column address strobe
      output wire         HPS_DDR3_CK_N,        // DDR3 clock (neg)
      output wire         HPS_DDR3_CK_P,        // DDR3 clock (pos)
      output wire         HPS_DDR3_CKE,         // DDR3 clock enable
      output wire         HPS_DDR3_CS_N,        // DDR3 chip select
      output wire [ 3: 0] HPS_DDR3_DM,          // DDR3 data mask
      inout  wire [31: 0] HPS_DDR3_DQ,          // DDR3 data
      inout  wire [ 3: 0] HPS_DDR3_DQS_N,       // DDR3 data strobe (neg)
      inout  wire [ 3: 0] HPS_DDR3_DQS_P,       // DDR3 data strobe (pos)
      output wire         HPS_DDR3_ODT,         // DDR3 on-die termination
      output wire         HPS_DDR3_RAS_N,       // DDR3 row address strobe
      output wire         HPS_DDR3_RESET_N,     // DDR3 reset
      input  wire         HPS_DDR3_RZQ,         // DDR3 output drive calibration
      output wire         HPS_DDR3_WE_N,        // DDR3 write enable
      // HPS Ethernet
      output wire         HPS_ENET_TXCLK,       // ENET GMII TX Clock
      output wire         HPS_ENET_TXEN,        // ENET GMII transmit enable
      output wire [ 3: 0] HPS_ENET_TXD,         // ENET GMII transmit data
      input  wire         HPS_ENET_RXCLK,       // ENET GMII receive clock
      input  wire [ 3: 0] HPS_ENET_RXD,         // ENET GMII receive data
      input  wire         HPS_ENET_RXDV,        // ENET GMII receive data valid
      output wire         HPS_ENET_MDC,         // ENET management data clock
      inout  wire         HPS_ENET_MDIO,        // ENET managment data
      inout  wire         HPS_ENET_INT_N,       // ENET Interrupt
      // HPS MISC IO
      inout  wire         HPS_GSENSOR_INT,      // G sensor
      inout  wire         HPS_I2C0_SCL,         // I2C0 SCL
      inout  wire         HPS_I2C0_SDA,         // I2C0 SDA
      inout  wire         HPS_I2C1_SCL,         // I2C1 SCL
      inout  wire         HPS_I2C1_SDA,         // I2C1_SDA
      inout  wire         HPS_KEY,              // Key
      inout  wire         HPS_LED,              // leds
      inout  wire         HPS_LTC_GPIO,         // A/D
      // HPS SD Interface
      output wire         HPS_SD_CLK,           // SD clock
      inout  wire         HPS_SD_CMD,           // SD command
      inout  wire [ 3: 0] HPS_SD_D,             // SD data
      // HPS SPI Interface
      output wire         HPS_SPI_CLK,          // SPI lock
      input  wire         HPS_SPI_MISO,         // SPI master in, slave out
      output wire         HPS_SPI_MOSI,         // SPI master out, slave in
      inout  wire         HPS_SPI_SS,           // SPI slave selct
      // HPS UART Interface
      input  wire         HPS_UART_RX,          // UART RX data
      output wire         HPS_UART_TX,          // UART TX data
      // HPS USB Interface
      input  wire         HPS_USB_CLK,          // USB Clock (60 MHz)
      inout  wire [ 7: 0] HPS_USB_D,            // USB Data
      output wire         HPS_USB_STP,          // USB Stop
      input  wire         HPS_USB_DIR,          // USB Direction
      input  wire         HPS_USB_NXT,          // USB Throttle
      inout  wire         HPS_CONV_USB_N,       // USB reserved
      // LP20 Interface
      input  wire         LP_RXD,		// LP Receiver Serial Data
      output wire         LP_TXD,		// LP Transmitter Serial Data
      // DZ11 Interface
      input  wire [ 6: 0] DZ_RXD,               // DZ Receiver Serial Data
      output wire [ 6: 0] DZ_TXD,               // DZ Transmitter Serial Data
      // SD Interface
      input  wire         SD_CD,                // SD Card Detect
      input  wire         SD_WP,                // SD Write Protect
      input  wire         SD_MISO,              // SD Data In
      output wire         SD_MOSI,              // SD Data Out
      output wire         SD_SCLK,              // SD Clock
      output wire         SD_SS_N,              // SD Slave Select
      // RPXX Interfaces
      output wire [ 7: 0] RP_LEDS,              // RPXX LEDs
      // SSRAM Interfaces
      output wire         SSRAM_CLK,            // SSRAM Clock
      output wire         SSRAM_WE_N,           // SSRAM WE#
      output wire         SSRAM_ADV,            // SSRAM ADV/LD#
`ifdef SSRAMx36
      output wire [19: 0] SSRAM_A,              // SSRAM Address Bus
      inout  wire [35: 0] SSRAM_D,              // SSRAM Data Bus
`else
      output wire [21: 0] SSRAM_A,              // SSRAM Address Bus
      inout  wire [17: 0] SSRAM_D,              // SSRAM Data Bus
`endif
      // Front Panel Switches and LEDs
      input  wire         SW_RESET_N,           // Reset switch
      input  wire         SW_BOOT_N,            // Boot switch
      input  wire         SW_HALT_N,            // Halt switch
      output wire         LED_PWR_N,            // Power LED
      output wire         LED_RESET_N,          // Reset LED
      output wire         LED_BOOT_N,           // Boot LED
      output wire         LED_HALT_N,           // Halt LED
      // External SD Card Array
      output wire         ESD_SCLK,             // External SD serial clock
      input  wire         ESD_DI,               // External SD serial data in
      output wire         ESD_DO,               // External SD serial data out
      output wire         ESD_CS_N,             // External SD serial data chip select
      output wire         ESD_RST_N,            // External config reset
      output wire         ESD_RD_N,             // External config read
      output wire         ESD_WR_N,             // External config write
      output wire [ 4: 0] ESD_ADDR,             // External config address
      inout  wire         ESD_DIO,              // External config data inout!
      // Spare Stuff
      input  wire [ 1: 0] KEY,                  //
      input  wire [ 3: 0] SW,                   //
      input  wire         SPARE0,               // Spare switch
      input  wire         SPARE1,               // Spare switch
      input  wire         SPARE2                // Spare switch
);

   //
   // DZ11 Interface
   //

   wire [ 7: 0] dz_txd;                         // DZ Transmit Data
   wire [ 7: 0] dz_rxd;                         // DZ Receive Data
   wire [ 7: 0] DZ_DTR;                         // DZ Data Terminal Ready (not used)

   //
   // LP20
   //
   
   wire [ 7: 0] SD_CDI = {8{SD_CD}};            // SD Card Detect
   wire [ 7: 0] SD_WPI = {8{SD_WP}};            // Write Protect
   wire         reset_n;                        // Reset FIXME: routing?

   //
   // SOC
   //

   soc_system u0 (
      // Clock/Reset
      .reset_reset_n                   (reset_n),              // .reset.reset_n
      .clk_clk                         (FPGA_CLK1_50),         // .clk
      .h2f_reset_n                     (reset_n),              // .h2f_reset_reset_n
      //HPS Memory
      .memory_mem_a                    (HPS_DDR3_ADDR),        // .mem_a
      .memory_mem_ba                   (HPS_DDR3_BA),          // .mem_ba
      .memory_mem_ck                   (HPS_DDR3_CK_P),        // .mem_ck
      .memory_mem_ck_n                 (HPS_DDR3_CK_N),        // .mem_ck_n
      .memory_mem_cke                  (HPS_DDR3_CKE),         // .mem_cke
      .memory_mem_cs_n                 (HPS_DDR3_CS_N),        // .mem_cs_n
      .memory_mem_ras_n                (HPS_DDR3_RAS_N),       // .mem_ras_n
      .memory_mem_cas_n                (HPS_DDR3_CAS_N),       // .mem_cas_n
      .memory_mem_we_n                 (HPS_DDR3_WE_N),        // .mem_we_n
      .memory_mem_reset_n              (HPS_DDR3_RESET_N),     // .mem_reset_n
      .memory_mem_dq                   (HPS_DDR3_DQ),          // .mem_dq
      .memory_mem_dqs                  (HPS_DDR3_DQS_P),       // .mem_dqs
      .memory_mem_dqs_n                (HPS_DDR3_DQS_N),       // .mem_dqs_n
      .memory_mem_odt                  (HPS_DDR3_ODT),         // .mem_odt
      .memory_mem_dm                   (HPS_DDR3_DM),          // .mem_dm
      .memory_oct_rzqin                (HPS_DDR3_RZQ),         // .oct_rzqin
      //HPS Ethernet
      .hps_io_hps_io_emac1_inst_TX_CLK (HPS_ENET_TXCLK),       // .hps_io_emac1_inst_TXCLK
      .hps_io_hps_io_emac1_inst_TXD0   (HPS_ENET_TXD[0]),      // .hps_io_emac1_inst_TXD0
      .hps_io_hps_io_emac1_inst_TXD1   (HPS_ENET_TXD[1]),      // .hps_io_emac1_inst_TXD1
      .hps_io_hps_io_emac1_inst_TXD2   (HPS_ENET_TXD[2]),      // .hps_io_emac1_inst_TXD2
      .hps_io_hps_io_emac1_inst_TXD3   (HPS_ENET_TXD[3]),      // .hps_io_emac1_inst_TXD3
      .hps_io_hps_io_emac1_inst_TX_CTL (HPS_ENET_TXEN),        // .hps_io_emac1_inst_TXEN
      .hps_io_hps_io_emac1_inst_RX_CLK (HPS_ENET_RXCLK),       // .hps_io_emac1_inst_RXCLK
      .hps_io_hps_io_emac1_inst_RX_CTL (HPS_ENET_RXDV),        // .hps_io_emac1_inst_RXDV
      .hps_io_hps_io_emac1_inst_RXD0   (HPS_ENET_RXD[0]),      // .hps_io_emac1_inst_RXD0
      .hps_io_hps_io_emac1_inst_RXD1   (HPS_ENET_RXD[1]),      // .hps_io_emac1_inst_RXD1
      .hps_io_hps_io_emac1_inst_RXD2   (HPS_ENET_RXD[2]),      // .hps_io_emac1_inst_RXD2
      .hps_io_hps_io_emac1_inst_RXD3   (HPS_ENET_RXD[3]),      // .hps_io_emac1_inst_RXD3
      .hps_io_hps_io_emac1_inst_MDC    (HPS_ENET_MDC),         // .hps_io_emac1_inst_MDC
      .hps_io_hps_io_emac1_inst_MDIO   (HPS_ENET_MDIO),        // .hps_io_emac1_inst_MDIO
      //HPS SD card
      .hps_io_hps_io_sdio_inst_CLK     (HPS_SD_CLK),           // .hps_io_sdio_inst_CLK
      .hps_io_hps_io_sdio_inst_CMD     (HPS_SD_CMD),           // .hps_io_sdio_inst_CMD
      .hps_io_hps_io_sdio_inst_D0      (HPS_SD_D[0]),          // .hps_io_sdio_inst_D0
      .hps_io_hps_io_sdio_inst_D1      (HPS_SD_D[1]),          // .hps_io_sdio_inst_D1
      .hps_io_hps_io_sdio_inst_D2      (HPS_SD_D[2]),          // .hps_io_sdio_inst_D2
      .hps_io_hps_io_sdio_inst_D3      (HPS_SD_D[3]),          // .hps_io_sdio_inst_D3
      //HPS USB
      .hps_io_hps_io_usb1_inst_CLK     (HPS_USB_CLK),          // .hps_io_usb1_inst_CLK
      .hps_io_hps_io_usb1_inst_D0      (HPS_USB_D[0]),         // .hps_io_usb1_inst_D0
      .hps_io_hps_io_usb1_inst_D1      (HPS_USB_D[1]),         // .hps_io_usb1_inst_D1
      .hps_io_hps_io_usb1_inst_D2      (HPS_USB_D[2]),         // .hps_io_usb1_inst_D2
      .hps_io_hps_io_usb1_inst_D3      (HPS_USB_D[3]),         // .hps_io_usb1_inst_D3
      .hps_io_hps_io_usb1_inst_D4      (HPS_USB_D[4]),         // .hps_io_usb1_inst_D4
      .hps_io_hps_io_usb1_inst_D5      (HPS_USB_D[5]),         // .hps_io_usb1_inst_D5
      .hps_io_hps_io_usb1_inst_D6      (HPS_USB_D[6]),         // .hps_io_usb1_inst_D6
      .hps_io_hps_io_usb1_inst_D7      (HPS_USB_D[7]),         // .hps_io_usb1_inst_D7
      .hps_io_hps_io_usb1_inst_STP     (HPS_USB_STP),          // .hps_io_usb1_inst_STP
      .hps_io_hps_io_usb1_inst_DIR     (HPS_USB_DIR),          // .hps_io_usb1_inst_DIR
      .hps_io_hps_io_usb1_inst_NXT     (HPS_USB_NXT),          // .hps_io_usb1_inst_NXT
      //HPS SPI
      .hps_io_hps_io_spim1_inst_CLK    (HPS_SPI_CLK),          // .hps_io_spim1_inst_CLK
      .hps_io_hps_io_spim1_inst_MOSI   (HPS_SPI_MOSI),         // .hps_io_spim1_inst_MOSI
      .hps_io_hps_io_spim1_inst_MISO   (HPS_SPI_MISO),         // .hps_io_spim1_inst_MISO
      .hps_io_hps_io_spim1_inst_SS0    (HPS_SPI_SS),           // .hps_io_spim1_inst_SS0
      //HPS UART
      .hps_io_hps_io_uart0_inst_RX     (HPS_UART_RX),          // .hps_io_uart0_inst_RX
      .hps_io_hps_io_uart0_inst_TX     (HPS_UART_TX),          // .hps_io_uart0_inst_TX
      //HPS I2C0
      .hps_io_hps_io_i2c0_inst_SDA     (HPS_I2C0_SDA),         // .hps_io_i2c0_inst_SDA
      .hps_io_hps_io_i2c0_inst_SCL     (HPS_I2C0_SCL),         // .hps_io_i2c0_inst_SCL
      //HPS I2C1
      .hps_io_hps_io_i2c1_inst_SDA     (HPS_I2C1_SDA),         // .hps_io_i2c1_inst_SDA
      .hps_io_hps_io_i2c1_inst_SCL     (HPS_I2C1_SCL),         // .hps_io_i2c1_inst_SCL
      //GPIO
      .hps_io_hps_io_gpio_inst_GPIO09  (HPS_CONV_USB_N),       // .hps_io_gpio_inst_GPIO09
      .hps_io_hps_io_gpio_inst_GPIO35  (HPS_ENET_INT_N),       // .hps_io_gpio_inst_GPIO35
      .hps_io_hps_io_gpio_inst_GPIO40  (HPS_LTC_GPIO),         // .hps_io_gpio_inst_GPIO40
      .hps_io_hps_io_gpio_inst_GPIO53  (HPS_LED),              // .hps_io_gpio_inst_GPIO53
      .hps_io_hps_io_gpio_inst_GPIO54  (HPS_KEY),              // .hps_io_gpio_inst_GPIO54
      .hps_io_hps_io_gpio_inst_GPIO61  (HPS_GSENSOR_INT),      // .hps_io_gpio_inst_GPIO61
      //HDMI
`ifdef HDMI                  
      .clk_65_clk                      (HDMI_TX_CLK),          // PLL clock output
      .hdmi_vid_clk                    (HDMI_TX_CLK),          // HDMI Video clock input
      .hdmi_vid_data                   (HDMI_TX_D),            // HDMI data
      .hdmi_underflow                  (),                     // HDMI underflow
      .hdmi_vid_datavalid              (HDMI_TX_DE),           // HDMI data enable
      .hdmi_vid_v_sync                 (HDMI_TX_VS),           // HDMI vertical sync
      .hdmi_vid_h_sync                 (HDMI_TX_HS),           // HDMI horizontal sync
      .hdmi_vid_f                      (),                     // HDMI
      .hdmi_vid_h                      (),                     // HDMI
      .hdmi_vid_v                      (),                     // HDMI
`endif                  
      // LEDS
      .rpxx_leds                       (/*FIXME*/),            // RPXX LEDS
      // SD Card
      .sd_cd                           (SD_CDI),               // SD CD
      .sd_wp                           (SD_WPI),               // SD WP
      .sd_ss_n                         (SD_SS_N),              // SD CS_N
      .sd_sclk                         (SD_SCLK),              // SD SCLK
      .sd_miso                         (SD_MISO),              // SD MISO
      .sd_mosi                         (SD_MOSI),              // SD MOSI
      // SSRAM
      .ssram_clk                       (SSRAM_CLK),            // SSRAM CLK
      .ssram_we_n                      (SSRAM_WE_N),           // SSRAM WE_N
      .ssram_a                         (SSRAM_A),              // SSRAM ADDR
      .ssram_d                         (SSRAM_D),              // SSRAM DATA
      .ssram_adv                       (SSRAM_ADV),            // SSRAM ADV
      // DZ11
      .dz_rxd                          (dz_rxd),               // DZ RXD
      .dz_txd                          (dz_txd),               // DZ TXD
      .dz_dtr                          (DZ_DTR),               // DZ DTR
      // LP26
      .lp_rxd                          (LP_RXD),               // LP RXD
      .lp_txd                          (LP_TXD),               // LP TXD
      // Front Panel
      .fp_sw_reset_n                   (SW_RESET_N),           // Reset switch
      .fp_sw_boot_n                    (SW_BOOT_N),            // Boot switch
      .fp_sw_halt_n                    (SW_HALT_N),            // Halt switch
      .fp_led_pwr_n                    (LED_PWR_N),            // Power LED
      .fp_led_reset_n                  (LED_RESET_N),          // Reset LED
      .fp_led_boot_n                   (LED_BOOT_N),           // Boot LED
      .fp_led_halt_n                   (LED_HALT_N),           // Halt LED
      .cpuclk_clk                      (),                     // For testbench
      .cpurst_reset                    ()                      // For testbench
    );

   //
   // Not used.
   //

   assign RP_LEDS = {SD_CDI[3:0], SD_WPI[3:0]};

   //
   // DZ assignments
   //

   assign DZ_TXD[6:0] = dz_txd[6:0];
   assign dz_rxd[7:0] = {1'b0, DZ_RXD[6:0]};

endmodule
