////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Bus Multiplexer
//
// Details
//   This device 2:1 multiplexes a bus.
//
// File
//   busmux.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
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

module BUSMUX(ubaREQI,  ubaREQO,  ubaACKI,  ubaACKO,  ubaADDRI,  ubaADDRO,  ubaDATAI,  ubaDATAO,
              uba1REQI, uba1REQO, uba1ACKI, uba1ACKO, uba1ADDRI, uba1ADDRO, uba1DATAI, uba1DATAO,
              uba3REQI, uba3REQO, uba3ACKI, uba3ACKO, uba3ADDRI, uba3ADDRO, uba3DATAI, uba3DATAO);

   //
   // Connections to Arbiter
   //
   
   input         ubaREQI;	// UBA Bus Request In
   output        ubaREQO;       // UBA Bus Request Out
   input         ubaACKI;       // UBA Bus Acknowledge In
   output        ubaACKO;       // UBA Bus Acknowledge Out
   input  [0:35] ubaADDRI;      // UBA Address In
   output [0:35] ubaADDRO;      // UBA Address Out
   input  [0:35] ubaDATAI;      // UBA Data In
   output [0:35] ubaDATAO;      // UBA Data Out
  
   // 
   // Connection to UBA1
   //
   
   input         uba1REQI;      // UBA1 Bus Request In
   output        uba1REQO;      // UBA1 Bus Request Out
   input         uba1ACKI;      // UBA1 Bus Acknowledge In
   output        uba1ACKO;      // UBA1 Bus Acknowledge Out
   input  [0:35] uba1ADDRI;     // UBA1 Address In
   output [0:35] uba1ADDRO;     // UBA1 Address Out
   input  [0:35] uba1DATAI;     // UBA1 Data In
   output [0:35] uba1DATAO;     // UBA1 Data Out

   //
   // Connection to UBA3
   //
   
   input         uba3REQI;      // UBA3 Bus RequestIn
   output        uba3REQO;      // UBA3 Bus Request Out
   input         uba3ACKI;      // UBA3 Bus Acknowledge In
   output        uba3ACKO;      // UBA3 Bus Acknowledge Out
   input  [0:35] uba3ADDRI;     // UBA3 Address In
   output [0:35] uba3ADDRO;     // UBA3 Address Out
   input  [0:35] uba3DATAI;     // UBA3 Data In
   output [0:35] uba3DATAO;     // UBA3 Data Out

   //
   // Unibus Inititiator
   //
   
   always @(uba1REQI or uba3REQI or )
     begin
        if (uba1REQI)
          begin
             ubaREQO  = uba1REQI;
             ubaADDRO = uba1ADDRI;
             ubaDATAO = uba1DATAI;
             uba1ACKO = ubaACKI;
          end
        else if (uba3REQI)
          begin
             ubaREQO  = uba3REQI;
             ubaADDRO = uba3ADDRI;
             ubaDATAO = uba3DATAI;
             uba3ACKO = ubaACKI;
          end
     end

   //
   // Unibus Target
   //

   always @(uba1ACKI or uba3ACKI)
     begin
        if (uba1ACKI)
          begin
             ubaACKO = uba1ACKI;
          end
        else (uba3ACKI)
          begin
             ubaACKO = uba3ACKI;
          end
     end

   //
   // Pass through from Arbiter
   //
   
   assign uba1ADDRO = ubaADDRI;
   assign uba1DATAO = ubaDATAI;
   assign uba1REQO  = ubaREQI;

   assign uba3ADDRO = ubaADDRI;
   assign uba3DATAO = ubaDATAI;
   assign uba3REQO  = ubaREQI;

endmodule
