////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      AM2901 ALU
//!
//! \details
//!
//! \todo
//!
//! \file
//!      am2901.v
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

`include "microcontroller/crom.vh"

module ALU(clk, rst, dbus, crom, multi_shift, divide_shift,
           ci, co, lZ, hZ, ovfl, sign, smear,
           

 t);
   
   parameter cromWidth = `CROM_WIDTH;
   
   input                  clk;			// clock
   input                  rst;			// reset
   input  [0:35]          dbus;        		// ALU Input
   input  [0:cromWidth-1] crom; 		// Control ROM Data
   input                  multi_shift;  	// ALU Multi Shift
   input                  divide_shift; 	// Divide Shift
   input                  ci; 			// Carry Input
   output                 co; 			// Carry Output
   output                 lZ; 			// ALU low-half Zero
   output                 hZ; 			// ALU high-half Zero
   output                 ovfl; 		// Overflow
   output                 sign; 		// Sign
   output                 smear; 		// Sign Smear   
   output [0:35]          t;			// ALU Output

   //
   //
   //
   
   wire   [0:39]          f;			// ALU Output
   reg    [0:39]          q;			// Q Register
   wire   [0:39]          y;			//
   
   wire   [0: 2]          fun  = `cromFUN;	//
   wire   [0: 2]          lsrc = `cromLSRC;	//
   wire   [0: 2]          rsrc = `cromRSRC;	//
   wire   [0: 2]          dst  = `cromDST;	//
   wire                   clkl = `cromCLKL;	//
   wire                   clkr = `cromCLKR;	//
   wire   [0: 3]          aa   = `cromALU_A;	//
   wire   [0: 3]          ba   = `cromALU_B;	//
   wire   [0: 2]          shstyle = `cromSPEC_SHSTYLE;

   //
   // DST[1] is inverted on DPE5/E62
   //
   
   wire   [0: 2]          dest = {dst[0], ~dst[1], dst[2]};
   
   //
   // Sign extend input from 36 bits to 38 bits and add two
   // bits padding on right.
   // 
    
   wire [0:39]            dd = {dbus[0], dbus[0], dbus[0:35], 2'b00};
   
   //
   // RAM Shifter
   //
   
   reg [0:39] bdi;
   always @(f or y or q or dest or shstyle or sign or multi_shift) 
     begin
        if (dest == `cromDST_RAMQU || dest == `cromDST_RAMU)
          case (shstyle)
            `cromSPEC_SHSTYLE_NORM:
              bdi = {f[1:39], multi_shift};
            `cromSPEC_SHSTYLE_ZERO:
              bdi = {f[1:3], y[0], f[5:39], 1'b0};
            `cromSPEC_SHSTYLE_ONES:
              bdi = {f[1:3], y[0], f[5:39], 1'b1};
            `cromSPEC_SHSTYLE_ROT:
              bdi = {f[1:3], y[0], f[5:39], f[4]};
            `cromSPEC_SHSTYLE_ASHC:
              bdi = {f[1:3], y[0], f[5:39], q[4]};
            `cromSPEC_SHSTYLE_LSHC:
              bdi = {f[1:39], q[4]};
            `cromSPEC_SHSTYLE_DIV:
              bdi = {f[1:39], q[4]};
            `cromSPEC_SHSTYLE_ROTC:
              bdi = {f[1:3], y[0], f[5:39], q[4]};				
          endcase
        else if (dest == `cromDST_RAMQD ||  dest == `cromDST_RAMD)
          case (shstyle)
            `cromSPEC_SHSTYLE_NORM:
              bdi = {sign, f[0:38]};
            `cromSPEC_SHSTYLE_ZERO:
              bdi = {sign, f[0:2], 1'b0, f[4:38]};
            `cromSPEC_SHSTYLE_ONES:
              bdi = {sign, f[0:2], 1'b1, f[4:38]};
            `cromSPEC_SHSTYLE_ROT:
              bdi = {sign, f[0:2], f[39], f[4:38]};
            `cromSPEC_SHSTYLE_ASHC:
              bdi = {sign, f[0:38]};
            `cromSPEC_SHSTYLE_LSHC:
              bdi = {sign, f[0:2], 1'b0, f[4:38]};
            `cromSPEC_SHSTYLE_DIV:
              bdi = {sign, f[0:2], 1'b1, f[4:38]};
            `cromSPEC_SHSTYLE_ROTC:     
              bdi = {sign, f[0:2], q[39], f[4:38]};
          endcase
        else
          bdi = f;
     end
   
   //
   // Left Half (MS) Register File
   //
    
   integer i;
   reg [0:19] RAML [0:15];
   wire wrl = ((dest ==`cromDST_RAMA) || (dest ==`cromDST_RAMF) || (dest ==`cromDST_RAMQD) ||
               (dest ==`cromDST_RAMD) || (dest ==`cromDST_RAMU) || (dest ==`cromDST_RAMQU));
      
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          for (i = 0; i < 16; i = i + 1)
            RAML[i] <= 20'b0;
        else if (clkl && wrl)
          RAML[ba] <= bdi[0:19];
     end

   //
   // Right Half (LS) Register File
   //
    
   integer j;
   reg [0:19] RAMR [0:15];
   wire wrr = ((dest ==`cromDST_RAMA) || (dest ==`cromDST_RAMF) || (dest ==`cromDST_RAMQD) ||
               (dest ==`cromDST_RAMD) || (dest ==`cromDST_RAMU) || (dest ==`cromDST_RAMQU));
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          for (j = 0; j < 16; j = j + 1)
            RAMR[j] <= 20'b0;
        else if (clkr && wrr)
          RAMR[ba] <= bdi[20:39];
     end
   
   wire [0:39] ad = {RAML[aa], RAMR[aa]};
   wire [0:39] bd = {RAML[ba], RAMR[ba]};

   //
   // Q Register Shifter
   //

   reg [0:39] qi;
   always @(f or q or dest or shstyle or divide_shift)
     begin
        case (dest)
         `cromDST_RAMQU:
            case (shstyle)
              `cromSPEC_SHSTYLE_NORM:
                qi <= {q[1:39], 1'b0};
              `cromSPEC_SHSTYLE_ZERO:
                qi <= {q[1:39], 1'b0};
              `cromSPEC_SHSTYLE_ONES:
                qi <= {q[1:39], 1'b1};
              `cromSPEC_SHSTYLE_ROT:
                qi <= {q[1:39], q[4]};
              `cromSPEC_SHSTYLE_ASHC:
                qi <= {q[1:39], 1'b0};
              `cromSPEC_SHSTYLE_LSHC:
                qi <= {q[1:39], 1'b0};
              `cromSPEC_SHSTYLE_DIV:
                qi <= {q[1:39], divide_shift};
              `cromSPEC_SHSTYLE_ROTC:     
                qi <= {q[1:39], f[4]};
            endcase
         `cromDST_RAMQD:
            case (shstyle)
              `cromSPEC_SHSTYLE_NORM:
                qi <= {1'b0, f[0:38]};
              `cromSPEC_SHSTYLE_ZERO:
                qi <= {1'b0, q[0:2], 1'b0, q[4:38]};
              `cromSPEC_SHSTYLE_ONES:
                qi <= {1'b0, q[0:2], 1'b1, q[4:38]};
              `cromSPEC_SHSTYLE_ROT:
                qi <= {1'b0, q[0:2], q[39], q[4:38]};
              `cromSPEC_SHSTYLE_ASHC:
                qi <= {1'b0, q[0:2], f[39], q[4:38]};
              `cromSPEC_SHSTYLE_LSHC:
                qi <= {1'b0, q[0:2], f[39], q[4:38]};
              `cromSPEC_SHSTYLE_DIV:
                qi <= {1'b0, q[0:2], f[39], q[4:38]};
              `cromSPEC_SHSTYLE_ROTC:     
                qi <= {1'b0, q[0:2], f[39], q[4:38]};
            endcase
         `cromDST_QREG:
            qi <= f;
          default:
            qi <= q;
        endcase
     end

   //
   // Left Half Q Register
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          q[0:19] <= 20'b0;
        else if (clkl)
          q[0:19] <= qi[0:19];
     end
   
   //
   // Right Half Q Register
   //
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          q[20:39] <= 20'b0;
        else if (clkr)
          q[20:39] <= qi[20:39];
     end

   //
   // ALU Left R Source Selector
   //

   reg [0:39] r;
   always @(ad or dd or lsrc)
     begin  
        case (lsrc)
          `cromSRC_AQ:
            r[0:19] = ad[0:19];
          `cromSRC_AB:
            r[0:19] = ad[0:19];
          `cromSRC_ZQ:
            r[0:19] = 20'b0;
          `cromSRC_ZB:
            r[0:19] = 20'b0;
          `cromSRC_ZA:
            r[0:19] = 20'b0;
          default:
            r[0:19] = dd[0:19];
        endcase
     end
            
   //
   // ALU Right R Source Selector
   //

   always @(ad or dd or rsrc)
     begin  
        case (rsrc)
          `cromSRC_AQ:
            r[20:39] = ad[20:39];
          `cromSRC_AB:
            r[20:39] = ad[20:39];
          `cromSRC_ZQ:
            r[20:39] = 20'b0;
          `cromSRC_ZB:
            r[20:39] = 20'b0;
          `cromSRC_ZA:
            r[20:39] = 20'b0;
          default:
            r[20:39] = dd[20:39];
        endcase
     end
            
   //
   // ALU Left S Source Selector
   //
   
   reg [0:39] s;
   always @(ad or bd or q or lsrc)
     begin  
        case (lsrc)
          `cromSRC_AQ:
            s[0:19] = q[0:19];
          `cromSRC_ZQ:
            s[0:19] = q[0:19];
          `cromSRC_DQ:
            s[0:19] = q[0:19];
          `cromSRC_AB:
            s[0:19] = bd[0:19];
          `cromSRC_ZB:
            s[0:19] = bd[0:19];
          `cromSRC_ZA:
            s[0:19] = ad[0:19];
          `cromSRC_DA:
            s[0:19] = ad[0:19];
          default:
            s[0:19] = 20'b0;
        endcase
     end   

   //
   // ALU Right S Source Selector
   //
   
   always @(ad or bd or q or rsrc)
     begin  
        case (rsrc)
          `cromSRC_AQ:
            s[20:39] = q[20:39];
          `cromSRC_ZQ:
            s[20:39] = q[20:39];
          `cromSRC_DQ:
            s[20:39] = q[20:39];
          `cromSRC_AB:
            s[20:39] = bd[20:39];
          `cromSRC_ZB:
            s[20:39] = bd[20:39];
          `cromSRC_ZA:
            s[20:39] = ad[20:39];
          `cromSRC_DA:
            s[20:39] = ad[20:39];
          default:
            s[20:39] = 20'b0;
        endcase
     end   
            
   //
   // ALU Proper
   //
   
   wire [0:40] r1 = {1'b0, r};
   wire [0:40] s1 = {1'b0, s};
   reg  [0:40] f1;   

   always @(r1 or s1 or ci or fun)
     begin  
        case (fun)
          `cromFUN_ADD:
            if (ci)
              f1 = r1 + s1 + 1;
            else
              f1 = r1 + s1;
          `cromFUN_SUBR:
            if (ci)
              f1 = r1 + ~s1 + 1;
            else
              f1 = r1 + ~s1;
          `cromFUN_SUBS:
            if (ci)
              f1 = s1 + r1;
            else
              f1 = s1 + ~r1 + 1;
          `cromFUN_ORRS:
            f1 = r1 | s1;
          `cromFUN_ANDRS:
            f1 = r1 & s1;
          `cromFUN_NOTRS:
            f1 = ~r1 & s1;
          `cromFUN_EXOR:
            f1 = r1 ^ s1;
          `cromFUN_EXNOR:
            f1 = ~(r1 ^ s1);
        endcase
     end

   //
   // ALU outputs
   //
   
   assign co   = f1[0];
   assign sign = f1[1];
   assign f    = f1[1:40];
   assign ovfl = f1[0] != f1[1];
   assign lZ   = f1[ 0:19] == 0;
   assign hZ   = f1[20:39] == 0;

   //
   // ALU Destination Selector
   //
   
   assign y = (dest ==`cromDST_RAMA) ? ad : f;

   //
   // Status Register
   //  DPE5/E20
   //

   reg flag_fl02;  //FIXME
   reg flag_ql02;  //FIXME
   reg flag_qr37;  //FIXME
   reg flag_carry_02;  //FIXME
   reg flag_carry_out;  //FIXME
   reg flag_funct_01;  //FIXME
   
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             flag_fl02      <= 1'b0;
             flag_ql02      <= 1'b0;
             flag_qr37      <= 1'b0;
             flag_carry_02  <= 1'b0;
             flag_carry_out <= 1'b0;
             flag_funct_01  <= 1'b0;
          end
        else
          begin
             flag_fl02      <= 1'b0;  //FIXME
             flag_ql02      <= 1'b0;  //FIXME
             flag_qr37      <= 1'b0;  //FIXME
             flag_carry_02  <= 1'b0;  //FIXME
             flag_carry_out <= 1'b0;  //FIXME
             flag_funct_01  <= 1'b0;  //FIXME
          end
     end
   
   //
   // Truncate output bus from 40 bits to 36 bits.
   //

   assign dpsgn = y[0];
   assign smear = y[1];
   assign t     = y[2:37];
   
endmodule   
