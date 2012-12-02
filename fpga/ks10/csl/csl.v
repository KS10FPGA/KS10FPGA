////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS-10 Console
//!
//! \details
//!
//!      Console Instruction Register (Device 0, IO Address 0200000)
//!
//!      Status register:
//!
//!                0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!        (LH)  |                                            |SR|SS|SE| 
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!   
//!               18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!        (RH)  |SC|SH|              |TE|RE|CE|                 |KI|KR|
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!
//!              SR : Run Switch
//!              SS : Single Step Switch
//!              SE : Execute Switch
//!              SC : Continue Switch
//!              SH : Halt Switch
//!              TE : Timer Enable
//!              RE : Trap Enable
//!              CE : Cache Enable
//!              KI : KS10 Interrupt
//!              KR : KS10 Reset
//!
//!      Console Status Register (Memory Addresss 0000031)
//!
//!                 0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!        (LH)  |                             |CE|ME|TE|MM|           |
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!   
//!               18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!        (RH)  |     |      Keep Alive       |           |BS|PF|FR|KF|
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!
//!              MM - Maintenance Mode : 
//!           
//!      Console Input Register (Memory Addresss 0000032)
//!
//!                 0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!        (LH)  |                                                     |
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!   
//!                18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!        (RH)  |                          |P |    Character          |
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!
//!              P  - Pending : When set indicates that a charactiver is
//!                             available to the CTY
//!
//!      Console Output Register (Memory Addresss 0000033)
//!
//!                 0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!        (LH)  |                                                     |
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!   
//!                18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!        (RH)  |                          |P |    Character          |
//!              +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//!
//!              P  - Pending : When set indicates that a charactiver is
//!                             available from the CTY
//!
//!          0000030 Halt Switch
//!          0000031 Console Status Word
//!          0000032 Console Input
//!          0000033 Console Output
//!          0000034 Klinik Input
//!          0000035 Klinik Output
//!          0000036 RH11 Address
//!          0000037 Unit Number
//!          0000040 Magtape Params
//!
//! \file
//!      csl.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012 Rob Doyle
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// version 2.1 of the License.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE. See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////
//
// Comments are formatted for doxygen
//

module CSL(clk, reset,
           cslALE, cslAD, cslRD_N, cslWR_N,
           busREQI,  busREQO,  busACKI,  busACKO,
           busADDRI, busADDRO, busDATAI, busDATAO,
           cpuHALT,
           cslSTEP, cslRUN, cslEXEC, cslCONT, cslHALT,
           cslTIMEREN, cslTRAPEN, cslCACHEEN,
           ks10INTR, ks10RESET
           );

   input         clk;           // Clock
   input         reset;         // Reset
   input         cslALE;        // Address Latch Enable
   inout  [7: 0] cslAD;         // Multiplexed Address/Data Bus
   input         cslRD_N;       // Read Strobe
   input         cslWR_N;       // Write Strobe
   input         busREQI;       // Bus Request In
   output        busREQO;       // Bus Request Out
   input         busACKI;       // Bus Acknowledge In
   output        busACKO;       // Bus Acknowledge Out
   input  [0:35] busADDRI;      // Bus Address In
   output [0:35] busADDRO;      // Bus Address Out
   input  [0:35] busDATAI;      // Bus Data In
   output [0:35] busDATAO;      // Bus Data Out
   input         cpuHALT;       // CPU Halt Status
   output        cslSTEP;       // Step Switch
   output        cslRUN;        // Run Switch
   output        cslEXEC;       // Execute Switch
   output        cslCONT;       // Continue Switch
   output        cslHALT;       // Halt switch
   output        cslTIMEREN;    // Timer Enable
   output        cslTRAPEN;     // Trap Enable
   output        cslCACHEEN;    // Cache Enable
   output        ks10INTR;      // KS10 Interrupt
   output        ks10RESET;     // KS10 Reset

   //
   // Console is Device 0
   //
   
   wire [ 0: 3] ubaDEV      = 4'b0000;
   //
   // Memory Address and Flags
   //
   
   wire         busREAD     = busADDRI[ 3]; 
   wire         busWRITE    = busADDRI[ 5];
   wire         busPHYSICAL = busADDRI[ 8];
   wire         busIO       = busADDRI[10];
   wire [14:17] busDEV      = busADDRI[14:17];
   wire [18:35] busADDR     = busADDRI[18:35];

   //
   // Synchronize Write signal to Console Processor
   //

   reg wr;
   reg cslWR;
   
   always @(posedge clk or posedge reset)
     begin
        if (reset)
          begin
             wr    <= 1'b0;
             cslWR <= 1'b0;
          end
        else
          begin
             wr    <= ~cslWR_N;
             cslWR <= wr;
          end
     end
   
   //
   // Console Bus Address Latch
   //

   reg [0:7] cslADDR;
   always @(posedge cslALE)
     begin
        cslADDR <= cslAD;
     end
   
   //
   // Write Decoder
   //
   
   reg [0:35] regIR;
   reg [0:35] regDATA;
   reg [0:35] regSTAT;
   reg [0:35] regADDR;

   always @(posedge clk or posedge reset)
     begin
        if (reset)
          begin
