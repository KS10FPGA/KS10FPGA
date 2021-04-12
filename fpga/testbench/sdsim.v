///////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor Testbench
//
// Brief
//   KS-10 FPGA SD Card Simulation
//
// File
//   sdsim.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2021 Rob Doyle
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

//
// The Verilog simulator uses 32-bit signed integers.  This is only big enough
// to SEEK a 2GB disk which is too small to simulate our entire disk array.
// Luckily a single RP07 is less than 1GB on disk.  Instead of simulating the
// SD Card with a single file, we will use a seperate file for each if the 8
// disk units.
//

`ifndef UNIT0_DSK
 `define UNIT0_DSK "./unit0.dsk"
`endif

`ifndef UNIT1_DSK
 `define UNIT1_DSK "./unit1.dsk"
`endif

`ifndef UNIT2_DSK
 `define UNIT2_DSK "./unit2.dsk"
`endif

`ifndef UNIT3_DSK
 `define UNIT3_DSK "./unit3.dsk"
`endif

`ifndef UNIT4_DSK
 `define UNIT4_DSK "./unit4.dsk"
`endif

`ifndef UNIT5_DSK
 `define UNIT5_DSK "./unit5.dsk"
`endif

`ifndef UNIT6_DSK
 `define UNIT6_DSK "./unit6.dsk"
`endif

`ifndef UNIT7_DSK
 `define UNIT7_DSK "./unit7.dsk"
`endif

