////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// \brief
//      Control ROM (CROM) Definitions 
//
// \details
//
// \notes
//
// \file
//      crom.vh
//
// \author
//      Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2009, 2012 Rob Doyle
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

`define CROM_WIDTH      	108             // CROM Width
`define CROM_DATA       	"crom.bin"      // CROM Data File

//
// Control ROM Fields
//   

`define cromJ                	crom[0:11]     	// Jump address

//
// ALU Functions
//

`define cromFUN                 crom[12:14]    	// ALU Function
`define cromFUN_ADD             3'b000
`define cromFUN_SUBR            3'b001
`define cromFUN_SUBS            3'b010
`define cromFUN_ORRS            3'b011
`define cromFUN_ANDRS           3'b100
`define cromFUN_NOTRS           3'b101
`define cromFUN_EXOR            3'b110
`define cromFUN_EXNOR           3'b111

//
// ALU Sources (Left and Right)
//

`define cromLSRC                crom[15:17]     // ALU Left Source
`define cromRSRC                crom[18:20]     // ALU Right Source
`define cromSRC_AQ              3'b000
`define cromSRC_AB              3'b001
`define cromSRC_ZQ              3'b010
`define cromSRC_ZB              3'b011
`define cromSRC_ZA              3'b100
`define cromSRC_DA              3'b101
`define cromSRC_DQ              3'b110
`define cromSRC_DZ              3'b111

//   
// ALU Destinations
//

`define cromDST        		crom[21:23]	// ALU Destinations
`define cromDST_QREG  		3'b000
`define cromDST_NOP   		3'b001
`define cromDST_RAMA  		3'b010
`define cromDST_RAMF  		3'b011
`define cromDST_RAMQD 		3'b100
`define cromDST_RAMD  		3'b101
`define cromDST_RAMQU 		3'b110
`define cromDST_RAMU  		3'b111
   

`define cromALU_A        	crom[26:29]     // ALU A Address
`define cromALU_B        	crom[32:35]     // ALU B Address
`define cromRAMADR      	crom[36:38]     // RAM File address
`define cromDBUS        	crom[40:41]     //
`define cromDBM         	crom[42:44]     //
`define cromCLKL        	crom[45]        // ALU Left Clock Enable
`define cromCLKR        	crom[48]        // ALU Right Clock Enable

//
// SPEC Field
//

`define cromSPEC        	crom[51:56]     // Spec Select
`define cromSPEC_EN_40          crom[51]
`define cromSPEC_EN_20          crom[52]
`define cromSPEC_EN_10          crom[53]
`define cromSPEC_SEL            crom[54:56]
`define cromSPEC_SEL_LOADIR     3'b001
`define cromSPEC_SEL_LOADXR     3'b001

`define cromSPEC_SHSTYLE       	crom[54:56]     // Shift Style
`define cromSPEC_SHSTYLE_NORM 	3'b000
`define cromSPEC_SHSTYLE_ZERO 	3'b001
`define cromSPEC_SHSTYLE_ONES 	3'b010
`define cromSPEC_SHSTYLE_ROT  	3'b011
`define cromSPEC_SHSTYLE_ASHC	3'b100
`define cromSPEC_SHSTYLE_LSHC 	3'b101
`define cromSPEC_SHSTYLE_DIV  	3'b110
`define cromSPEC_SHSTYLE_ROTC 	3'b111
`define cromSPEC_BYTE        	crom[54:56]     // Byte Select

//
// Displacement Select
//

`define cromDISP        	crom[57:62]
`define cromDISP_EN_40  	(~crom[57])
`define cromDISP_EN_20  	(~crom[58]) 
`define cromDISP_EN_10  	(~crom[59]) 
`define cromDISP_SELH   	crom[61:62] 
`define cromDISP_SEL    	crom[60:62] 
`define cromDISP_SELH_DIAG   	2'b00
`define cromDISP_SELH_RET    	2'b01
`define cromDISP_SELH_J      	2'b10
`define cromDISP_SELH_AREAD  	2'b11
`define cromDISP_SEL_DIAG    	3'b000
`define cromDISP_SEL_RET     	3'b001
`define cromDISP_SEL_MULTIPLY	3'b010
`define cromDISP_SEL_PAGEFAIL	3'b011
`define cromDISP_SEL_NICOND  	3'b100
`define cromDISP_SEL_BYTE    	3'b101
`define cromDISP_SEL_EAMODE  	3'b110
`define cromDISP_SEL_SCAD    	3'b111

// Skip Select
`define cromSKIP        crom[63:68]
`define cromSKIP_EN_40  (~crom[63])
`define cromSKIP_EN_20  (~crom[64])
`define cromSKIP_EN_10  (~crom[65])
`define cromSKIP_SEL    crom[66:68]

