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
// Copyright (C) 2021-2022 Rob Doyle
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
`include "mter.vh"
`include "mtmr.vh"
`include "mttc.vh"
`include "mtcs1.vh"

module MT (
      massbus.slave  massbus,                           // Massbus interface
      mtcslbus.mt    mtCSLDATA                          // CSL interface
   );

   //
   // MT Parameters
   //

   parameter [15: 0] mtDRVTYP = (`mtDT_TM03|`mtDT_TU77);// Drive type (TM03/TU77)
   parameter [15: 0] mtDRVSN  = `mtSN_SN0;              // Drive serial number
   parameter [ 2: 0] mtTCUNUM = 0;                      // Only TCU 0 implemented
   parameter [ 3: 0] mtSLVADR = `mtSLV_SLV0;            // Slave Addresse

   //
   // Massbus Addressing
   //

   localparam [18:35] mtREGCS1 = 5'o00,                 // Control/Status Register
                      mtREGDS  = 5'o01,                 // Drive Status Register
                      mtREGER  = 5'o02,                 // Error Register
                      mtREGMR  = 5'o03,                 // Maintenance Register
                      mtREGAS  = 5'o04,                 // Attention Summary Register
                      mtREGFC  = 5'o05,                 // Frame Count Register
                      mtREGDT  = 5'o06,                 // Drive Type Register
                      mtREGCC  = 5'o07,                 // Check Character Register
                      mtREGSN  = 5'o10,                 // Serial Number Register
                      mtREGTC  = 5'o11;                 // Tape Control Register

   //
   // Clock and reset from massbus
   //

   wire          clk      = massbus.clk;                // Clock
   wire          rst      = massbus.rst;                // Reset
   wire          mtINIT   = massbus.mbINIT;             // Initialize
   wire  [ 2: 0] mtUNIT   = massbus.mbUNIT;             // Unit select
   wire          mtPAT    = massbus.mbPAT;              // Parity Test
   wire          mtREAD   = massbus.mbREAD;             // Read
   wire          mtWRITE  = massbus.mbWRITE;            // Write
   wire  [ 4: 0] mtREGSEL = massbus.mbREGSEL;           // Register select
   wire  [ 5: 1] mtFUN    = massbus.mbFUN;              // Function
   wire  [35: 0] mtDATAI  = massbus.mbDATAI[0:35];      // Bus data

   //
   // Registers
   //

   logic [15: 0] mtFC;                                  // Frame Count Register
   logic [15: 0] mtDS;                                  // Drive Status Register
   logic [15: 0] mtER;                                  // Error Register
   logic [15: 0] mtMR;                                  // Maintenance Register
   logic [15: 0] mtTC;                                  // Tape Control Register
   wire  [15: 0] mtCC = 0;                              // Character Check

   //
   // MTTC Decode
   //

   wire  [ 2: 0] mtDEN         = `mtTC_DEN(mtTC);       // Density
   wire  [ 3: 0] mtFMT         = `mtTC_FMT(mtTC);       // Format
   wire  [ 2: 0] mtSS          = `mtTC_SS(mtTC);        // Slave Select
// wire          mtEVPAR       = `mtTC_EVPAR(mtTC);     // Even parity

   //
   // Unit select
   //

   wire          mtSEL    = (mtUNIT == mtTCUNUM);       // Unit select

   //
   // GO function
   //
   // GO is ignored if the parity is incorrect
   //

   wire          mtGO     = massbus.mbGO & mtSEL & !mtPAT;

   //
   // Write Decoder
   //
   // Only the MTMR and the MTAS registers can be written during an operation.
   //

   logic         mtDRY;

   wire          mtWRCS1  =   mtWRITE & mtSEL & (mtREGSEL == mtREGCS1) &  mtDRY;
   wire          mtWRFC   =   mtWRITE & mtSEL & (mtREGSEL == mtREGFC ) &  mtDRY;
   wire          mtWRAS   =   mtWRITE & mtSEL & (mtREGSEL == mtREGAS );
   wire          mtWRMR   =   mtWRITE & mtSEL & (mtREGSEL == mtREGMR );
   wire          mtWRTC   =   mtWRITE & mtSEL & (mtREGSEL == mtREGTC ) &  mtDRY;
   wire          mtSETRMR = ((mtWRITE & mtSEL & (mtREGSEL == mtREGCS1) & !mtDRY) |
                             (mtWRITE & mtSEL & (mtREGSEL == mtREGFC ) & !mtDRY) |
                             (mtWRITE & mtSEL & (mtREGSEL == mtREGTC ) & !mtDRY));

