////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   RPxx Style Massbus Disk Drive
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
//   rpxx.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2016 Rob Doyle
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

`include "rpxx.vh"
`include "rpas.vh"
`include "rpda.vh"
`include "rpcc.vh"
`include "rpdc.vh"
`include "rpds.vh"
`include "rpof.vh"
`include "rpmr.vh"
`include "rpcs1.vh"
`include "rper1.vh"
`include "../rh11.vh"
`include "../sd/sd.vh"
`include "../../uba/ubabus.vh"

module RPXX (
      input  wire         clk,                  // Clock
      input  wire         rst,                  // Reset
      input  wire         clr,                  // Clear
      input  wire         rhINCSECT,            // Increment Sector
      input  wire [ 0:35] devADDRI,             // Device Address In
      input  wire [ 0:35] devDATAI,             // Device Data In
      input  wire [ 2: 0] rhUNIT,               // Unit select
      input  wire [ 2: 0] rpNUM,                // Unit number
      input  wire         rpPAT,                // Parity Test
      input  wire         rpCD,                 // Card Detect from SD Card
      input  wire         rpWP,                 // Write Protect from SD Card
      input  wire         rpDPR,                // Drive Present
      output wire [15: 0] rpCS1,                // CS1 Register
      output wire [15: 0] rpDA,                 // DA  Register
      output wire [15: 0] rpDS,                 // DS  Register
      output wire [15: 0] rpER1,                // ER1 Register
      output wire [15: 0] rpLA,                 // LA  Register
      output wire [15: 0] rpMR,                 // MR  Register
      output wire [15: 0] rpDT,                 // DT  Register
      output wire [15: 0] rpOF,                 // OF  Register
      output wire [15: 0] rpDC,                 // DC  Register
      output wire [15: 0] rpCC,                 // CC  Register
      output wire [15: 0] rpER2,                // ER2 Register
      output wire [15: 0] rpER3,                // ER3 Register
      output wire [ 2: 0] rpSDOP,               // SD Operation
      output wire         rpSDREQ,              // SD Request
      input  wire         rpSDACK,              // SD Complete Acknowledge
      output wire [20: 0] rpSDLSA,              // SD Linear Sector Address
      output wire         rpACTIVE              // RP is active
   );

   //
   // RH Parameters
   //

   parameter [14:17] rhDEV    = `rh1DEV;        // Device 3
   parameter [18:35] rhADDR   = `rh1ADDR;       // RH11 #1 Base Address
   parameter [15: 0] drvTYPE  = `rpRP06;        // Drive type

   //
   // RH Register Addresses
   //

   localparam [18:35] cs1ADDR = rhADDR + `cs1OFFSET;
   localparam [18:35] wcADDR  = rhADDR + `wcOFFSET;
   localparam [18:35] baADDR  = rhADDR + `baOFFSET;
   localparam [18:35] daADDR  = rhADDR + `daOFFSET;

   localparam [18:35] cs2ADDR = rhADDR + `cs2OFFSET;
   localparam [18:35] dsADDR  = rhADDR + `dsOFFSET;
   localparam [18:35] er1ADDR = rhADDR + `er1OFFSET;
   localparam [18:35] asADDR  = rhADDR + `asOFFSET;

   localparam [18:35] laADDR  = rhADDR + `laOFFSET;
   localparam [18:35] dbADDR  = rhADDR + `dbOFFSET;
   localparam [18:35] mrADDR  = rhADDR + `mrOFFSET;
   localparam [18:35] dtADDR  = rhADDR + `dtOFFSET;

   localparam [18:35] snADDR  = rhADDR + `snOFFSET;
   localparam [18:35] ofADDR  = rhADDR + `ofOFFSET;
   localparam [18:35] dcADDR  = rhADDR + `dcOFFSET;
   localparam [18:35] ccADDR  = rhADDR + `ccOFFSET;

   localparam [18:35] er2ADDR = rhADDR + `er2OFFSET;
   localparam [18:35] er3ADDR = rhADDR + `er3OFFSET;
   localparam [18:35] ec1ADDR = rhADDR + `ec1OFFSET;
   localparam [18:35] ec2ADDR = rhADDR + `ec2OFFSET;

   localparam [18:35] undADDR = rhADDR + `undOFFSET;

   //
   // Lookup Drive Geometries
   //

   localparam [5:0] rpSECN16 = `getLAST_SECT16(drvTYPE);        // Sectors in 16-bit mode
   localparam [5:0] rpSECN18 = `getLAST_SECT18(drvTYPE);        // Sectors in 18-bit mode
   localparam [5:0] rpTRKNUM = `getLAST_TRACK(drvTYPE);         // Tracks (or surfaces or heads)
   localparam [9:0] rpCYLNUM = `getLAST_CYL (drvTYPE);          // Cylinder

   //
   // Device Address and Flags
   //

   wire         devREAD  = `devREAD(devADDRI);                  // Read Cycle
   wire         devWRITE = `devWRITE(devADDRI);                 // Write Cycle
   wire         devIO    = `devIO(devADDRI);                    // IO Cycle
   wire         devPHYS  = `devPHYS(devADDRI);                  // Physical reference
   wire [14:17] devDEV   = `devDEV(devADDRI);                   // Device Number
   wire [18:34] devADDR  = `devADDR(devADDRI);                  // Device Address

   //
   // Unit select
   //

   wire rpSELECT = (rhUNIT == rpNUM);

   //
   // Register Decode
   //
   // Trace
   //   M7774/RG5/E75
   //

   wire rpcs1WRITE = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR == cs1ADDR[18:34]) & rpSELECT;
   wire rper1WRITE = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR == er1ADDR[18:34]) & rpSELECT;
   wire rpasWRITE  = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR ==  asADDR[18:34]);
   wire rpmrWRITE  = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR ==  mrADDR[18:34]) & rpSELECT;
   wire rpofWRITE  = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR ==  ofADDR[18:34]) & rpSELECT;
   wire rpdaWRITE  = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR ==  daADDR[18:34]) & rpSELECT;
   wire rpdcWRITE  = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR ==  dcADDR[18:34]) & rpSELECT;
   wire rper2WRITE = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR == er2ADDR[18:34]) & rpSELECT;
   wire rper3WRITE = devWRITE & devIO & devPHYS & (devDEV == rhDEV) & (devADDR == er3ADDR[18:34]) & rpSELECT;

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] rpDATAI = devDATAI[0:35];

   //
   // Function Decoder
   //
   // Commands are ignored if they have incorrect parity.
   //
   // Trace
   //  M7774/RG4/E60
   //

   wire rpGO       = !rpPAT & rpcs1WRITE &                                        `rpCS1_GO(rpDATAI);   // Go command
   wire rpUNLOAD   = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funUNLOAD ) & `rpCS1_GO(rpDATAI);   // Unload command
   wire rpSEEK     = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funSEEK   ) & `rpCS1_GO(rpDATAI);   // Seek command
   wire rpRECAL    = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funRECAL  ) & `rpCS1_GO(rpDATAI);   // Recalibrate command
   wire rpDRVCLR   = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funCLEAR  ) & `rpCS1_GO(rpDATAI);   // Drive clear command
   wire rpRELEASE  = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funRELEASE) & `rpCS1_GO(rpDATAI);   // Release command
   wire rpOFFSET   = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funOFFSET ) & `rpCS1_GO(rpDATAI);   // Offset command
   wire rpCENTER   = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funCENTER ) & `rpCS1_GO(rpDATAI);   // Return to center command
   wire rpPRESET   = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funPRESET ) & `rpCS1_GO(rpDATAI);   // Read-in preset command
   wire rpPAKACK   = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funPAKACK ) & `rpCS1_GO(rpDATAI);   // Pack acknowledge command
   wire rpSEARCH   = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funSEARCH ) & `rpCS1_GO(rpDATAI);   // Search command
   wire rpWRCHK    = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funWRCHK  ) & `rpCS1_GO(rpDATAI);   // Write check command
   wire rpWRCHKH   = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funWRCHKH ) & `rpCS1_GO(rpDATAI);   // Write check header command
   wire rpWRITE    = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funWRITE  ) & `rpCS1_GO(rpDATAI);   // Write command
   wire rpWRITEH   = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funWRITEH ) & `rpCS1_GO(rpDATAI);   // Write header command
   wire rpREAD     = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funREAD   ) & `rpCS1_GO(rpDATAI);   // Read command
   wire rpREADH    = !rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funREADH  ) & `rpCS1_GO(rpDATAI);   // Read header command

   //
   // Illegal Function Decoder
   //
   // Commands are ignored if they have incorrect parity.
   //
   // Trace
   //  M7774/RG4/E54
   //  M7774/RG4/E65
   //  M7774/RG4/E78
   //

   wire rpSETILF   = ((!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o12) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o13) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o15) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o16) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o17) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o20) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o21) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o22) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o23) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o26) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o27) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o32) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o33) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o36) & `rpCS1_GO(rpDATAI)) |
                      (!rpPAT & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == 5'o37) & `rpCS1_GO(rpDATAI)));

   //
   // RPxx Control Status Register #1 (RPCS1)
   //

   wire [5:1] rpFUN = `rpCS1_FUN(rpCS1);

   //
   // RPxx Disk Status Register (RPDS)
   //

   wire rpERR = `rpDS_ERR(rpDS);

   //
   // RPxx Disk Address Register (RPDA)
   //

   wire [5:0] rpSA = `rpDA_SA(rpDA);
   wire [5:0] rpTA = `rpDA_TA(rpDA);

   //
   // RPxx Offset (RPOF) Register
   //

   wire rpFMT22 = `rpOF_FMT22(rpOF);
   wire rpECI   = `rpOF_ECI(rpOF);
   wire rpHCI   = `rpOF_HCI(rpOF);

   //
   // RPxx Desired Cylinder (RPDC) Register
   //

   wire [9:0] rpDCA = `rpDC_DCA(rpDC);

   //
   // RPxx Maintenance (RPMR) Register
   //

   wire rpSBD;                                  // Sync byte detected
   wire rpZD;                                   // Zero detect
   wire rpDWRD;                                 // Diagnostic write data
   wire rpDRDD = `rpMR_DRDD(rpMR);              // Diagnostic read data
   wire rpDSCK = `rpMR_DSCK(rpMR);              // Diagnostic sector clock
   wire rpDIND = `rpMR_DIND(rpMR);              // Diagnostic index pulse
   wire rpDCLK = `rpMR_DCLK(rpMR);              // Diagnostic clock
   wire rpDMD  = `rpMR_DMD(rpMR);               // Diagnostic mode

   //
   // Get number of sectors for this mode.
   //  rpFMT22 is asserted in 16-bit mode.
   //  rpFMT22 is negated in 18-bit mode.  (default)
   //

   wire [5:0] rpSECNUM = rpFMT22 ? rpSECN16 : rpSECN18;

   //
   // Misc bits
   //

   wire rpDRY;                                  // Drive ready
   wire rpPIP;                                  // Positioning in progress
   wire rpECE;                                  // ECC field envelope
   wire rpDFE;                                  // Data field envelope
   wire rpADRSTRT;                              // Start sector address calculation
   wire rpADRBUSY;                              // Busy calculation sector address
   wire rpSETATA;                               // Set attention
   wire rpSETOPI;                               // Set operation incomplete
   wire rpSETDCK;                               // Set data check error
   wire rpSETDTE;                               // Set drive timing error
   wire rpSETSKI;                               // Set seek incomplete
   wire rpSETHCRC;                              // Set header CRC error
   wire rpEBL;                                  // End of block

   //
   // Increment sector
   //
   // The sector is incremented by the SD Card normally but is incremented by the
   // EBL pulse in Diagnostic Mode.
   //

   wire rpINCSECT = rpDMD ? rpEBL : (rhINCSECT & rpSELECT);

   //
   // Increment cylinder
   //

   wire rpINCCYL  = rpINCSECT & (rpSA == rpSECNUM) & (rpTA == rpTRKNUM);

   //
   // Write lock error
   //
   // Trace
   //  M7773/SN1/E59
   //

   wire rpSETWLE  = ((!rpPAT & rpWP & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funWRITE ) & `rpCS1_GO(rpDATAI)) |
                     (!rpPAT & rpWP & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funWRITEH) & `rpCS1_GO(rpDATAI)));

   //
   // Invalid address error
   //
   // Asserted when an invalid disk address is selected and a disk operation is
   // executed.
   //
   // Trace
   //  M7786/SS4/E47
   //

   wire inv_addr  = (rpSA > rpSECNUM) | (rpTA > rpTRKNUM) | (rpDCA > rpCYLNUM);

   wire rpSETIAE  = ((!rpPAT & inv_addr & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funWRITE ) & `rpCS1_GO(rpDATAI)) |
                     (!rpPAT & inv_addr & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funWRITEH) & `rpCS1_GO(rpDATAI)) |
                     (!rpPAT & inv_addr & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funREAD  ) & `rpCS1_GO(rpDATAI)) |
                     (!rpPAT & inv_addr & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funREADH ) & `rpCS1_GO(rpDATAI)) |
                     (!rpPAT & inv_addr & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funWRCHK ) & `rpCS1_GO(rpDATAI)) |
                     (!rpPAT & inv_addr & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funWRCHKH) & `rpCS1_GO(rpDATAI)) |
                     (!rpPAT & inv_addr & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funSEEK  ) & `rpCS1_GO(rpDATAI)) |
                     (!rpPAT & inv_addr & rpcs1WRITE & (`rpCS1_FUN(rpDATAI) == `funSEARCH) & `rpCS1_GO(rpDATAI)));

   //
   // Address overflow error
   //
   // The address overflow error occurs during mid-transfer seeks.
   //
   // Trace
   //  M7786/SS4/E47
   //

   wire rpSETAOE  = (rpINCSECT & (rpSA == rpSECNUM) & (rpTA == rpTRKNUM) & (rpDCA == rpCYLNUM));

   //
   // Last sector transferred
   //
   // Trace
   //  M7786/SS4/E68
   //

   wire rpSETLST  = ((rpSA == rpSECNUM) & (rpTA == rpTRKNUM) & (rpDCA == rpCYLNUM));

   //
   // Register Modification Refused
   //
   // Only the RPMR and the RPAS registers can be written durning an operation.
   //
   // Trace
   //  M7774/RG6/E29
   //

   wire rpSETRMR  = ((!rpDRY & rpcs1WRITE) |
                     (!rpDRY & rper1WRITE) |
                     (!rpDRY & rpofWRITE ) |
                     (!rpDRY & rpdaWRITE ) |
                     (!rpDRY & rpdcWRITE ) |
                     (!rpDRY & rper2WRITE) |
                     (!rpDRY & rper3WRITE));

   //
   // Parity Error
   //
   // Asserted when a register is modified and there is incorrect parity.
   //

   wire rpSETPAR  =  ((rpPAT & rpcs1WRITE) |
                      (rpPAT & rper1WRITE) |
                      (rpPAT & rpmrWRITE)  |
                      (rpPAT & rpofWRITE)  |
                      (rpPAT & rpdaWRITE)  |
                      (rpPAT & rpdcWRITE)  |
                      (rpPAT & rper2WRITE) |
                      (rpPAT & rper3WRITE));

   //
   // Class B errors
   //
   // Note: The header errors are only asserted when performing an operation
   //  that reads the sector header.
   //
   // Trace
   //  M7774/RG0/E4
   //  M7774/RG0/E29
   //  M7774/RG0/E33
   //  M7774/RG0/E46
   //  M7774/RG0/E47
   //  M7776/EC6/E52
   //  M7776/EC7/E80
   //  M7776/EC7/E85
   //  M7776/EC7/E49
   //  M7776/EC7/E59
   //  M7776/EC7/E85
   //  M7776/EC7/E93
   //

   wire rpCLBERR = ((`rpER1_DCK(rpER1)) |
                    (`rpER1_OPI(rpER1)) |
//FIXME             (`rpER1_DTE(rpER1)) |
                    (`rpER1_WLE(rpER1)) |
                    (`rpER1_IAE(rpER1)) |
                    (`rpER1_AOE(rpER1)) |
                    (`rpER1_HCRC(rpER1) & ((rpFUN == `funREADH ) | (rpFUN == `funWRCHKH))) |
                    (`rpER1_HCE(rpER1)  & ((rpFUN == `funREADH ) | (rpFUN == `funWRCHKH))) |
                    (`rpER1_ECH(rpER1)) |
                    (`rpER1_WCF(rpER1)) |
                    (`rpER1_FER(rpER1)  & ((rpFUN == `funREADH ) | (rpFUN == `funWRCHKH))) |
                    (`rpER1_ILF(rpER1)) |
                    (rpER2 != 0) |
                    (rpER3 != 0));

   //
   // Clear attention
   //
   // Trace
   //  M7774/RG3/E41
   //  M7774/RG3/E44
   //  M7774/RG3/E49
   //  M7774/RG3/E54
   //  M7774/RG3/E68
   //  M7787/DP2/E14
   //  M7787/DP2/E57
   //

   wire rpCLRATA = ((rpasWRITE & `rpAS_ATA7(rpDATAI) & (rpNUM == 7)) |
                    (rpasWRITE & `rpAS_ATA6(rpDATAI) & (rpNUM == 6)) |
                    (rpasWRITE & `rpAS_ATA5(rpDATAI) & (rpNUM == 5)) |
                    (rpasWRITE & `rpAS_ATA4(rpDATAI) & (rpNUM == 4)) |
                    (rpasWRITE & `rpAS_ATA3(rpDATAI) & (rpNUM == 3)) |
                    (rpasWRITE & `rpAS_ATA2(rpDATAI) & (rpNUM == 2)) |
                    (rpasWRITE & `rpAS_ATA1(rpDATAI) & (rpNUM == 1)) |
                    (rpasWRITE & `rpAS_ATA0(rpDATAI) & (rpNUM == 0)) |
                    (rpGO & !rpERR));

   //
   // RPxx Control/Status Register (RPCS1)
   //

   RPCS1 CS1 (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpDATAI     (rpDATAI),
      .rpcs1WRITE  (rpcs1WRITE),
      .rpDRY       (rpDRY),
      .rpCS1       (rpCS1)
   );

   //
   // RPxx Disk Address Register (RPDA)
   //

   RPDA DA (
      .clk         (clk),
      .rst         (rst),
      .rpDATAI     (rpDATAI),
      .rpdaWRITE   (rpdaWRITE),
      .rpPRESET    (rpPRESET),
      .rpSECNUM    (rpSECNUM),
      .rpTRKNUM    (rpTRKNUM),
      .rpINCSECT   (rpINCSECT),
      .rpDRY       (rpDRY),
      .rpDA        (rpDA)
   );

   //
   // RPxx Disk Status Register (RPDS)
   //

   RPDS DS (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpCLRATA    (rpCLRATA),
      .rpSETLST    (rpSETLST),
      .rpSETATA    (rpSETATA),
      .rpGO        (rpGO),
      .rpCD        (rpCD),
      .rpWP        (rpWP),
      .rpDPR       (rpDPR),
      .rpPIP       (rpPIP),
      .rpDRY       (rpDRY),
      .rpDRVCLR    (rpDRVCLR),
      .rpPRESET    (rpPRESET),
      .rpPAKACK    (rpPAKACK),
      .rpdaWRITE   (rpdaWRITE),
      .rpER1       (rpER1),
      .rpER2       (rpER2),
      .rpER3       (rpER3),
      .rpDS        (rpDS)
   );

   //
   // RPxx Error #1 (RPER1) Register
   //

   RPER1 ER1 (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpDRVCLR    (rpDRVCLR),
      .rpSETDCK    (rpSETDCK),
      .rpSETOPI    (rpSETOPI),
      .rpSETDTE    (rpSETDTE),
      .rpSETWLE    (rpSETWLE),
      .rpSETIAE    (rpSETIAE),
      .rpSETAOE    (rpSETAOE),
      .rpSETPAR    (rpSETPAR),
      .rpSETRMR    (rpSETRMR),
      .rpSETILF    (rpSETILF),
      .rpSETHCRC   (rpSETHCRC),
      .rpDATAI     (rpDATAI),
      .rper1WRITE  (rper1WRITE),
      .rpHCI       (rpHCI),
      .rpDRY       (rpDRY),
      .rpER1       (rpER1)
   );

   //
   // RPxx Look Ahead (RPLA) Register
   //

   RPLA LA (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpDSCK      (rpDSCK),
      .rpDIND      (rpDIND),
      .rpDMD       (rpDMD),
      .rpSECNUM    (rpSECNUM),
      .rpSA        (rpSA),
      .rpLA        (rpLA)
   );

   //
   // RPxx Offset (RPOF) Register
   //

   RPOF OF (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpCENTER    (rpCENTER),
      .rpPRESET    (rpPRESET),
      .rpSEEK      (rpSEEK),
      .rpWRITE     (rpWRITE),
      .rpWRITEH    (rpWRITEH),
      .rpDATAI     (rpDATAI),
      .rpofWRITE   (rpofWRITE),
      .rpDRY       (rpDRY),
      .rpOF        (rpOF)
   );

   //
   // RPxx Desired Cylinder (RPDC) Register
   //

   RPDC DC (
      .clk         (clk),
      .rst         (rst),
      .rpDATAI     (rpDATAI),
      .rpPRESET    (rpPRESET),
      .rpRECAL     (rpRECAL),
      .rpdcWRITE   (rpdcWRITE),
      .rpINCCYL    (rpINCCYL),
      .rpDRY       (rpDRY),
      .rpDC        (rpDC)
   );

   //
   // RPxx Maintenaince (RPMR) Register
   //

   RPMR MR (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpDRVCLR    (rpDRVCLR),
      .rpDATAI     (rpDATAI),
      .rpmrWRITE   (rpmrWRITE),
      .rpDRY       (rpDRY),
      .rpSBD       (rpSBD),
      .rpZD        (rpZD),
      .rpDFE       (rpDFE),
      .rpECE       (rpECE),
      .rpDWRD      (rpDWRD),
      .rpMR        (rpMR)
   );

   //
   // RPxx Error Status #2 (RPER2) Register
   //

   RPER2 ER2 (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpDRVCLR    (rpDRVCLR),
      .rpDATAI     (rpDATAI),
      .rper2WRITE  (rper2WRITE),
      .rpDRY       (rpDRY),
      .rpER2       (rpER2)
   );

   //
   // RPxx Error Status #3 (RPER3) Register
   //

   RPER3 ER3 (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpDRVCLR    (rpDRVCLR),
      .rpSETSKI    (rpSETSKI),
      .rpDATAI     (rpDATAI),
      .rper3WRITE  (rper3WRITE),
      .rpDRY       (rpDRY),
      .rpER3       (rpER3)
   );

   //
   // Linear sector address calculation
   //

   RPADDR ADDR (
      .clk         (clk),
      .rst         (rst),
      .rpTRKNUM    (rpTRKNUM),
      .rpSECNUM    (rpSECNUM),
      .rpDCA       (rpDCA),
      .rpTA        (rpTA),
      .rpSA        (rpSA),
      .rpSDLSA     (rpSDLSA),
      .rpADRSTRT   (rpADRSTRT),
      .rpADRBUSY   (rpADRBUSY)
   );

   //
   // Controller state machine
   //

   RPCTRL CTRL (
      .clk         (clk),
      .rst         (rst),
      .clr         (clr),
      .rpGO        (rpGO),
      .rpFUN       (rpFUN),
      .rpCYLNUM    (rpCYLNUM),
      .rpCC        (rpCC),
      .rpDA        (rpDA),
      .rpDC        (rpDC),
      .rpLA        (rpLA),
      .rpDMD       (rpDMD),
      .rpDCLK      (rpDCLK),
      .rpDSCK      (rpDSCK),
      .rpDIND      (rpDIND),
      .rpDRDD      (rpDRDD),
      .rpDWRD      (rpDWRD),
      .rpDFE       (rpDFE),
      .rpSBD       (rpSBD),
      .rpZD        (rpZD),
      .rpDRY       (rpDRY),
      .rpEBL       (rpEBL),
      .rpECE       (rpECE),
      .rpECI       (rpECI),
      .rpFMT22     (rpFMT22),
      .rpPAT       (rpPAT),
      .rpPIP       (rpPIP),
      .rpCLBERR    (rpCLBERR),
      .rpSETAOE    (rpSETAOE),
      .rpSETATA    (rpSETATA),
      .rpSETDCK    (rpSETDCK),
      .rpSETDTE    (rpSETDTE),
      .rpSETOPI    (rpSETOPI),
      .rpSETSKI    (rpSETSKI),
      .rpSETWLE    (rpSETWLE),
      .rpSETHCRC   (rpSETHCRC),
      .rpADRSTRT   (rpADRSTRT),
      .rpADRBUSY   (rpADRBUSY),
      .rpSDOP      (rpSDOP),
      .rpSDREQ     (rpSDREQ),
      .rpSDACK     (rpSDACK),
      .rpACTIVE    (rpACTIVE)
   );

   //
   // Fixups
   //

   assign rpDT = drvTYPE;

endmodule
