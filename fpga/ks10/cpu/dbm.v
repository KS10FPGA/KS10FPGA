////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      DBM Multiplexor
//!
//! \details
//!
//! \todo
//!
//! \notes
//!
//!      +-------+-------+----+-------+-------+-------+-------+-------+
//!      |  dbm  |  spec |    |       |       |       |       |       |
//!      |  sel  |  sel  | -> | sel1  | sel2  | sel3  | sel4  | sel5  |
//!      | 4 2 1 | 4 2 1 | -> | 4 2 1 | 4 2 1 | 4 2 1 | 4 2 1 | 4 2 1 |
//!      +-------+-------+----+-------+-------+-------+-------+-------+
//!      | 0 0 0 | x x x | -> | 0 0 0 | 0 0 0 | 0 0 0 | 0 0 0 | 0 0 0 |
//!      +-------+-------+----+-------+-------+-------+-------+-------+
//!      | 0 0 1 | 0 0 0 | -> | 0 0 1 | 0 0 1 | 0 0 1 | 0 0 1 | 0 0 1 |
//!      | 0 0 1 | 0 0 1 | -> | 0 1 1 | 0 0 1 | 0 0 1 | 0 0 1 | 0 0 1 |
//!      | 0 0 1 | 0 1 0 | -> | 0 0 1 | 0 1 1 | 0 0 1 | 0 0 1 | 0 0 1 |
//!      | 0 0 1 | 0 1 1 | -> | 0 0 1 | 0 0 1 | 0 1 1 | 0 0 1 | 0 0 1 |
//!      | 0 0 1 | 1 0 0 | -> | 0 0 1 | 0 0 1 | 0 0 1 | 0 1 1 | 0 0 1 |
//!      | 0 0 1 | 1 0 1 | -> | 0 0 1 | 0 0 1 | 0 0 1 | 0 0 1 | 0 1 1 |
//!      | 0 0 1 | 1 1 0 | -> | 0 0 1 | 0 0 1 | 0 0 1 | 0 0 1 | 0 0 1 |
//!      | 0 0 1 | 1 1 1 | -> | 0 0 1 | 0 0 1 | 0 0 1 | 0 0 1 | 0 0 1 |
//!      +-------+-------+----+-------+-------+-------+-------+-------+
//!      | 0 1 0 | x x x | -> | 0 1 0 | 0 1 0 | 0 1 0 | 0 1 0 | 0 1 0 |
//!      +-------+-------+----+-------+-------+-------+-------+-------+
//!      | 0 1 1 | 0 0 0 | -> | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 |
//!      | 0 1 1 | 0 0 1 | -> | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 |
//!      | 0 1 1 | 0 1 0 | -> | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 |
//!      | 0 1 1 | 0 1 1 | -> | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 |
//!      | 0 1 1 | 1 0 0 | -> | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 |
//!      | 0 1 1 | 1 0 1 | -> | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 |
//!      | 0 1 1 | 1 1 0 | -> | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 |
//!      | 0 1 1 | 1 1 1 | -> | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 | 0 1 1 |
//!      +-------+-------+----+-------+-------+-------+-------+-------+
//!      | 1 0 0 | x x x | -> | 1 0 0 | 1 0 0 | 1 0 0 | 1 0 0 | 1 0 0 |
//!      +-------+-------+----+-------+-------+-------+-------+-------+
//!      | 1 0 1 | x x x | -> | 1 0 1 | 1 0 1 | 1 0 1 | 1 0 1 | 1 0 1 |
//!      +-------+-------+----+-------+-------+-------+-------+-------+
//!      | 1 1 0 | x x x | -> | 1 1 0 | 1 1 0 | 1 1 0 | 1 1 0 | 1 1 0 |
//!      +-------+-------+----+-------+-------+-------+-------+-------+
//!      | 1 1 1 | x x x | -> | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 | 1 1 1 |
//!      +-------+-------+----+-------+-------+-------+-------+-------+
//!
//! \file
//!      dbm.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
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