`define cromT           crom[68:71]     // 
`define cromCRY38       crom[72]        //
`define cromLOADSC      crom[73]        // Load Step Counter from SCAD
`define cromLOADFE      crom[74]        // Load FE Register from SCAD
`define cromFMWRITE     crom[75]        // Write to RAM FILE
`define cromMEM         crom[76]        // Start/complete a memory or IO cycle
`define cromDIVIDE      crom[72]        // 
`define cromMULTIPREC   crom[78]        //
`define cromMULTISHIFT  crom[79]        //
`define cromCALL        crom[80]        //
`define cromSCAD        crom[90:92]     // SCAD ALU OP
`define cromSCADA       crom[93:95]     //
`define cromSCADB       crom[96:97]     //
`define cromSNUM        crom[98:107]    //
`define cromNUM         crom[90:107]    //
`define cromSTATE       crom[90:107]    //
`define cromSETOV       crom[90]        // Set arithmetic overflow
`define cromFORCEUSER   crom[90]        // Force user mode reference
`define cromPI_ZER      crom[90:92]     //
`define cromSETFOV      crom[91]        // Set floating point overflow
`define cromFORCEEXEC   crom[91]        // Force exec mode reference
`define cromSETNDV      crom[92]        // Set no divide
`define cromFETCH       crom[92]        // This is an instruction fetch
`define cromCLRFPD      crom[93]        // Clear first part done
`define cromREADCYCLE   crom[93]        // Select a read cycle
`define cromPI_IP1      crom[93]        // PI 1 in progress
`define cromSETFPD      crom[94]        // Set first part done
`define cromWRITETEST   crom[94]        // Page Fail if not written
`define cromPI_IP2      crom[94]        // PI 2 in progress
`define cromHOLDUSER    crom[95]        //
`define cromWRITECYCLE  crom[95]        //
`define cromPI_IP3      crom[95]        // PI 3 in progress
`define cromSPARE1      crom[96]        // Spare
`define cromPI_IP4      crom[96]        // PI 4 in progress
`define cromTRAP2       crom[97]        // Set trap 2
`define cromPI_IP5      crom[97]        // PI 5 in progress
`define cromDONTCACHE   crom[97]        // Don't lock in cache
`define cromTRAP1       crom[98]        // Set trap 1
`define cromPHYSICAL    crom[98]        // Don't invoke paging hardare
`define cromPI_IP6      crom[98]        // PI 6 in progress
`define cromLDPCU       crom[99]        // Load PCU
`define cromPI_IP7      crom[99]        // PI 7 in progress
`define cromPCXT        crom[99:101]    // Which PCXT bits to look at
`define cromSPARE2      crom[100]       // Spare
`define cromIOCYCLE     crom[100]       // This is an IO cycle
`define cromPI_ON       crom[100]       // PI is on
`define cromSPARE3      crom[101]       // Spare
`define cromWRUCYCLE    crom[101]       // This is a "who are u" cycle
`define cromPI_CO11     crom[101]       // Chan 1 is on
`define cromSPARE4      crom[102]       // Spare
`define cromVECTORCYC   crom[102]       // Read vector interrupt
`define cromAREAD       crom[102]       //
`define cromPI_CO12     crom[102]       // Chan 2 is on
`define cromSPARE5      crom[103]       // Spare
`define cromIOBYTE      crom[103]       // This is a byte cycle
`define cromDPFUNC      crom[103]       //
`define cromI_CO3       crom[103]       //
`define cromJFCLFLG     crom[104]       // Do a JFCL instruction
`define cromLDVMA       crom[104]       //
`define cromI_CO4       crom[104]       //
`define cromLDFLAGS     crom[105]       // Load flags from DP
`define cromEXTADR      crom[105]       //
`define cromI_CO5       crom[105]       //
`define cromSPARE6      crom[106]       //
`define cromWAIT        crom[106]       //
`define cromI_CO6       crom[106]       //
`define cromADFLGS      crom[107]       //
`define cromBWRITE      crom[107]       //
`define cromI_CO7       crom[107]       //

`define cromWORK        crom[98:107]    //
`define cromDT          crom[109:111]   // Not used