`ifndef SYNTHESIS

   //
   // Read decode for the simulator
   //

   wire          mtRDCS1  = mtREAD & mtSEL & (mtREGSEL == mtREGCS1);
   wire          mtRDDS   = mtREAD & mtSEL & (mtREGSEL == mtREGDS );
   wire          mtRDER   = mtREAD & mtSEL & (mtREGSEL == mtREGER );
   wire          mtRDMR   = mtREAD & mtSEL & (mtREGSEL == mtREGMR );
   wire          mtRDAS   = mtREAD & mtSEL & (mtREGSEL == mtREGAS );
   wire          mtRDFC   = mtREAD & mtSEL & (mtREGSEL == mtREGFC );
   wire          mtRDDT   = mtREAD & mtSEL & (mtREGSEL == mtREGDT );
   wire          mtRDCC   = mtREAD & mtSEL & (mtREGSEL == mtREGCC );
   wire          mtRDSN   = mtREAD & mtSEL & (mtREGSEL == mtREGSN );
   wire          mtRDTC   = mtREAD & mtSEL & (mtREGSEL == mtREGTC );

`endif

   //
   // MTDS Signals
   //

   logic         mtATA;                                 // MTDS[ATA]
   logic         mtPIP;                                 // MTDS[PIP]
   logic         mtEOT;                                 // MTDS[EOT]
   logic         mtSSC;                                 // MTDS[SSC]
   logic         mtPES;                                 // MTDS[PES]
   logic         mtSDWN;                                // MTDS[SDWN]
   logic         mtIDB;                                 // MTDS[IDB]
   logic         mtTM;                                  // MTDS[TM]
   logic         mtBOT;                                 // MTDS[BOT]
   logic         mtSLA;                                 // MTDS[SLA]
   wire          mtMOL = mtSEL & mtCSLDATA.mtMOL[mtSS]; // MTDS[MOL]
   wire          mtWRL = mtSEL & mtCSLDATA.mtWRL[mtSS]; // MTDS[WRL]
   wire          mtDPR = mtCSLDATA.mtDPR[mtUNIT];       // MTDS[DPR]
   wire          mtERR = `mtDS_ERR(mtDS);               // MTDS[ERR]

   //
   // MTTC Signals
   //

   logic         mtACCL;                                // MTTC[ACCL]
   logic         mtFCS;                                 // MTTC[FCS]
   logic         mtINCFC;                               // Increment MTFC

   //
   // MTER Signals
   //

   logic [ 8: 0] mtMDF;                                 // MTER[MDF]
   wire          mtNEF  = `mtER_NEF(mtER);              // MTER[NEF]
   wire          mtFMTE = `mtER_FMTE(mtER);             // MTER[FMTE]


   //
   // Control Bus Parity Error
   //  This is tested by DSTUA TST113
   //

   wire          mtSETCPAR = ((mtPAT & mtWRCS1) |
                              (mtPAT & mtWRFC ) |
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

   wire mtCLRATA = ((mtWRAS & `mtAS_ATA7(mtDATAI) & (mtTCUNUM == 7)) |
                    (mtWRAS & `mtAS_ATA6(mtDATAI) & (mtTCUNUM == 6)) |
                    (mtWRAS & `mtAS_ATA5(mtDATAI) & (mtTCUNUM == 5)) |
                    (mtWRAS & `mtAS_ATA4(mtDATAI) & (mtTCUNUM == 4)) |
                    (mtWRAS & `mtAS_ATA3(mtDATAI) & (mtTCUNUM == 3)) |
                    (mtWRAS & `mtAS_ATA2(mtDATAI) & (mtTCUNUM == 2)) |
                    (mtWRAS & `mtAS_ATA1(mtDATAI) & (mtTCUNUM == 1)) |
                    (mtWRAS & `mtAS_ATA0(mtDATAI) & (mtTCUNUM == 0)) |
                    (mtGO   & !mtERR));

   //
   // Illegal Register
   //

   wire mtSETILR = ((mtREAD  & (mtREGSEL > mtREGTC)) |
                    (mtWRITE & (mtREGSEL > mtREGTC)));

   //
   // Function Decoder
   //

// wire mtFUN_UNLOAD   = mtGO & (mtFUN == `mtCS1_FUN_UNLOAD  );   // Unload command
// wire mtFUN_REWIND   = mtGO & (mtFUN == `mtCS1_FUN_REWIND  );   // Rewind command
   wire mtFUN_DRVCLR   = mtGO & (mtFUN == `mtCS1_FUN_DRVCLR  );   // Drive clear command
   wire mtFUN_PRESET   = mtGO & (mtFUN == `mtCS1_FUN_PRESET  );   // Read-in preset command
   wire mtFUN_ERASE    = mtGO & (mtFUN == `mtCS1_FUN_ERASE   );   // Erase command
   wire mtFUN_WRTM     = mtGO & (mtFUN == `mtCS1_FUN_WRTM    );   // Write tape mark
   wire mtFUN_SPCFWD   = mtGO & (mtFUN == `mtCS1_FUN_SPCFWD  );   // Space forward command
   wire mtFUN_SPCREV   = mtGO & (mtFUN == `mtCS1_FUN_SPCREV  );   // Space reverse command
   wire mtFUN_WRCHKFWD = mtGO & (mtFUN == `mtCS1_FUN_WRCHKFWD);   // Write check forward command
   wire mtFUN_WRCHKREV = mtGO & (mtFUN == `mtCS1_FUN_WRCHKREV);   // Write check reverse command
   wire mtFUN_WRFWD    = mtGO & (mtFUN == `mtCS1_FUN_WRFWD   );   // Write forward
   wire mtFUN_RDFWD    = mtGO & (mtFUN == `mtCS1_FUN_RDFWD   );   // Read forward
   wire mtFUN_RDREV    = mtGO & (mtFUN == `mtCS1_FUN_RDREV   );   // Read reverse

   //
   // Illegal Function
   //

   wire mtSETILF = ((mtGO & (mtFUN == 5'o02)) |
                    (mtGO & (mtFUN == 5'o05)) |
                    (mtGO & (mtFUN == 5'o06)) |
                    (mtGO & (mtFUN == 5'o07)) |
                    (mtGO & (mtFUN == 5'o11)) |
                    (mtGO & (mtFUN == 5'o16)) |
                    (mtGO & (mtFUN == 5'o17)) |
                    (mtGO & (mtFUN == 5'o20)) |
                    (mtGO & (mtFUN == 5'o21)) |
                    (mtGO & (mtFUN == 5'o22)) |
                    (mtGO & (mtFUN == 5'o23)) |
                    (mtGO & (mtFUN == 5'o25)) |
                    (mtGO & (mtFUN == 5'o26)) |
                    (mtGO & (mtFUN == 5'o31)) |
                    (mtGO & (mtFUN == 5'o32)) |
                    (mtGO & (mtFUN == 5'o33)) |
                    (mtGO & (mtFUN == 5'o35)) |
                    (mtGO & (mtFUN == 5'o36)));

   //
   // Frame Counter Clear
   //
   //  The Frame Counter is set to zero at the start of a read or write-check
   //  operation. When the operation completes, the frame counter has the
   //  number of frame read from the tape.
   //

   wire mtCLRFC = (mtFUN_WRCHKFWD | mtFUN_WRCHKREV | mtFUN_RDFWD | mtFUN_RDREV);

   //
   // Unsafe (MTER[UNS])
   //
   // UNS is asserted when MOL is negated and any function except Drive Clear
   // is executed.
   //
   // GO is delayed by a clock cycle so the the preset command works properly.
   // The preset command clears the slave select which may modify MOL.
   // Without the delay, a preset command may create a spurious UNS indication.
   //

   reg mtGO_DLY;
   always_ff @(posedge clk)
     begin
        if (rst)
          mtGO_DLY <= 0;
        else
          mtGO_DLY <= mtGO;
     end

   wire mtSETUNS = mtGO_DLY & !mtMOL & (mtFUN != `mtCS1_FUN_DRVCLR);

   //
   // Non-executable function
   //
   // NEF is asserted when:
   //  1. Write forward to a write protected drive
   //  2. Erase to a write protected drive
   //  3. Write tape mark to a write protected drive
   //  4. Space reverse at BOT
   //  5. Read  reverse at BOT
   //  6. Space forward when frame count is zero
   //  7. Space reverse when frame count is zero
   //  8. Write forward operation when frame count is zero
   //  9. Read  forward operation in NRZI mode when frame count is less that 13
   // 10. Read  reverse operation in NRZI mode when frame count is less that 13
   // 11. Write forward operation in NRZI mode when frame count is less that 13
   //
   // Note:
   //  The MTFC register stores the twos-complement of the Frame Count.  The
   //  constant "0177763" is -13.
   //

   wire mtSETNEF = ((mtFUN_WRFWD    &  mtWRL) |
                    (mtFUN_ERASE    &  mtWRL) |
                    (mtFUN_WRTM     &  mtWRL) |
                    (mtFUN_SPCREV   &  mtBOT) |
                    (mtFUN_RDREV    &  mtBOT) |
                    (mtFUN_WRCHKREV &  mtBOT) |
                    (mtFUN_SPCFWD   & !mtFCS) |
                    (mtFUN_SPCREV   & !mtFCS) |
                    (mtFUN_WRFWD    & !mtFCS) |
                    (mtFUN_WRFWD    & !(mtDEN == `mtTC_DEN_1600) &  mtPES & !mtBOT) |
                    (mtFUN_WRFWD    &  (mtDEN == `mtTC_DEN_1600) & !mtPES & !mtBOT) |
                    (mtFUN_RDFWD    & !(mtDEN == `mtTC_DEN_1600) & (mtFC > 16'o177763)) |
                    (mtFUN_RDREV    & !(mtDEN == `mtTC_DEN_1600) & (mtFC > 16'o177763)) |
                    (mtFUN_WRCHKFWD & !(mtDEN == `mtTC_DEN_1600) & (mtFC > 16'o177763)) |
                    (mtFUN_WRCHKREV & !(mtDEN == `mtTC_DEN_1600) & (mtFC > 16'o177763)) |
                    (mtFUN_WRFWD    & !(mtDEN == `mtTC_DEN_1600) & (mtFC > 16'o177763)));

   //
   // Format Error
   //
   // Set on a transfer function with an illegal format.
   //

   wire mtXFRFUN = mtFUN_WRFWD | mtFUN_RDFWD | mtFUN_RDREV | mtFUN_WRCHKFWD | mtFUN_WRCHKREV;

   wire mtFMTERR = ((mtXFRFUN & (mtFMT == 4'o01)) |
                    (mtXFRFUN & (mtFMT == 4'o02)) |
                    (mtXFRFUN & (mtFMT == 4'o04)) |
                    (mtXFRFUN & (mtFMT == 4'o05)) |
                    (mtXFRFUN & (mtFMT == 4'o06)) |
                    (mtXFRFUN & (mtFMT == 4'o07)) |
                    (mtXFRFUN & (mtFMT == 4'o10)) |
                    (mtXFRFUN & (mtFMT == 4'o11)) |
                    (mtXFRFUN & (mtFMT == 4'o12)) |
                    (mtXFRFUN & (mtFMT == 4'o13)) |
                    (mtXFRFUN & (mtFMT == 4'o15)) |
                    (mtXFRFUN & (mtFMT == 4'o17)));

   wire mtSETFMTE = mtGO & mtFMTERR;

   //
   // FIXMEs
   //

   wire mtSETOPI  = 0;                  // Operation Incomplete  (MTER[OPI]) : FIXME: Not implemented
   wire mtSETDTE  = 0;                  // Drive Timing Error    (MTER[DTE]) : FIXME: Not implemented
   wire mtSETFCE  = 0;                  // Frame Count Error     (MTER[FCE]) : FIXME: Not implemented
   wire mtSETDPAR = 0;                  // Data Bus Parity Error (MTER[DPAR]): Not testable with RH11.  See DSTUA TST67.

   //
   // MT Frame Count Register (MTFC)
   //

   MTFC FC (
      .clk         (clk),
      .rst         (rst),
      .mtINIT      (mtINIT | mtFUN_DRVCLR),
      .mtCLRFC     (mtCLRFC),
      .mtDATAI     (mtDATAI),
      .mtWRFC      (mtWRFC),
      .mtINCFC     (mtINCFC),
      .mtFCS       (mtFCS),
      .mtFC        (mtFC)
   );

   //
   // MT Drive Status Register (MTDS)
   //

   MTDS DS (
      .clk         (clk),
      .rst         (rst),
      .mtINIT      (mtINIT | mtFUN_DRVCLR),
      .mtCLRATA    (mtCLRATA),
      .mtATA       (mtATA),
      .mtPIP       (mtPIP),
      .mtMOL       (mtMOL),
      .mtWRL       (mtWRL),
      .mtEOT       (mtEOT),
      .mtDPR       (mtDPR),
      .mtDRY       (mtDRY),
      .mtSSC       (mtSSC),
      .mtPES       (mtPES),
      .mtIDB       (mtIDB),
      .mtSDWN      (mtSDWN),
      .mtTM        (mtTM),
      .mtBOT       (mtBOT),
      .mtSLA       (mtSLA),
      .mtER        (mtER),
      .mtDS        (mtDS)
   );

   //
   // MT Error Register
   //

   MTER ER (
      .clk         (clk),
      .rst         (rst),
      .mtINIT      (mtINIT | mtFUN_DRVCLR),
      .mtSETUNS    (mtSETUNS),
      .mtSETOPI    (mtSETOPI),
      .mtSETDTE    (mtSETDTE),
      .mtSETNEF    (mtSETNEF),
      .mtSETFCE    (mtSETFCE),
      .mtSETDPAR   (mtSETDPAR),
      .mtSETFMTE   (mtSETFMTE),
      .mtSETCPAR   (mtSETCPAR),
      .mtSETRMR    (mtSETRMR),
      .mtSETILR    (mtSETILR),
      .mtSETILF    (mtSETILF),
      .mtER        (mtER)
   );

   //
   // MT Tape Control Register (MTTC)
   //

   MTTC TC (
      .clk         (clk),
      .rst         (rst),
      .mtINIT      (mtINIT),
      .mtDATAI     (mtDATAI),
      .mtWRTC      (mtWRTC),
      .mtPRESET    (mtFUN_PRESET),
      .mtFCS       (mtFCS),
      .mtACCL      (mtACCL),
      .mtTC        (mtTC)
   );

   //
   // MT Maintenance Register (MTMR)
   //

   MTMR MR (
      .clk         (clk),
      .rst         (rst),
      .mtDATAI     (mtDATAI),
      .mtmrWRITE   (mtWRMR),
      .mtMDF       (mtMDF),
      .mtMR        (mtMR)
   );

   //
   // MT Control State Machine
   //

   MTCTRL CTRL (
      .clk         (clk),
      .rst         (rst),
      .mtINIT      (mtINIT),
      .mtDRVCLR    (mtFUN_DRVCLR),
      .mtCLRATA    (mtCLRATA),
      .mtREQO      (massbus.mbREQO),
      .mtACKI      (massbus.mbACKI),
      .mtDATAI     (massbus.mbDATAI),
      .mtDATAO     (massbus.mbDATAO),
      .mtNPRO      (massbus.mbNPRO),
      .mtINCWC     (massbus.mbINCWC),
      .mtINCBA     (massbus.mbINCBA),
      .mtDECBA     (massbus.mbDECBA),
      .mtWCE       (massbus.mbWCE),
      .mtWCZ       (massbus.mbWCZ),
      .mtWRLO      (mtCSLDATA.mtWRLO),
      .mtWRHI      (mtCSLDATA.mtWRHI),
      .mtWSTRB     (mtCSLDATA.mtWSTRB),
      .mtCSLDATAI  (mtCSLDATA.mtDATAI),
      .mtDIRO      (mtCSLDATA.mtDIRO),
      .mtDEBUG     (mtCSLDATA.mtDEBUG),
      .mtMOL       (mtCSLDATA.mtMOL),
      .mtFCZ       (mtFC == 16'b0),
      .mtFMTE      (mtFMTE),
      .mtNEF       (mtNEF),
      .mtWRL       (mtWRL),
      .mtDEN       (mtDEN),
      .mtFMT       (mtFMT),
      .mtFUN       (mtFUN),
      .mtGO        (mtGO),
      .mtSS        (mtSS),
      .mtPIP       (mtPIP),
      .mtACCL      (mtACCL),
      .mtATA       (mtATA),
      .mtDRY       (mtDRY),
      .mtBOT       (mtBOT),
      .mtEOT       (mtEOT),
      .mtTM        (mtTM),
      .mtSSC       (mtSSC),
      .mtSLA       (mtSLA),
      .mtIDB       (mtIDB),
      .mtPES       (mtPES),
      .mtMDF       (mtMDF),
      .mtSDWN      (mtSDWN),
      .mtINCFC     (mtINCFC)
   );

   //
   // Controller Parity Error
   //  Asserted when accessing a register with even parity
   //  Sets RHCS1[CPE]
   //

   assign massbus.mbCPE = `mtMR_MM(mtMR) & (`mtMR_MOP(mtMR) == `mtMROP_EVPAR);

   //
   // Data Parity Error
   //  Asserted when performing an NPR operation with even parity.
   //  Sets RHCS2[DPE]
   //

   assign massbus.mbDPE = `mtMR_MM(mtMR) & (`mtMR_MOP(mtMR) == `mtMROP_EVPAR) & massbus.mbREQO;

   //
   // Multiplex registers back to RH11
   //
   //  Negate MTDS[MOL] in deselected slaves
   //

   always_comb
     begin
        case (massbus.mbREGSEL)
          5'o01:   massbus.mbREGDAT = (mtSS == mtSLVADR) ? mtDS : mtDS & 16'o167777;
          5'o02:   massbus.mbREGDAT = mtER;
          5'o03:   massbus.mbREGDAT = mtMR;
          5'o05:   massbus.mbREGDAT = mtFC;
          5'o06:   massbus.mbREGDAT = (mtSS == mtSLVADR) ? mtDRVTYP : mtDRVTYP & 16'o175777;
          5'o07:   massbus.mbREGDAT = mtCC;
          5'o10:   massbus.mbREGDAT = (mtSS == mtSLVADR) ? mtDRVSN : 16'o000000;
          5'o11:   massbus.mbREGDAT = mtTC;
          default: massbus.mbREGDAT = 16'b0;
        endcase
     end

   //
   // Acknowledge valid register accesses
   //

   assign massbus.mbREGACK = ((mtUNIT == mtTCUNUM) & (massbus.mbREGSEL <= 5'o11));

   //
   // Attention Summary
   //

   assign massbus.mbATA[0] = `mtDS_ATA(mtDS);
   assign massbus.mbATA[1] = 0;
   assign massbus.mbATA[2] = 0;
   assign massbus.mbATA[3] = 0;
   assign massbus.mbATA[4] = 0;
   assign massbus.mbATA[5] = 0;
   assign massbus.mbATA[6] = 0;
   assign massbus.mbATA[7] = 0;

   //
   // Drive Present (MTDS[DPR])
   //

   assign massbus.mbDPR    = `mtDS_DPR(mtDS);

   //
   // Drive Ready (MTDS[DRY])
   //

   assign massbus.mbDRY    = `mtDS_DRY(mtDS);

   //
   // Drive Available (MTCS1[DVA])
   //

   assign massbus.mbDVA    = 1;

   //
   // ACLO
   //

   assign massbus.mbACLO   = 0;

endmodule
