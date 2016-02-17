////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   These are the test addresses for MAINDEC-10-DSUBA
//
// File
//   debug_dsuba.vh
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

begin
   case (PC)
     18'o000000: test = "DSUBA INIT";
     18'o030661: test = "DSUBA TEST1";
     18'o030734: test = "DSUBA TEST2";
     18'o030767: test = "DSUBA TEST3";
     18'o031103: test = "DSUBA TEST4";
     18'o031161: test = "DSUBA TEST5";
     18'o031210: test = "DSUBA TEST6";
     18'o031267: test = "DSUBA TEST7";
     18'o031324: test = "DSUBA TEST10";
     18'o031372: test = "DSUBA TEST11";
     18'o031467: test = "DSUBA TEST12";
     18'o031531: test = "DSUBA TEST13";
     18'o031633: test = "DSUBA TEST14";
     18'o031721: test = "DSUBA TEST15";
     18'o032002: test = "DSUBA TEST16";
     18'o032056: test = "DSUBA TEST17";
     18'o032130: test = "DSUBA TEST20";
     18'o032203: test = "DSUBA TEST21";
     18'o032273: test = "DSUBA TEST22";
     18'o032401: test = "DSUBA TEST23";
     18'o032463: test = "DSUBA TEST24";
     18'o032531: test = "DSUBA TEST25";
     18'o032564: test = "DSUBA TEST26";
     18'o032616: test = "DSUBA TEST27";
     18'o032647: test = "DSUBA TEST30";
     18'o032700: test = "DSUBA TEST31";
     18'o032732: test = "DSUBA TEST32";
     18'o032770: test = "DSUBA TEST33";
     18'o033025: test = "DSUBA TEST34";
     18'o033062: test = "DSUBA TEST35";
     18'o033117: test = "DSUBA TEST36";
     18'o033154: test = "DSUBA TEST37";
     18'o033217: test = "DSUBA TEST40";
     18'o033246: test = "DSUBA TEST41";
     18'o033276: test = "DSUBA TEST42";
     18'o033340: test = "DSUBA TEST43";
     18'o033375: test = "DSUBA TEST44";
     18'o033442: test = "DSUBA TEST45";
     18'o033472: test = "DSUBA TEST46";
     18'o033526: test = "DSUBA TEST47";
     18'o033565: test = "DSUBA TEST50";
     18'o033624: test = "DSUBA TEST51";
     18'o033665: test = "DSUBA TEST52";
     18'o033726: test = "DSUBA TEST53";
     18'o033761: test = "DSUBA TEST54";
     18'o034014: test = "DSUBA TEST55";
     18'o034110: test = "DSUBA TEST56";

     //
     // The maintenance loopback is not implemented.  The
     // following failure is expected.
     //

     18'o031743:
       begin
          $display("Test Completed.  Expected failure.");
          $stop;
       end

   endcase
end
