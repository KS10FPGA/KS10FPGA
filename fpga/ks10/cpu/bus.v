////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS10 Bus Interface
//!
//! \details
//!
//! \todo
//!
//! \note
//!
//! \file
//!      bus.v
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

`include "useq/crom.vh"

module BUS(clk, rst, clken, crom, dp,
           vmaEXTENDED, vmaFLAGS, vmaADDR, pageADDR, aprFLAGS, 
           busREQ, busACK, busDATAO, busADDRO);
   
   parameter  cromWidth = `CROM_WIDTH;
   input                   clk;         // Clock
   input                   rst;         // Reset
   input                   clken;       // Clock enable
   input  [ 0:cromWidth-1] crom;        // Control ROM Data
   input  [ 0:35]          dp;          // Data path
   input                   vmaEXTENDED; // Extended VMA
   input  [ 0:13]          vmaFLAGS;    // VMA Flags
   input  [14:35]          vmaADDR;     // Virtual Memory Address
   input  [16:26]          pageADDR;    // Page Address
   input  [22:35]          aprFLAGS;    // APR Flags
   output                  busREQ;      // Bus Request
   input                   busACK;      // Bus Acknowledge                  
   output [ 0:35]          busDATAO;    // Bus Out
   output [ 0:35]          busADDRO;    // Bus Address

   //
   // Control ROM Decode
   //

   wire pageWRITE = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_PAGEWRITE);
   
   //
   // APR Flags
   //

   wire flagPAGEEN = aprFLAGS[23];

   //
   // VMA Flags
   //
   
   wire vmaPHYSICAL = vmaFLAGS[8];
   
   //
   // FIXME
   //

   wire DPM5_BUS_REQUEST = 1'b0;

   //
   // Paged Reference
   //

   wire pagedREF = DPM5_BUS_REQUEST & ~vmaPHYSICAL & flagPAGEEN;
   
   //
   // Data Output
   //
   // FIXME:
   //  Is the mux necessary?  It just zeros out dp[19:20] and dp[23:24].
   //

   reg [0:35] busDATAO;
   
   always @(dp or pageWRITE)
     begin
        if (pageWRITE)
          busDATAO[0:35] <= {dp[0:18], 2'b0, dp[21:22], 2'b0, dp[25:35]};
        else
          busDATAO[0:35] <= dp[0:35];
     end

   //
   // Address Output
   //

   reg [0:35] busADDRO;
   
   always @(pagedREF or vmaEXTENDED or vmaFLAGS or vmaADDR or pageADDR)
     begin
        if (pagedREF)
          busADDRO <= {vmaFLAGS, vmaADDR[14:15], pageADDR[16:26], vmaADDR[27:35]};
        else
          if (vmaEXTENDED)
            busADDRO <= {vmaFLAGS, vmaADDR};         
          else
            busADDRO <= {vmaFLAGS, vmaADDR} & 36'o777760_777777;
     end

   //
   // This is OK.  The CPU has the lowest priority.
   //
   
   assign busREQ = 1'b1;
   
   
   //
   // The first 7 bis are the Bus Command Bits
   //
   //                  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //   Memory Write | 0| 0| 1| 0| 0| 0| 0|      Unused        |                      Memory Address                             |
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //                  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //    Memory Read | 0| 1| 0| 0| 0| 0| 0|      Unused        |                      Memory Address                             |
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //                  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //     RMW Memory | 0| 1| 1| 0| 0| 0| 0|      Unused        |                      Memory Address                             |
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //                  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //       IO Write | 1| 0| 1| 0| 0| 0| 0|      Unused        | CTL NO |               Register Address                         |
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //                  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //  IO Write Byte | 1| 0| 1| 0| 0| 0| 1|      Unused        | CTL NO |               Register Address                         |
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //                  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //        IO Read | 1| 1| 0| 0| 0| 0| 0|      Unused        | CTL NO |               Register Address                         |
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //                  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   // Read Controller| 1| 0| 0| 0| 1| 0| 0|        Unused         |PI NO|                    Unused                              |
   //     Number     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //                  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   // Read Intr Vect | 1| 1| 0| 0| 0| 1| 0|      Unused        | CTL NO |                    Unused                              |
   //                +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //


/*   
   reg busREQUEST;
   reg pagedREF;
   reg pageWRITE;                       // Load page tables on external device
   reg vmaEXTENDED;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             busREQUEST  <= 1'b0;
             pagedREF    <= 1'b0;
             pageWRITE   <= 1'b0;
             vmaEXTENDED <= 1'b0;
          end
        else if (clken & vmaEN)
          begin
             ;
          end
     end

   if (busREQUEST)
     if (pagedREF)
       busTX[0:35] <= {commandBITS,  9'b0, pageADDR[16:27],vmaADDR[28:35]};
     else
       if (vmaEXTENDED)
         busTX[0:35] <= {commandBITS,  7'b0, vmaADDR[14:35]};         
       else
         busTX[0:35] <= {commandBITS, 11'b0, vmaADDR[18:35]};
   else
       

   





   
   wire [0: 1] txTYPE = {busREQUEST, pagedREF};

   always @(txTYPE or dp or busADDR or busEXTADDR)
     begin
        case (txTYPE)
          2'b00: busTX <= dp;
          2'b01: busTX <= 36'b0;
          2'b10: busTX <= busADDR;
          2'b11: busTX <= busEXTADDR;
        endcase
     end


   // 0-11
   
   if (busREQUEST)
     busTX[0:13] <= {commandBITS, 7'b0};
   else
     busTX[0:13] <= dp[0:13];

   
//   0 0 1
//   0 1 1
//   1 0 1
//   1 1 0  ->  enabled

//  not bus request -> enabled
//  vma extended -> enabled

   // note busTX[12:13] were absorbed above

   // 12-15
   
   if (busREQUEST)
     if (vmaEXTENDED) 
       busTX[14:15] <= vmaADDR[14:15];
     else
       busTX[14:15] <= 2'b0;
   else
     busTX[14:15] <= dp[14:15]   ;



   
    //
    // need or gate enable

// not bus request -> enabled
// vma extended -> enabled
// paged ref -> enabled

   // 16-17
   
    if (busREQUEST)
      if (pagedREF)
        busTX[16:17] <= pageADDR[16:17];
      else
         if (vmaEXTENDED)       
            busTX[16:17] <= vmaADDR[16:17];
         else
            busTX[16:17] <= 2'b0;
    else
      if (pagedREF)
         busTX[16:17] <= 2'b0;
      else      
         busTX[16:17] <= dp[16:17];


   
    //
    // need page write en enable
    // note that PAGE WRITE EN cuts out DP bits 19, 20, 23 and 24).

   // 19-20, 23-24
     
    if (busREQUEST)
      if (pagedREF)
        busTX[19:20] <= pageADDR[19:20];
        busTX[23:24] <= pageADDR[23:24];
   
      else
        busTX[19:20] <= vmaADDR[19:20];
        busTX[23:24] <= vmaADDR[23:24];
    else
      if (pagedREF)
        busTX[19:20] <= 2'b0;
        busTX[23:24] <= 2'b0;
      else      
        busTX[19:20] <= dp[19:20];
        busTX[23:24] <= dp[23:24];
                  
    
   // 18, 21-22, 25-27
   // FIXME note that PAGE WRITE EN cuts out DP bits 19, 20, 23 and 24).
   
   if (busREQUEST)
      if (pagedREF)
        begin
           busTX[   18] <= pageADDR[   18];
           busTX[21:22] <= pageADDR[21:22];
           busTX[25:27] <= pageADDR[21:25];
        end
      else
        begin
           busTX[   18] <= vmaADDR[   18];
           busTX[21:22] <= vmaADDR[21:22];
           busTX[25:27] <= vmaADDR[25:27];
        end
    else
      if (pagedREF)
        begin
           busTX[   18] <= 1'b0;
           busTX[21:22] <= 2'b0;
           busTX[25:27] <= 3'b0;
        end
      else 
        begin
           busTX[   18] <= dp[   18];
           busTX[21:22] <= dp[21:22];
           busTX[25:27] <= dp[25:27];
        end
        
   // 28-35
   
    if (busREQUEST)
      busTX[28:35] <= vmaADDR[28:35];
    else
      busTX[28:35] <= dp[28:35];


//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
   
   if (busREQUEST)
     if (vmaEXTENDED)
       busTX[ 0:15] <= {commandBITS, 7'b0, vmaADDR[14:15]};
     else
       busTX[ 0:15] <= {commandBITS, 9'b0,               };
   else
     if (pagedREF)
       busTX[14:15] <= {dp[0:15], 2'b0};
     else      
       busTX[14:15] <= {dp[0:17]      };
   
   

// not bus request -> enabled
// vma extended -> enabled
// paged ref -> enabled
   
       if (vmaEXTENDED)       
         busTX[16:17] <= vmaADDR[16:17];
       else
         busTX[16:17] <= 2'b0;

   
   
   if (busREQUEST)
     if (pagedREF)
       busTX[16:17] <= pageADDR[16:17];
     else
       if (vmaEXTENDED)       
         busTX[16:17] <= vmaADDR[16:17];
       else
         busTX[16:17] <= 2'b0;
   else
     if (pagedREF)
       busTX[16:17] <= 2'b0;
     else      
       busTX[16:17] <= dp[16:17];


   
   
   if (busREQUEST)
     if (vmaEXTENDED)       
       if (pagedREF)
         busTX[16:17] <= pageADDR[16:17];
       else
         busTX[16:17] <= vmaADDR[16:17];
     else
       if (pagedREF)
         busTX[16:17] <= pageADDR[16:17];
       else
         busTX[16:17] <= 2'b0;
   else
     if (pagedREF)
       busTX[16:17] <= 2'b0;
     else      
       busTX[16:17] <= dp[16:17];




   
//[]][][][][][][][]

BR PR VX
 0  0  0 ->  busTX[0:13] <= dp[0:13];
 0  0  1 ->  busTX[0:13] <= dp[0:13];
 0  1  0 ->  busTX[0:13] <= dp[0:13];
 0  1  1 ->  busTX[0:13] <= dp[0:13];
 1  0  0 ->  busTX[0:13] <= {commandBITS, 7'b0};
 1  0  1 ->  busTX[0:13] <= {commandBITS, 7'b0};
 1  1  0 ->  busTX[0:13] <= {commandBITS, 7'b0};
 1  1  1 ->  busTX[0:13] <= {commandBITS, 7'b0};

//[][][][][][][]

 BR PR VX
 0  0  0 ->  busTX[14:15] <= dp[14:15];
 0  0  1 ->  busTX[14:15] <= dp[14:15];
 0  1  0 ->  busTX[14:15] <= dp[14:15];
 0  1  1 ->  busTX[14:15] <= dp[14:15];
 1  0  0 ->  busTX[14:15] <= 2'b0;
 1  0  1 ->  busTX[14:15] <= vmaADDR[14:15];
 1  1  0 ->  busTX[14:15] <= 2'b0;
 1  1  1 ->  busTX[14:15] <= vmaADDR[14:15];

//[][][][][][][]
   
BR PR VX
 0  0  0 -> dp[16:17]       (E)
 0  0  1 -> dp[16:17]       (E)
 0  1  0 -> 00              (E)
 0  1  1 -> 00              (E)
 1  0  0 -> 00
 1  0  1 -> vmaADDR[16:17]  (E)
 1  1  0 -> pageADDR[16:17] (E)
 1  1  1 -> pageADDR[16:17] (E)

//[][][][][][][]
   
BR PR VX
 0  0  0 -> busTX[18:27] <= dp[18:27];
 0  0  1 -> busTX[18:27] <= dp[18:27];
 0  1  0 -> busTX[18:27] <= 9'b0;
 0  1  1 -> busTX[18:27] <= 9'b0;
 1  0  0 -> busTX[18:27] <= vmaADDR[18:27];
 1  0  1 -> busTX[18:27] <= vmaADDR[18:27];
 1  1  0 -> busTX[18:27] <= pageADDR[18:27];
 1  1  1 -> busTX[18:27] <= pageADDR[18:27];

//[][][][][][][]
   
BR PR VX
 0  0  0 -> busTX[28:35] <= dp[28:35];
 0  0  1 -> busTX[28:35] <= dp[28:35];
 0  1  0 -> busTX[28:35] <= dp[28:35];
 0  1  1 -> busTX[28:35] <= dp[28:35];
 1  0  0 -> busTX[28:35] <= vmaADDR[28:35];
 1  0  1 -> busTX[28:35] <= vmaADDR[28:35];
 1  1  0 -> busTX[28:35] <= vmaADDR[28:35];
 1  1  1 -> busTX[28:35] <= vmaADDR[28:35];


   000 : busTX[0:35] <= dp[0:35];
   001 : busTX[0:35] <= dp[0:35];
   010 : busTX[0:35] <= {dp[0:15],    11'b0, dp[28:35]}
   010 : busTX[0:35] <= {dp[0:15],    11'b0, dp[28:35]}
   010 : busTX[0:35] <= {commandBITS, 11'b0, vmaADDR[18:35]
   010 : busTX[0:35] <= {commandBITS,  7'b0, vmaADDR[14:35]
   010 : busTX[0:35] <= {commandBITS,  9'b0, pageADDR[16:35]
   010 : busTX[0:35] <= {commandBITS,  7'b0, vmaADDR[14:15], pageADDR[16:35]


   000 : busTX[0:35] <= dp[0:13],           dp[14:15],      dp[16:17],       dp[18:27],      dp[28:35]
   001 : busTX[0:35] <= dp[0:13],           dp[14:15],      dp[16:17],       dp[18:27],      dp[28:35]
   010 : busTX[0:35] <= {dp[0:13],          dp[14:15],      2'b0,            9'b0,           dp[28:35]
   010 : busTX[0:35] <= {dp[0:13],          dp[14:15],      2'b0,            9'b0,           dp[28:35]
   010 : busTX[0:35] <= {commandBITS, 7'b0, 2'b0,           2'b0,            vmaADDR[18:27], vmaADDR[28:35]
   010 : busTX[0:35] <= {commandBITS, 7'b0, vmaADDR[14:15], vmaADDR[16:17],  vmaADDR[18:27], vmaADDR[28:35]
   010 : busTX[0:35] <= {commandBITS, 7'b0, 2'b0,           pageADDR[16:17], pageADDR[18:27],vmaADDR[28:35]
   010 : busTX[0:35] <= {commandBITS, 7'b0, vmaADDR[14:15], pageADDR[16:17], pageADDR[18:27],vmaADDR[28:35]


   000 : busTX[0:35] <= dp[0:35];
   001 : busTX[0:35] <= dp[0:13];
   010 : busTX[0:35] <= {dp[0:15],    11'b0, dp[28:35]};
   010 : busTX[0:35] <= {dp[0:15],    11'b0, dp[28:35]};
   010 : busTX[0:35] <= {commandBITS, 11'b0, vmaADDR[18:35]};
   010 : busTX[0:35] <= {commandBITS,  7'b0, vmaADDR[14:35]
   010 : busTX[0:35] <= {commandBITS,  9'b0, pageADDR[16:27],vmaADDR[28:35]
   010 : busTX[0:35] <= {commandBITS,  7'b0, vmaADDR[14:15], pageADDR[16:27],vmaADDR[28:35]

*/
   
endmodule
