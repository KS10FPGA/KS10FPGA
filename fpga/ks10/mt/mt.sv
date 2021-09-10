////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Mag Tape
//
// Details
//
// Notes
//   Regarding endian-ness:
//     The KS10 backplane bus is 36-bit big-endian and uses [0:35] notation.
//     The IO Device are 36-bit little-endian (after Unibus) and uses [35:0]
//     notation.
//
//     Whereas the 'Unibus' is 18-bit data and 16-bit address, I've implemented
//     the IO bus as 36-bit address and 36-bit data just to keep things simple.
//
// File
//   mt.sv
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

`include "mt.vh"
`include "mtas.vh"
`include "mtds.vh"
`include "mtmr.vh"
`include "mttc.vh"
`include "mtcs1.vh"

module MT (
      massbus.slave       massbus,                      // Massbus interface
      input  wire [ 7: 0] mtMOL,                        // MT Media On-line
      input  wire [ 7: 0] mtWRL,                        // MT Write Lock
      input  wire [ 7: 0] mtDPR                         // MT Drive Present
   );

   //
   // MT Parameters
   //

   parameter [15: 0] drvTYPE  = (`mtDT_TM03|`mtDT_TU77);// Drive type (TM03/TU77)
   parameter [15: 0] drvSN    = `mtSN_SN0;              // Drive serial number
   parameter [ 2: 0] mtNUM    = 0;                      //
   parameter [ 3: 0] slvADDR  = `mtSLV_SLV0;            // Slave Addresse

   //
   // Addressing
   //

   localparam [18:35] mtREGCS1 = 5'o00,           // Control/Status Register
                      mtREGFC  = 5'o05,           // Frame Count Register
                      mtREGAS  = 5'o04,           // Attention Summary Register
                      mtREGCC  = 5'o07,           // Check Character Register
                      mtREGMR  = 5'o03,           // Maintenance Register
                      mtREGTC  = 5'o11;           // Tape Control Register

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35: 0] mtDATAI = massbus.mbDATAI[0:35];

   //
   // Massbus Addressing
   //

   wire         mtREAD   = massbus.mbREAD;
   wire         mtWRITE  = massbus.mbWRITE;
   wire [ 4: 0] mtREGSEL = massbus.mbREGSEL;

   //
   // Registers
   //

   logic [15: 0] mtCS1;                                 // Control/Status Register
   logic [15: 0] mtFC;                                  // Frame Count Register
   logic [15: 0] mtDS;                                  // Drive Status Register
   logic [15: 0] mtER;                                  // Error Register
   logic [15: 0] mtMR;                                  // Maintenance Register
   logic [15: 0] mtTC;                                  // Tape Control Register

   //
   // RHCS2 Decode
   //

   wire [ 2: 0] mtUNIT = massbus.mbUNIT;                // Unit select
   wire         mtPAT  = massbus.mbPAT;                 // Parity Test
   wire         mtINIT = massbus.mbINIT;                // Initialize

   //
   // MTTC Decode
   //

   wire [ 2: 0] mtSLAVE = `mtTC_SS(mtTC);               // Slave Select

   //
   // Initialize
   //

   wire         mtSELECT = (mtUNIT == 3'b000);          // Unit select

   //
   // Bus Decoder
   //

   wire mtWRCS1 = mtWRITE & (mtREGSEL == mtREGCS1) & mtSELECT;   // MTCS1
   wire mtWRFC  = mtWRITE & (mtREGSEL == mtREGFC ) & mtSELECT;   // MTFC
   wire mtWRAS  = mtWRITE & (mtREGSEL == mtREGAS ) & mtSELECT;   // MTAS
   wire mtWRCC  = mtWRITE & (mtREGSEL == mtREGCC ) & mtSELECT;   // MTCC
   wire mtWRMR  = mtWRITE & (mtREGSEL == mtREGMR ) & mtSELECT;   // MTMR
   wire mtWRTC  = mtWRITE & (mtREGSEL == mtREGTC ) & mtSELECT;   // MTTC

   //
   // Parity Error
   //

   wire mtSETPAR = (/*(mtPAT & mtWRCS1) |*/
                    (mtPAT & mtWRFC ) |
                    (mtPAT & mtWRCC ) |
                    (mtPAT & mtWRMR ) |
                    (mtPAT & mtWRTC ));

   //
   // Clear attention
   //
   // Trace
   //  M8909/MBI3/E57
   //  M8909/MBI3/E77
   //  M8909/MBI3/E84
   //

   wire mtGO     = mtWRCS1 & `mtCS1_GO(mtDATAI) & !mtPAT;        // Go command
   wire mtERR    = `mtDS_ERR(mtDS);
   wire mtCLRATA = ((mtWRAS & `mtAS_ATA7(mtDATAI) & (mtNUM == 7)) |
                    (mtWRAS & `mtAS_ATA6(mtDATAI) & (mtNUM == 6)) |
                    (mtWRAS & `mtAS_ATA5(mtDATAI) & (mtNUM == 5)) |
                    (mtWRAS & `mtAS_ATA4(mtDATAI) & (mtNUM == 4)) |
                    (mtWRAS & `mtAS_ATA3(mtDATAI) & (mtNUM == 3)) |
                    (mtWRAS & `mtAS_ATA2(mtDATAI) & (mtNUM == 2)) |
                    (mtWRAS & `mtAS_ATA1(mtDATAI) & (mtNUM == 1)) |
                    (mtWRAS & `mtAS_ATA0(mtDATAI) & (mtNUM == 0)) |
                    (mtGO & !mtERR));

   //
   // Illegal Register
   //

   wire mtSETILR = 0;

//   wire mtSETILR = ((mtREAD  & (mtREGSEL == 5'o37)) |   //FIXME:
//                  (mtWRITE & (mtREGSEL == 5'o37)));   //FIXME:

   //
   // Function Decoder
   //
   // Commands are ignored if they have incorrect parity.
   //
   // Trace
   //

   wire mtFUN_UNLOAD   = mtGO & (`mtCS1_FUN(mtDATAI) == `mtCS1_FUN_UNLOAD  );   // Unload command
   wire mtFUN_REWING   = mtGO & (`mtCS1_FUN(mtDATAI) == `mtCS1_FUN_REWIND  );   // Rewind command
   wire mtFUN_DRVCLR   = mtGO & (`mtCS1_FUN(mtDATAI) == `mtCS1_FUN_CLEAR   );   // Drive clear command
   wire mtFUN_PRESET   = mtGO & (`mtCS1_FUN(mtDATAI) == `mtCS1_FUN_PRESET  );   // Read-in preset command
   wire mtFUN_ERASE    = mtGO & (`mtCS1_FUN(mtDATAI) == `mtCS1_FUN_ERASE   );   // Erase command
   wire mtFUN_WRTAPMK  = mtGO & (`mtCS1_FUN(mtDATAI) == `mtCS1_FUN_WRTAPMK );   // Write tape mark
   wire mtFUN_SPCFWD   = mtGO & (`mtCS1_FUN(mtDATAI) == `mtCS1_FUN_SPCFWD  );   // Space forward command
   wire mtFUN_SPCREV   = mtGO & (`mtCS1_FUN(mtDATAI) == `mtCS1_FUN_SPCREV  );   // Space reverse command
   wire mtFUN_WRCHKFWD = mtGO & (`mtCS1_FUN(mtDATAI) == `mtCS1_FUN_WRCHKFWD);   // Write check forward command
   wire mtFUN_WRCHKREV = mtGO & (`mtCS1_FUN(mtDATAI) == `mtCS1_FUN_WRCHKREV);   // Write check reverse command
   wire mtFUN_WRFWD    = mtGO & (`mtCS1_FUN(mtDATAI) == `mtCS1_FUN_WRFWD   );   // Write forward
   wire mtFUN_RDFWD    = mtGO & (`mtCS1_FUN(mtDATAI) == `mtCS1_FUN_RDFWD   );   // Read forward
   wire mtFUN_RDREV    = mtGO & (`mtCS1_FUN(mtDATAI) == `mtCS1_FUN_RDREV   );   // Read reverse

   //
   // Illegal Function
   //
   // Commands are ignored if they have incorrect parity.
   //
   // Trace
   //

   wire mtSETILF = ((mtGO & (`mtCS1_FUN(mtDATAI) == 5'o02)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o05)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o06)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o07)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o11)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o16)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o17)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o20)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o21)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o22)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o23)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o25)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o26)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o31)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o32)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o33)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o35)) |
                    (mtGO & (`mtCS1_FUN(mtDATAI) == 5'o36)));

   //
   // MT Signals
   //

   wire          mtDRY   = 1;                           // FIXME;
   wire          mtINCFC = 0;                           // FIXME:
   wire          mtSETUNS = 0;                          //
   wire          mtSETOPI = 0;                          //
   wire          mtSETDTE = 0;                          //
   wire          mtSETNEF = 0;                          //
   wire          mtSETFCE = 0;                          //
   wire          mtSETDPAR = 0;                         //
   wire          mtSETFMTE = 0;                         //
   wire          mtSETRMR = 0;                          //
   wire          mtDRVCLR = 0;                          //
   wire          mtCLRFCS = 0;                          //

   //
   // MT Control/Status Register (MTCS1)
   //

   MTCS1 CS1 (
      .clk         (massbus.clk),
      .rst         (massbus.rst),
      .mtDATAI     (mtDATAI),
      .mtWRCS1     (mtWRCS1),
      .mtDRY       (mtDRY),
      .mtCS1       (mtCS1)
   );

   //
   // MT Frame Count Register (MTFC)
   //

   MTFC FC (
      .clk         (massbus.clk),
      .rst         (massbus.rst),
      .mtDATAI     (mtDATAI),
      .mtWRFC      (mtWRFC),
      .mtINCFC     (mtINCFC),
      .mtFC        (mtFC)
   );

   //
   // MT Drive Status Register (MTDS)
   //

   MTDS DS (
      .clk         (massbus.clk),
      .rst         (massbus.rst),
      .mtINIT      (mtINIT),
      .mtCLRATA    (mtCLRATA),
      .mtGO        (mtGO),
      .mtMOL       (mtMOL[mtUNIT]),
      .mtWRL       (mtWRL[mtUNIT]),
      .mtDPR       (mtDPR[mtUNIT]),
      .mtDRVCLR    (mtDRVCLR),
      .mtER        (mtER),
      .mtDS        (mtDS)
   );

   //
   // MT Error Register
   //

   MTER ER (
      .clk         (massbus.clk),
      .rst         (massbus.rst),
      .mtINIT      (mtINIT),
      .mtSETUNS    (mtSETUNS),
      .mtSETOPI    (mtSETOPI),
      .mtSETDTE    (mtSETDTE),
      .mtSETNEF    (mtSETNEF),
      .mtSETFCE    (mtSETFCE),
      .mtSETDPAR   (mtSETDPAR),
      .mtSETFMTE   (mtSETFMTE),
      .mtSETPAR    (mtSETPAR),
      .mtSETRMR    (mtSETRMR),
      .mtSETILR    (mtSETILR),
      .mtSETILF    (mtSETILF),
      .mtER        (mtER)
   );

   //
   // MT Tape Control Register (MTTC)
   //

   MTTC TC (
      .clk         (massbus.clk),
      .rst         (massbus.rst),
      .mtINIT      (mtINIT),
      .mtDATAI     (mtDATAI),
      .mtWRTC      (mtWRTC),
      .mtSETFCS    (mtWRFC),
      .mtCLRFCS    (mtCLRFCS),
      .mtTC        (mtTC)
   );

   //
   // MT Maintenance Register (MTMR)
   //

   MTMR MR (
      .clk         (massbus.clk),
      .rst         (massbus.rst),
      .mtDATAI     (mtDATAI),
      .mtmrWRITE   (mtWRMR),
      .mtMR        (mtMR)
   );

   //
   // FIXME:
   //

   assign massbus.mbINCWC = 0;
   assign massbus.mbINCBA = 0;
   assign massbus.mbWCE   = 0;
   assign massbus.mbNPRO  = 0;
   assign massbus.mbREQO  = 0;
   assign massbus.mbDATAO = 0;

   //
   // RH11 Parity Test of receive data
   //  Invert parity when Maintenance mode and Even Parity OP
   //

   assign massbus.mbINVPAR = `mtMR_MM(mtMR) & (`mtMR_MOP(mtMR) == `mtMROP_EVPAR);

   //
   // REG06 (mtFC)
   //

   assign massbus.mbREG06[0] = mtFC;
   assign massbus.mbREG06[1] = mtFC;
   assign massbus.mbREG06[2] = mtFC;
   assign massbus.mbREG06[3] = mtFC;
   assign massbus.mbREG06[4] = mtFC;
   assign massbus.mbREG06[5] = mtFC;
   assign massbus.mbREG06[6] = mtFC;
   assign massbus.mbREG06[7] = mtFC;

   //
   // REG10 (mtCS2)
   //

// assign massbus.mbREG10 = 0;

   //
   // REG12 (mtDS)
   //

   assign massbus.mbREG12[0] = mtDS;
// assign massbus.mbREG12[0] = (mtSLAVE == slvADDR) ? mtDS : 0;
   assign massbus.mbREG12[1] = 0;
   assign massbus.mbREG12[2] = 0;
   assign massbus.mbREG12[3] = 0;
   assign massbus.mbREG12[4] = 0;
   assign massbus.mbREG12[5] = 0;
   assign massbus.mbREG12[6] = 0;
   assign massbus.mbREG12[7] = 0;

   //
   // REG14 (mtER)
   //

   assign massbus.mbREG14[0] = mtER;
   assign massbus.mbREG14[1] = 0;
   assign massbus.mbREG14[2] = 0;
   assign massbus.mbREG14[3] = 0;
   assign massbus.mbREG14[4] = 0;
   assign massbus.mbREG14[5] = 0;
   assign massbus.mbREG14[6] = 0;
   assign massbus.mbREG14[7] = 0;

   //
   // REG20 (MTCC)
   //

   assign massbus.mbREG20[0] = 0;
   assign massbus.mbREG20[1] = 0;
   assign massbus.mbREG20[2] = 0;
   assign massbus.mbREG20[3] = 0;
   assign massbus.mbREG20[4] = 0;
   assign massbus.mbREG20[5] = 0;
   assign massbus.mbREG20[6] = 0;
   assign massbus.mbREG20[7] = 0;

   //
   // REG22 (rhDB)
   //

   //assign massbus.mbREG22[0] = 0;
   //assign massbus.mbREG22[1] = 0;
   //assign massbus.mbREG22[2] = 0;
   //assign massbus.mbREG22[3] = 0;
   //assign massbus.mbREG22[4] = 0;
   //assign massbus.mbREG22[5] = 0;
   //assign massbus.mbREG22[6] = 0;
   //assign massbus.mbREG22[7] = 0;

   //
   // REG24 (mtMR)
   //

   assign massbus.mbREG24[0] = mtMR;
   assign massbus.mbREG24[1] = mtMR;
   assign massbus.mbREG24[2] = mtMR;
   assign massbus.mbREG24[3] = mtMR;
   assign massbus.mbREG24[4] = mtMR;
   assign massbus.mbREG24[5] = mtMR;
   assign massbus.mbREG24[6] = mtMR;
   assign massbus.mbREG24[7] = mtMR;

   //
   // REG26 (mtDT)
   //

   assign massbus.mbREG26[0] = drvTYPE;
   assign massbus.mbREG26[1] = 0;
   assign massbus.mbREG26[2] = 0;
   assign massbus.mbREG26[3] = 0;
   assign massbus.mbREG26[4] = 0;
   assign massbus.mbREG26[5] = 0;
   assign massbus.mbREG26[6] = 0;
   assign massbus.mbREG26[7] = 0;

   //
   // REG30 (mtSN)
   //

   assign massbus.mbREG30[0] = drvSN;
   assign massbus.mbREG30[1] = 0;
   assign massbus.mbREG30[2] = 0;
   assign massbus.mbREG30[3] = 0;
   assign massbus.mbREG30[4] = 0;
   assign massbus.mbREG30[5] = 0;
   assign massbus.mbREG30[6] = 0;
   assign massbus.mbREG30[7] = 0;

   //
   // REG32 (mtTC)
   //

   assign massbus.mbREG32[0] = mtTC;
   assign massbus.mbREG32[1] = 0;
   assign massbus.mbREG32[2] = 0;
   assign massbus.mbREG32[3] = 0;
   assign massbus.mbREG32[4] = 0;
   assign massbus.mbREG32[5] = 0;
   assign massbus.mbREG32[6] = 0;
   assign massbus.mbREG32[7] = 0;

   //
   // REG34 (unused)
   //

   assign massbus.mbREG34[0] = 0;
   assign massbus.mbREG34[1] = 0;
   assign massbus.mbREG34[2] = 0;
   assign massbus.mbREG34[3] = 0;
   assign massbus.mbREG34[4] = 0;
   assign massbus.mbREG34[5] = 0;
   assign massbus.mbREG34[6] = 0;
   assign massbus.mbREG34[7] = 0;

   //
   // REG36 (unused)
   //

   assign massbus.mbREG36[0] = 0;
   assign massbus.mbREG36[1] = 0;
   assign massbus.mbREG36[2] = 0;
   assign massbus.mbREG36[3] = 0;
   assign massbus.mbREG36[4] = 0;
   assign massbus.mbREG36[5] = 0;
   assign massbus.mbREG36[6] = 0;
   assign massbus.mbREG36[7] = 0;

   //
   // REG40 (unused)
   //

   assign massbus.mbREG40[0] = 0;
   assign massbus.mbREG40[1] = 0;
   assign massbus.mbREG40[2] = 0;
   assign massbus.mbREG40[3] = 0;
   assign massbus.mbREG40[4] = 0;
   assign massbus.mbREG40[5] = 0;
   assign massbus.mbREG40[6] = 0;
   assign massbus.mbREG40[7] = 0;

   //
   // REG42 (unused)
   //

   assign massbus.mbREG42[0] = 0;
   assign massbus.mbREG42[1] = 0;
   assign massbus.mbREG42[2] = 0;
   assign massbus.mbREG42[3] = 0;
   assign massbus.mbREG42[4] = 0;
   assign massbus.mbREG42[5] = 0;
   assign massbus.mbREG42[6] = 0;
   assign massbus.mbREG42[7] = 0;

   //
   // REG44 (unused)
   //

   assign massbus.mbREG44[0] = 0;
   assign massbus.mbREG44[1] = 0;
   assign massbus.mbREG44[2] = 0;
   assign massbus.mbREG44[3] = 0;
   assign massbus.mbREG44[4] = 0;
   assign massbus.mbREG44[5] = 0;
   assign massbus.mbREG44[6] = 0;
   assign massbus.mbREG44[7] = 0;

   //
   // REG46 (unused)
   //

   assign massbus.mbREG46[0] = 0;
   assign massbus.mbREG46[1] = 0;
   assign massbus.mbREG46[2] = 0;
   assign massbus.mbREG46[3] = 0;
   assign massbus.mbREG46[4] = 0;
   assign massbus.mbREG46[5] = 0;
   assign massbus.mbREG46[6] = 0;
   assign massbus.mbREG46[7] = 0;

   //
   // ACLO
   //

   assign massbus.mbACLO = 0;

   //
   // Attention
   //

   assign massbus.mbATA[0] = `mtDS_ATA(massbus.mbREG12[0]);
   assign massbus.mbATA[1] = `mtDS_ATA(massbus.mbREG12[1]);
   assign massbus.mbATA[2] = `mtDS_ATA(massbus.mbREG12[2]);
   assign massbus.mbATA[3] = `mtDS_ATA(massbus.mbREG12[3]);
   assign massbus.mbATA[4] = `mtDS_ATA(massbus.mbREG12[4]);
   assign massbus.mbATA[5] = `mtDS_ATA(massbus.mbREG12[5]);
   assign massbus.mbATA[6] = `mtDS_ATA(massbus.mbREG12[6]);
   assign massbus.mbATA[7] = `mtDS_ATA(massbus.mbREG12[7]);

   //
   // Drive Available
   //

   assign massbus.mbDVA[0] = 1;
   assign massbus.mbDVA[1] = 1;
   assign massbus.mbDVA[2] = 1;
   assign massbus.mbDVA[3] = 1;
   assign massbus.mbDVA[4] = 1;
   assign massbus.mbDVA[5] = 1;
   assign massbus.mbDVA[6] = 1;
   assign massbus.mbDVA[7] = 0;


endmodule