`define SEEK_SET 0
`define SEEK_CUR 1
`define SEEK_END 2

`define NULL 0
`define EOF 32'hFFFF_FFFF

 module SDSIM (
      input  wire rst,                  // Reset
      input  wire clk,                  // Clock
      output wire SD_MISO,              // MISO
      input  wire SD_MOSI,              // MOSI
      input  wire SD_SCLK,              // SCLK
      input  wire SD_SS_N               // SS
   );

   //
   // States
   //

   localparam [0:3] stateRESET  = 0,
                    stateRSP    = 1,
                    stateREAD0  = 2,
                    stateREAD1  = 3,
                    stateREAD2  = 4,
                    stateWRITE0 = 5,
                    stateWRITE1 = 6,
                    stateWRITE2 = 7;

   //
   // Open the files
   //

   integer fd[0:7];

   initial
     begin

        //
        // Open Unit 0
        //

        fd[0] = $fopen(`UNIT0_DSK, "r+b");
        if (fd[0] == 0)
          begin
             $display("[%11.3f] KS10: SDSIM - Unable to open \"%s\" on unit 0.", $time/1.0e3, `UNIT0_DSK);
             $stop;
          end
        $display("[%11.3f] KS10: SDSIM - Opened \"%s\" on unit 0.", $time/1.0e3, `UNIT0_DSK);

        //
        // Open Unit 1
        //

        fd[1] = $fopen(`UNIT1_DSK, "r+b");
        if (fd[1] == 0)
          begin
             $display("[%11.3f] KS10: SDSIM - Unable to open \"%s\" on unit 1.", $time/1.0e3, `UNIT1_DSK);
             $stop;
          end
        $display("[%11.3f] KS10: SDSIM - Opened \"%s\" on unit 1.", $time/1.0e3, `UNIT1_DSK);

        //
        // Open Unit 2
        //

        fd[2] = $fopen(`UNIT2_DSK, "r+b");
        if (fd[2] == 0)
          begin
             $display("[%11.3f] KS10: SDSIM - Unable to open \"%s\" on unit 2.", $time/1.0e3, `UNIT2_DSK);
             $stop;
          end
        $display("[%11.3f] KS10: SDSIM - Opened \"%s\" on unit 2.", $time/1.0e3, `UNIT2_DSK);

        //
        // Open Unit 3
        //

        fd[3] = $fopen(`UNIT3_DSK, "r+b");
        if (fd[3] == 0)
          begin
             $display("[%11.3f] KS10: SDSIM - Unable to open \"%s\" on unit 3.", $time/1.0e3, `UNIT3_DSK);
             $stop;
          end
        $display("[%11.3f] KS10: SDSIM - Opened \"%s\" on unit 3.", $time/1.0e3, `UNIT3_DSK);

        //
        // Open Unit 4
        //

        fd[4] = $fopen(`UNIT4_DSK, "r+b");
        if (fd[4] == 0)
          begin
             $display("[%11.3f] KS10: SDSIM - Unable to open \"%s\" on unit 4.", $time/1.0e3, `UNIT4_DSK);
             $stop;
          end
        $display("[%11.3f] KS10: SDSIM - Opened \"%s\" on unit 4.", $time/1.0e3, `UNIT4_DSK);

        //
        // Open Unit 5
        //

        fd[5] = $fopen(`UNIT5_DSK, "r+b");
        if (fd[5] == 0)
          begin
             $display("[%11.3f] KS10: SDSIM - Unable to open \"%s\" on unit 5.", $time/1.0e3, `UNIT5_DSK);
             $stop;
          end
        $display("[%11.3f] KS10: SDSIM - Opened \"%s\" on unit 5.", $time/1.0e3, `UNIT5_DSK);

        //
        // Open Unit 6
        //

        fd[6] = $fopen(`UNIT6_DSK, "r+b");
        if (fd[6] == 0)
          begin
             $display("[%11.3f] KS10:SDSIM -  Unable to open \"%s\" on unit 6.", $time/1.0e3, `UNIT6_DSK);
             $stop;
          end
        $display("[%11.3f] KS10: SDSIM - Opened \"%s\" on unit 6.", $time/1.0e3, `UNIT6_DSK);

        //
        // Open Unit 7
        //

        fd[7] = $fopen(`UNIT7_DSK, "r+b");
        if (fd[7] == 0)
          begin
             $display("[%11.3f] KS10: SDSIM - Unable to open \"%s\" on unit 7.", $time/1.0e3, `UNIT7_DSK);
             $stop;
          end
        $display("[%11.3f] KS10: SDSIM - Opened \"%s\" on unit 7.", $time/1.0e3, `UNIT7_DSK);
     end

   //
   // Syncrhonize SD_SCLK
   //

   reg [0: 1] clkstat;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          clkstat <= 0;
        else
          clkstat <= {clkstat[1], SD_SCLK};
     end

   //
   // State Machine
   //

   reg [0:55] spiRX;
   reg [0:55] spiTX;
   reg [0: 3] state;
   reg [0: 7] ch;

   integer status;                      // File status
   integer bitcnt;                      // Bit counter
   integer bytecnt;                     // Byte counter
   integer sector;                      // Sector address
   integer position;                    // fseek position
   integer disk;                        // Disk

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             ch      <= 0;
             spiRX   <= {56{1'b1}};
             spiTX   <= {56{1'b1}};
             state   <= stateRESET;
             bitcnt  <= 0;
             bytecnt <= 0;
          end
        else
          begin

             if (SD_SS_N)
               spiRX <= {56{1'b1}};
             else if (clkstat == 2'b01)
               spiRX <= {spiRX[1:55], SD_MOSI};

             case (state)

               stateRESET:
                 begin

                    //
                    // CMD0:
                    //

                    if ((spiRX[0:7] == 8'h40) && (clkstat == 2'b10))
                      begin
                         bitcnt <= 15;
                         spiTX  <= 56'hff_01_ff_ff_ff_ff_ff;
                         state  <= stateRSP;
                       end

                    //
                    // CMD8:
                    //

                    else if ((spiRX[0:7] == 8'h48) && (clkstat == 2'b10))
                      begin
                         bitcnt <= 55;
                         spiTX  <= 56'hff_01_00_00_01_aa_ff;
                         state  <= stateRSP;
                      end

                    //
                    // CMD13:
                    //  Send Status
                    //

                    else if ((spiRX[0:7] == 8'h4d) && (clkstat == 2'b10))
                      begin
                         bitcnt <= 39;
                         spiTX  <= 56'hff_ff_00_00_ff_ff_ff;
                         state  <= stateRSP;
                      end

                    //
                    // CMD17:
                    //  Read Single
                    //

                    else if ((spiRX[0:7] == 8'h51) && (clkstat == 2'b10))
                      begin

                         disk   = spiRX[16:18];
                         sector = spiRX[19:39];
                         position = sector * 512;
                         $display("[%11.3f] KS10: SDSIM - Disk %1d seek to sector 0x%08x for read.",
                                  $time/1.0e3, disk, sector);

                         status = $fseek(fd[disk], position, `SEEK_SET);
                         if (status == `EOF)
                           begin
                              $display("[%11.3f] KS10: SDSIM - $fseek() returned EOF.", $time/1.0e3);
                              $stop();
                           end

                         bitcnt <= 47;
                         spiTX  <= 56'hff_ff_00_ff_ff_fe_ff;
                         state  <= stateREAD0;
                      end

                    //
                    // CMD24:
                    //  Write Single
                    //

                    else if ((spiRX[0:7] == 8'h58) && (clkstat == 2'b10))
                      begin

                         disk   = spiRX[16:18];
                         sector = spiRX[19:39];
                         position = sector * 512;
                         $display("[%11.3f] KS10: SDSIM - Disk %d seek to sector 0x%08x for write.",
                                  $time/1.0e3, disk, sector);

                         status = $fseek(fd[disk], position, `SEEK_SET);
                         if (status == `EOF)
                           begin
                              $display("[%11.3f] KS10: SDSIM - $fseek() returned EOF.", $time/1.0e3);
                              $stop();
                           end

                         bitcnt <= 47;
                         spiTX  <= 56'hff_ff_00_ff_ff_fe_ff;
                         state  <= stateWRITE0;
                      end

                    //
                    // ACMD41:
                    //

                    else if ((spiRX[0:7] == 8'h69) && (clkstat == 2'b10))
                      begin
                         bitcnt <= 23;
                         spiTX  <= 56'hff_00_ff_ff_ff_ff_ff;
                         state  <= stateRSP;
                      end

                    //
                    // CMD55:
                    //

                    else if ((spiRX[8:15] == 8'h77) && (clkstat == 2'b10))
                      begin
                         bitcnt <= 15;
                         spiTX  <= 56'hff_01_ff_ff_ff_ff_ff;
                         state  <= stateRSP;
                      end

                    //
                    // CMD58:
                    //

                    else if ((spiRX[0:7] == 8'h7a) && (clkstat == 2'b10))
                      begin
                         bitcnt <= 55;
                         spiTX  <= 56'hff_00_e0_ff_80_00_ff;
                         state  <= stateRSP;
                      end

                 end

               //
               // Send Response:
               //

               stateRSP:
                 begin
                    if (bitcnt == 0)
                      state <= stateRESET;
                    else if (clkstat == 2'b10)
                      begin
                         bitcnt <= bitcnt - 1;
                         spiTX  <= {spiTX[1:55], 1'b1};
                      end
                 end

               //
               // stateREAD0:
               //

               stateREAD0:
                 if (clkstat == 2'b10)
                   begin
                      if (bitcnt == 0)
                        begin
                           ch = $fgetc(fd[disk]);
                           bitcnt  <= 7;
                           bytecnt <= 0;
                           spiTX   <= {ch, 48'h00_00_00_00_00_00};
                           state   <= stateREAD1;
                        end
                      else
                        begin
                           bitcnt  <= bitcnt - 1;
                           spiTX   <= {spiTX[1:55], 1'b1};
                        end
                   end

               //
               // stateREAD1
               //

               stateREAD1:
                 if (clkstat == 2'b10)
                   begin
                      if (SD_SS_N)
                        begin
                           spiTX <= 56'hff_ff_ff_ff_ff_ff_ff;
                           state <= stateRESET;
                        end
                      else if (bitcnt == 0)
                        if (bytecnt == 511)
                          begin
                             bitcnt  <= 15;
                             spiTX   <= 56'hff_ff_ff_ff_ff_ff_ff;
                             state   <= stateREAD2;
                          end
                        else
                          begin
                             ch  = $fgetc(fd[disk]);
                             bitcnt  <= 7;
                             spiTX   <= {ch, 48'h00_00_00_00_00_00};
                             bytecnt <= bytecnt + 1;
                          end
                      else
                        begin
                           bitcnt <= bitcnt - 1;
                           spiTX  <= {spiTX[1:55], 1'b1};
                        end
                   end

               //
               // stateREAD2:
               //  Send 2 CRC bytes
               //

               stateREAD2:
                 if (clkstat == 2'b10)
                   begin
                      if (bitcnt == 0)
                        state <= stateRESET;
                      else
                        begin
                           bitcnt <= bitcnt - 1;
                           spiTX  <= {spiTX[1:55], 1'b1};
                        end
                   end

               //
               // stateWRITE0:
               //

               stateWRITE0:
                   if (clkstat == 2'b10)
                     begin
                        if (bitcnt == 0)
                          begin
                             $fwrite(fd[disk], "%c", spiRX[48:55]);
                             bitcnt  <= 7;
                             bytecnt <= 0;
                             spiTX   <=56'hff_ff_ff_ff_ff_ff_ff;
                             state   <= stateWRITE1;
                          end
                        else
                          begin
                             bitcnt  <= bitcnt - 1;
                             spiTX   <= {spiTX[1:55], 1'b1};
                          end
                     end

               //
               // stateWRITE1
               //

               stateWRITE1:
                 if (clkstat == 2'b10)
                   begin
                      if (SD_SS_N)
                        begin
                           spiTX <= 56'hff_ff_ff_ff_ff_ff_ff;
                           state <= stateRESET;
                        end
                      else if (bitcnt == 0)
                        begin
                           if (bytecnt == 511)
                             begin
                                bitcnt <= 55;
                                spiTX  <= 56'hff_05_00_00_00_00_ff;
                                state  <= stateWRITE2;
                             end
                           else
                             begin
                                $fwrite(fd[disk], "%c", spiRX[48:55]);
                                bitcnt  <= 7;
                                spiTX   <= 56'hff_ff_ff_ff_ff_ff_ff;
                                bytecnt <= bytecnt + 1;
                             end
                        end
                      else
                        begin
                           bitcnt <= bitcnt - 1;
                           spiTX  <= {spiTX[1:55], 1'b1};
                        end
                   end

               //
               // stateWRITE2:
               //  Write 2 CRC bytes plus some busy (zero) tokens
               //

               stateWRITE2:
                 if (clkstat == 2'b10)
                   begin
                      if ((bitcnt == 0) || SD_SS_N)
                        begin
                           $fflush(fd[disk]);
                           state  <= stateRESET;
                        end
                      else
                        begin
                           bitcnt <= bitcnt - 1;
                           spiTX  <= {spiTX[1:55], 1'b1};
                        end
                   end

             endcase
          end
     end

   //
   // Create output serial data
   //

   assign SD_MISO = spiTX[0];

endmodule
