////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   These are the test addresses for MAINDEC-10-DSKCG
//
// File
//   debug_dskcg.vh
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

begin
   case (PC)
     18'o000000: test = "DSKCG INIT";
     18'o030620: test = "DSKCG TRAPT1";
     18'o030647: test = "DSKCG TRAPT2";
     18'o030704: test = "DSKCG TRAPT3";
     18'o031012: test = "DSKCG CMPMOD";
     18'o031203: test = "DSKCG MOVMOD";
     18'o031444: test = "DSKCG CDBMOD";
     18'o031613: test = "DSKCG CBDMOD";
     18'o031723: test = "DSKCG EDMODM";
     18'o032576: test = "DSKCG PFTST";
   endcase
end