`include "useq/crom.vh"

module DBM(crom, dbm0, dbm1, dbm2, dbm3, dbm4, dbm5, dbm6, dbm7, dbm);

   parameter  cromWidth = `CROM_WIDTH;

   input      [0:cromWidth-1] crom;             // Control ROM Data
   input      [0:35]          dbm0;             // DBM input 0
   input      [0:35]          dbm1;             // DBM input 1
   input      [0:35]          dbm2;             // DBM input 2
   input      [0:35]          dbm3;             // DBM input 3
   input      [0:35]          dbm4;             // DBM input 4
   input      [0:35]          dbm5;             // DBM input 5
   input      [0:35]          dbm6;             // DBM input 6
   input      [0:35]          dbm7;             // DBM input 7
   output reg [0:35]          dbm;              // DBM output

   //
   // DBM
   //

   wire [0:2] specSEL = `cromSPEC_SEL;
   wire [0:2] dbmSEL  = `cromDBM_SEL;
   
   //
   // Selection
   //  DPM1/E94
   //  DPM1/E72
   //  DPM1/E86
   //
   
   wire [0:2] sel1 = (dbmSEL == `cromDBM_SEL_BYTES && specSEL == 3'b001) ? dbmSEL | 3'b010 : dbmSEL;
   wire [0:2] sel2 = (dbmSEL == `cromDBM_SEL_BYTES && specSEL == 3'b010) ? dbmSEL | 3'b010 : dbmSEL;
   wire [0:2] sel3 = (dbmSEL == `cromDBM_SEL_BYTES && specSEL == 3'b011) ? dbmSEL | 3'b010 : dbmSEL;
   wire [0:2] sel4 = (dbmSEL == `cromDBM_SEL_BYTES && specSEL == 3'b100) ? dbmSEL | 3'b010 : dbmSEL;
   wire [0:2] sel5 = (dbmSEL == `cromDBM_SEL_BYTES && specSEL == 3'b101) ? dbmSEL | 3'b010 : dbmSEL;

   //
   // DBM[0:5] MUX
   //  DPM1/E58
   //  DPM1/E42
   //  DPM1/E34
   //  DPM1/E65
   //  DPM1/E50
   //  DPM1/E49
   //  DPM1/E57
   //
   
   always @(sel1 or dbm0[0:6] or dbm1[0:6] or dbm2[0:6] or dbm3[0:6] or dbm4[0:6] or dbm5[0:6] or dbm6[0:6] or dbm7[0:6])
     begin
        case (sel1)
          3'b000 : 
            dbm[0:6] = dbm0[0:6];
          3'b001 :
            dbm[0:6] = dbm1[0:6];
          3'b010 : 
            dbm[0:6] = dbm2[0:6];
          3'b011 :
            dbm[0:6] = dbm3[0:6];
          3'b100 : 
            dbm[0:6] = dbm4[0:6];
          3'b101 :
            dbm[0:6] = dbm5[0:6];
          3'b110 : 
            dbm[0:6] = dbm6[0:6];
          3'b111 :
            dbm[0:6] = dbm7[0:6];
        endcase
     end
   
   //
   // DBM[7:13] MUX
   //  DPM1/E64
   //  DPM1/E59
   //  DPM1/E80
   //  DPM1/E73
   //  DPM1/E79
   //  DPM1/E81
   //  DPM1/E98
   //
   
   always @(sel2 or dbm0[7:13] or dbm1[7:13] or dbm2[7:13] or dbm3[7:13] or dbm4[7:13] or dbm5[7:13] or dbm6[7:13] or dbm7[7:13])
     begin
        case (sel2)
          3'b000 : 
            dbm[7:13] = dbm0[7:13];
          3'b001 :
            dbm[7:13] = dbm1[7:13];
          3'b010 : 
            dbm[7:13] = dbm2[7:13];
          3'b011 :
            dbm[7:13] = dbm3[7:13];
          3'b100 : 
            dbm[7:13] = dbm4[7:13];
          3'b101 :
            dbm[7:13] = dbm5[7:13];
          3'b110 : 
            dbm[7:13] = dbm6[7:13];
          3'b111 :
            dbm[7:13] = dbm7[7:13];
        endcase
     end
   
   //
   // DBM[14:20] MUX
   //  DPM1/E88
   //  DPM1/E89
   //  DPM1/E95
   //  DPM1/E96
   //  DPM2/E104
   //  DPM2/E105
   //  DPM2/E106
   //
   
   always @(sel3 or dbm0[14:20] or dbm1[14:20] or dbm2[14:20] or dbm3[14:20] or dbm4[14:20] or dbm5[14:20] or dbm6[14:20] or dbm7[14:20])
     begin
        case (sel3)
          3'b000 : 
            dbm[14:20] = dbm0[14:20];
          3'b001 :
            dbm[14:20] = dbm1[14:20];
          3'b010 : 
            dbm[14:20] = dbm2[14:20];
          3'b011 :
            dbm[14:20] = dbm3[14:20];
          3'b100 : 
            dbm[14:20] = dbm4[14:20];
          3'b101 :
            dbm[14:20] = dbm5[14:20];
          3'b110 : 
            dbm[14:20] = dbm6[14:20];
          3'b111 :
            dbm[14:20] = dbm7[14:20];
        endcase
     end

   //
   // DBM[21:27] MUX
   //  DPM2/E112
   //  DPM2/E113
   //  DPM2/E120
   //  DPM2/E128
   //  DPM2/E143
   //  DPM2/E129
   //  DPM2/E121
   //
   
   always @(sel4 or dbm0[21:27] or dbm1[21:27] or dbm2[21:27] or dbm3[21:27] or dbm4[21:27] or dbm5[21:27] or dbm6[21:27] or dbm7[21:27])
     begin
        case (sel4)
          3'b000 : 
            dbm[21:27] = dbm0[21:27];
          3'b001 :
            dbm[21:27] = dbm1[21:27];
          3'b010 : 
            dbm[21:27] = dbm2[21:27];
          3'b011 :
            dbm[21:27] = dbm3[21:27];
          3'b100 : 
            dbm[21:27] = dbm4[21:27];
          3'b101 :
            dbm[21:27] = dbm5[21:27];
          3'b110 : 
            dbm[21:27] = dbm6[21:27];
          3'b111 :
            dbm[21:27] = dbm7[21:27];
        endcase
     end

   //
   // DBM[28:35] MUX
   //  DPM2/E173
   //  DPM2/E151
   //  DPM2/E166
   //  DPM2/E167
   //  DPM2/E172
   //  DPM2/E187
   //  DPM2/E165
   //  DPM2/E188
   //
   
   always @(sel5 or dbm0[28:35] or dbm1[28:35] or dbm2[28:35] or dbm3[28:35] or dbm4[28:35] or dbm5[28:35] or dbm6[28:35] or dbm7[28:35])
     begin
        case (sel5)
          3'b000 : 
            dbm[28:35] = dbm0[28:35];
          3'b001 :
            dbm[28:35] = dbm1[28:35];
          3'b010 : 
            dbm[28:35] = dbm2[28:35];
          3'b011 :
            dbm[28:35] = dbm3[28:35];
          3'b100 : 
            dbm[28:35] = dbm4[28:35];
          3'b101 :
            dbm[28:35] = dbm5[28:35];
          3'b110 : 
            dbm[28:35] = dbm6[28:35];
          3'b111 :
            dbm[28:35] = dbm7[28:35];
        endcase
     end

endmodule