//           regIR   <= 36'b0;
             regIR   <= 36'o254000030600;
//           regIR   <= 36'o254000030624;
             regDATA <= 36'b0;
             regSTAT <= 36'b0;
             regADDR <= 36'b0;
          end
        else
          if (cslWR)
            case (cslADDR)
            
              //
              // Address Register
              //
            
              8'h03 : regADDR[ 0: 3] <= cslAD[3:0];
              8'h04 : regADDR[ 4:11] <= cslAD[7:0];
              8'h05 : regADDR[12:19] <= cslAD[7:0];
              8'h06 : regADDR[20:27] <= cslAD[7:0];
              8'h07 : regADDR[28:35] <= cslAD[7:0];

              //
              // Data Register
              //
            
              8'h13 : regDATA[ 0: 3] <= cslAD[3:0];
              8'h14 : regDATA[ 4:11] <= cslAD[7:0];
              8'h15 : regDATA[12:19] <= cslAD[7:0];
              8'h16 : regDATA[20:27] <= cslAD[7:0];
              8'h17 : regDATA[28:35] <= cslAD[7:0];

              //
              // Control/Status Register
              //

              8'h23 : regSTAT[ 0: 3] <= cslAD[3:0];
              8'h24 : regSTAT[ 4:11] <= cslAD[7:0];
              8'h25 : regSTAT[12:19] <= cslAD[7:0];
              8'h26 : regSTAT[20:27] <= cslAD[7:0];
              8'h27 : regSTAT[28:35] <= cslAD[7:0];
            
              //
              // Console Instruction Register
              //
            
              8'h33 : regIR[ 0: 3] <= cslAD[3:0];
              8'h34 : regIR[ 4:11] <= cslAD[7:0];
              8'h35 : regIR[12:19] <= cslAD[7:0];
              8'h36 : regIR[20:27] <= cslAD[7:0];
              8'h37 : regIR[28:35] <= cslAD[7:0];
              
            endcase
     end

   //
   // Read Decoder
   //

   reg [7:0] adOUT;
   
   always @(cslADDR or regADDR or regDATA or regSTAT or regIR)
        
        case (cslADDR)
            
          //
          // Address Register
          //
            
          8'h03 : adOUT <= {4'b0, regADDR[0:3]};
          8'h04 : adOUT <= regADDR[ 4:11];
          8'h05 : adOUT <= regADDR[12:19];
          8'h06 : adOUT <= regADDR[20:27];
          8'h07 : adOUT <= regADDR[28:35];

          //
          // Data Register
          //
            
          8'h13 : adOUT <= {4'b0, regDATA[0:3]};
          8'h14 : adOUT <= regDATA[ 4:11];
          8'h15 : adOUT <= regDATA[12:19];
          8'h16 : adOUT <= regDATA[20:27];
          8'h17 : adOUT <= regDATA[28:35];

          //
          // Control/Status Register
          //
          
          8'h23 : adOUT <= {4'b0, regSTAT[0:3]};
          8'h24 : adOUT <= regSTAT[ 4:11];
          8'h25 : adOUT <= regSTAT[12:19];
          8'h26 : adOUT <= regSTAT[20:27];
          8'h27 : adOUT <= regSTAT[28:35];
            
          //
          // Console Instruction Register
          //
          
          8'h33 : adOUT <= {4'b0, regIR[0:3]};
          8'h34 : adOUT <= regIR[ 4:11];
          8'h35 : adOUT <= regIR[12:19];
          8'h36 : adOUT <= regIR[20:27];
          8'h37 : adOUT <= regIR[28:35];

          //
          // Everything else
          //
          
          default : adOUT <= 8'b0;
          
        endcase

   //
   // Handle bi-directional bus output
   //
   
   assign cslAD = (~cslRD_N) ? adOUT : 8'bz;
   
   //
   // Console Instruction Register (IO Address 200000)
   //
   // Details:
   //  When the 'execute switch' is asserted at power-up the KS10
   //  microcode performs a IO read of the Console Instruction
   //  Register (regIR) at IO address o200000 and then executes that
   //  instruction.  This mechanism allowed the Console set the
   //  address that the KS10 began execution.
   //
   //  This is normally a JRST instruction which causes the code to
   //  jump to the entry point of the code/bootloader.
   //

   assign busREQO  = 1'b0;
   assign busACKO  = busIO & busREAD & busPHYSICAL & (busDEV == ubaDEV) & (busADDR == 18'o200000);
   assign busDATAO = busACKO ? regIR : 36'bx;
   assign busADDRO = 36'bx;

   //
   // Status Register
   //

   assign cslRUN     =  regSTAT[15];
   assign cslSTEP    =  regSTAT[16];
   assign cslEXEC    =  regSTAT[17];
   assign cslCONT    =  regSTAT[18];
   assign cslHALT    =  regSTAT[19];
   assign cslTIMEREN =  regSTAT[25];
   assign cslTRAPEN  =  regSTAT[26];
   assign cslCACHEEN =  regSTAT[27];
   assign ks10INTR   =  regSTAT[34];
   assign ks10RESET  = ~regSTAT[35];
   
   //
   // Print the Halt Status Block
   // synthesis translate_off
   //
   
   always @(posedge clk)
     begin
        if (busWRITE & ~busIO & busPHYSICAL)
          begin
             case (busADDR)
               18'o000000 :
                 begin
                  $display("");
                  case (busDATAI[24:35])
                    12'o0000 : $display("Microcode Startup.");
                    12'o0001 : $display("Halt Instruction.");
                    12'o0002 : $display("Console Halt.");
                    12'o0100 : $display("IO Page Failure.");
                    12'o0101 : $display("Illegal Interrupt Instruction.");
                    12'o0102 : $display("Pointer to Unibus Vector is zero.");
                    12'o1000 : $display("Illegal Microcode Dispatch.");
                    12'o1005 : $display("Microcode Startup Check Failed.");
                    default  : $display("Unknown Halt Cause.");
                  endcase
               end
               18'o000001 : $display("PC  is %06o", busDATAI);
               18'o376000 : $display("MAG is %06o", busDATAI);
               18'o376001 : $display("PC  is %06o", busDATAI);
               18'o376002 : $display("HR  is %06o", busDATAI);
               18'o376003 : $display("AR  is %06o", busDATAI);
               18'o376004 : $display("ARX is %06o", busDATAI);
               18'o376005 : $display("BR  is %06o", busDATAI);
               18'o376006 : $display("BRX is %06o", busDATAI);
               18'o376007 : $display("ONE is %06o", busDATAI);
               18'o376010 : $display("EBR is %06o", busDATAI);
               18'o376011 : $display("UBR is %06o", busDATAI);
               18'o376012 : $display("MSK is %06o", busDATAI);
               18'o376013 : $display("FLG is %06o", busDATAI);
               18'o376014 : $display("PI  is %06o", busDATAI);
               18'o376015 : $display("X1  is %06o", busDATAI);
               18'o376016 : $display("TO  is %06o", busDATAI);
               18'o376017 : $display("T1  is %06o", busDATAI);
               18'o376020 : $display("VMA is %06o", busDATAI);
               18'o376021 : $display("FE  is %06o", busDATAI);
             endcase
          end
     end
   
   // synthesis translate_on

endmodule
