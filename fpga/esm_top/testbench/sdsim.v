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
// Copyright (C) 2012-2014 Rob Doyle
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

`ifndef SDSIM_DSK
 `define SDSIM_DSK "../rtl/esm/sdsim.dsk"
`endif


 module SDSIM (rst, clk, sdMISO, sdMOSI, sdSCLK, sdCS);

   input        rst;                    // Reset
   input        clk;                    // Clock
   output       sdMISO;                 // MISO
   input        sdMOSI;                 // MOSI
   input        sdSCLK;                 // SCLK
   input        sdCS;                   // CS

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



   integer      file;                   // File descriptor for disk image file
   integer      size;                   // File size
   integer      bitcnt;
   integer      bytecnt;

   reg [0: 7]   image [0:4194303];      // Disk image (4 MB)
   reg [0:21]   index;                  // Index into disk image

   reg [0:55]   spiRX;
   reg [0:55]   spiTX;
   reg [0: 3]   state;

   reg [0: 1]   clkstat;





   //
   // This process reads the disk file into the image array
   //

   initial
     begin

        file = $fopen(`SDSIM_DSK, "rb");

        if (file != 0)
          begin
             size = $fread(image, file);
             $display("[%11.3f] KS10: Read disk image \"%s\" - %7d bytes.",
                      $time/1.0e3, `SDSIM_DSK, size);
             $fclose(file);
          end
        else
          begin
             $display("[%11.3f] KS10: Unable to open \"%s\".\n",
                      $time/1.0e3, `SDSIM_DSK);
             $stop;
          end
     end

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          clkstat = 0;
        else
          clkstat = {clkstat[1], sdSCLK};
     end

   //
   // State Machine
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
            spiRX  <= {56{1'b1}};
            spiTX  <= {56{1'b1}};
            state  <= stateRESET;
            index  <= 0;
            bitcnt <= 0;
          end
        else
          begin

             if (sdCS)
               spiRX <= {56{1'b1}};
             else if (clkstat == 2'b01)
               spiRX <= {spiRX[1:55], sdMOSI};

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
                         bitcnt <= 47;
                         spiTX  <= 56'hff_ff_00_ff_ff_fe_ff;
                         index  <= spiRX[27:39] * 512;
                         state  <= stateREAD0;
                      end

                    //
                    // CMD24:
                    //  Write Single
                    //

                    else if ((spiRX[0:7] == 8'h58) && (clkstat == 2'b10))
                      begin
                         bitcnt <= 47;
                         spiTX  <= 56'hff_ff_00_ff_ff_fe_ff;
                         index  <= spiRX[27:39] * 512;
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
                           bitcnt  <= 7;
                           bytecnt <= 0;
                           spiTX   <= {image[index], 48'h00_00_00_00_00_00};
                           index   <= index + 1;
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
                      if (sdCS)
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
                             bitcnt  <= 7;
                             spiTX   <= {image[index], 48'h00_00_00_00_00_00};
                             index   <= index + 1;
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
                             bitcnt  <= 7;
                             bytecnt <= 0;
                             image[index] = spiRX[48:55];
                             spiTX   <=56'hff_ff_ff_ff_ff_ff_ff;
                             index   <= index + 1;
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
                      if (sdCS)
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
                                bitcnt  <= 7;
                                image[index] = spiRX[48:55];
                                spiTX   <= 56'hff_ff_ff_ff_ff_ff_ff;
                                index   <= index + 1;
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
                      if ((bitcnt == 0) || sdCS)
                        begin
                           //bitcnt  <= 15;
                           //bytecnt <= 0;
                           //spiTX   <= x"00_ff_ff_ff_ff_ff_ff";
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

   assign sdMISO = spiTX[0];

endmodule
