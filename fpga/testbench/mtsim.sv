///////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor Testbench
//
// Brief
//   KS-10 FPGA MT Simulation
//
// File
//   mtsim.v
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

//
// The Verilog simulator uses 32-bit signed integers.
//

`ifndef UNIT0_TAP
 `define UNIT0_TAP "testbench/red405a2.tap"
`endif

`define NULL 0
`define EOF 32'hFFFF_FFFF

   int        fd_tape;
   int        fd_mtstat;
   int        objcnt;
   int        reccnt;
   int        filcnt;
   logic      lastTM;
   reg [63:0] mtDIR;


   //
   // mtDIR bits
   //

   localparam [63: 0] mtDIR_READ   = (1 << 63),
                      mtDIR_STB    = (1 << 62),
                      mtDIR_INIT   = (1 << 61),
                      mtDIR_READY  = (1 << 60),
                      mtDIR_INCFC  = (1 << 59),
                      mtDIR_WCZ    = (1 << 43),
                      mtDIR_FCZ    = (1 << 42),
                      mtDIR_SETBOT = (1 << 41),
                      mtDIR_CLRBOT = (1 << 40),
                      mtDIR_SETEOT = (1 << 39),
                      mtDIR_CLREOT = (1 << 38),
                      mtDIR_SETTM  = (1 << 37),
                      mtDIR_CLRTM  = (1 << 36);

   `define mtDIR_SS  58:56
   `define mtDIR_DEN 55:53
   `define mtDIR_FUN 52:48
   `define mtDIR_FMT 47:44

   //
   // Tape file metadata
   //

   localparam [31:0]  h_EOT = 32'hffffffff,     // End-of-tape
                      h_GAP = 32'hfffffffe,     // Erase gap
                      h_TM  = 32'h00000000;     // Tape mark

   //
   // Supported tape formats
   //

   localparam [3:0] mtFMT_CORDMP = 4'o00,
                    mtFMT_NORMAL = 4'o03;

   //
   // Supported tape densities
   //

   localparam [2:0] mtDEN_800NRZI = 3'o3,
                    mtDEN_1600PE  = 3'o4;

   //
   // Constants for $fseek()
   //

   localparam SEEK_SET = 0,
              SEEK_CUR = 1,
              SEEK_END = 2;

   //
   // Tape Speeds
   //
   // For Rewind, the tape moves at 350 inches per second at either 1600
   // bytes per inch or 800 bytes per inch depending on format.
   //
   // For Read/Write, the tape moves at 75 inches per second at either 1600
   // bytes per inch or 800 bytes per inch depending on format.
   //
   // The following times are in nano seconds per byte
   //
   // Note:
   //   The simulation delays are decreased because I don't have the patience
   //   to wait for the simulator
   //

`ifdef SYNTHESIS

   localparam real mtSPD_800BPI_RW   = 1.0e9/ 60000.0,  //  800 BPI Read/Write
                   mtSPD_1600BPI_RW  = 1.0e9/120000.0;  // 1600 BPI Read/Write
                   mtSPD_800BPI_REW  = 1.0e9/280000.0,  //  800 BPI Rewind
                   mtSPD_1600BPI_REW = 1.0e9/560000.0,  // 1600 BPI Rewind
                   mtSPD_ERASE       = 16666.0;         // Erase time for four bytes
`else

   localparam real mtSPD_800BPI_RW   = 1000,            //  800 BPI Read/Write
                   mtSPD_1600BPI_RW  = 1000,            // 1600 BPI Read/Write
                   mtSPD_800BPI_REW  = 1000,            //  800 BPI Rewind
                   mtSPD_1600BPI_REW = 1000,            // 1600 BPI Rewind
                   mtSPD_ERASE       =  100;            // Erase time for four bytes
`endif

   //
   // Read Tape Header
   //

   function logic [31:0] readHeader;
      begin
         readHeader[ 7: 0] = $fgetc(fd_tape);
         readHeader[15: 8] = $fgetc(fd_tape);
         readHeader[23:16] = $fgetc(fd_tape);
         readHeader[31:24] = $fgetc(fd_tape);
      end
   endfunction

   //
   // Write Tape Header
   //

   task writeHeader(input [31:0] in);
      begin
         $fwrite(fd_tape,"%c", in[ 7: 0]);
         $fwrite(fd_tape,"%c", in[15: 8]);
         $fwrite(fd_tape,"%c", in[23:16]);
         $fwrite(fd_tape,"%c", in[31:24]);
      end
      $fflush(fd_tape);
   endtask

   //
   // Read Tape Data
   //

   function logic [35:0] readData;
      reg [0:3] bucket;
      if (mtDIR[`mtDIR_FMT] == mtFMT_CORDMP)
        begin
           readData[35:28] = $fgetc(fd_tape);
           readData[27:20] = $fgetc(fd_tape);
           readData[19:12] = $fgetc(fd_tape);
           readData[11: 4] = $fgetc(fd_tape);
           {bucket, readData[3:0]} = $fgetc(fd_tape);
        end
      else if (mtDIR[`mtDIR_FMT] == mtFMT_NORMAL)
        begin
           readData[35:28] = $fgetc(fd_tape);
           readData[27:20] = $fgetc(fd_tape);
           readData[19:12] = $fgetc(fd_tape);
           readData[11: 4] = $fgetc(fd_tape);
           readData[ 3: 0] = 4'b0;
        end
      else
        begin
           $fwrite(fd_mtstat, "[%11.3f] TAPE: Unsupported tape format. Format was %02o.\n", $time/1.0e3, mtDIR[`mtDIR_FMT]);
//         $stop;
        end
   endfunction

   //
   // Write Tape Data
   //

   task writeData(input [35:0] in);
      if (mtDIR[`mtDIR_FMT] == mtFMT_CORDMP)
        begin
           $fwrite(fd_tape,"%c", in[35:28]);
           $fwrite(fd_tape,"%c", in[27:20]);
           $fwrite(fd_tape,"%c", in[19:12]);
           $fwrite(fd_tape,"%c", in[11: 4]);
           $fwrite(fd_tape,"%c", {4'b0, in[3:0]});
        end
      else if (mtDIR[`mtDIR_FMT] == mtFMT_NORMAL)
        begin
           $fwrite(fd_tape,"%c", in[35:28]);
           $fwrite(fd_tape,"%c", in[27:20]);
           $fwrite(fd_tape,"%c", in[19:12]);
           $fwrite(fd_tape,"%c", in[11: 4]);
        end
      else
        begin
           $fwrite(fd_mtstat, "[%11.3f] TAPE: Unsupported tape format. Format was %02o.\n", $time/1.0e3, mtDIR[`mtDIR_FMT]);
//         $stop;
        end
      $fflush(fd_tape);
   endtask

   //
   // Given format, lookup bytes per word
   //

   function int bytes_per_word(input [63:0] mtDIR);
      bytes_per_word = (mtDIR[`mtDIR_FMT] == mtFMT_CORDMP) ? 5 : 4;
   endfunction

   //
   // This task determines how long a rewind should take and delays that amount.
   //
   // The tape rewinds at 350 inches-per-second at either 800 bytes-per-inch or
   // 1600 bytes-per-inch.
   //

   task waitRewind(input [63:0] mtDIR);
      real nsec_per_byte;
      longint pos;
      nsec_per_byte = (mtDIR[`mtDIR_DEN] == mtDEN_1600PE) ? mtSPD_1600BPI_REW : mtSPD_800BPI_REW;
      pos = $ftell(fd_tape);
      #(nsec_per_byte * pos * 1ns);
   endtask

   //
   // The tape moves at 75 inches-per-second at either 800 bytes-per-inch or
   // 1600 bytes-per-inch.
   //

   task waitReadWrite(input [63:0] mtDIR, input int bytes);
      real nsec_per_byte;
      nsec_per_byte = (mtDIR[`mtDIR_DEN] == mtDEN_1600PE) ? mtSPD_1600BPI_RW : mtSPD_800BPI_RW;
      #(nsec_per_byte * bytes * 1ns);
   endtask

   //
   // No-op Command
   //

   task nop(input [31:0] addrMTDIR);
      $fwrite(fd_mtstat, "[%11.3f] TAPE: No-op command.\n", $time/1.0e3);
      $fwrite(fd_mtstat, "[%11.3f] TAPE: No-op command completed.\n", $time/1.0e3);
   endtask;

   //
   // Unload Command
   //

   task unload(input [31:0] addrMTDIR);
      $fwrite(fd_mtstat, "[%11.3f] TAPE: Unload command.\n", $time/1.0e3);
      void'($fseek(fd_tape, 0, SEEK_SET));
      waitRewind(mtDIR);
      $fwrite(fd_mtstat, "[%11.3f] TAPE: Unload command completed.\n", $time/1.0e3);
   endtask

   //
   // Rewind Command
   //

   task rewind(input [31:0] addrMTDIR);
      $fwrite(fd_mtstat, "[%11.3f] TAPE: Rewind command.\n", $time/1.0e3);
      void'($fseek(fd_tape, 0, SEEK_SET));
      waitRewind(mtDIR);
      $fwrite(fd_mtstat, "[%11.3f] TAPE: Rewind command completed.\n", $time/1.0e3);
   endtask

   //
   // Preset Command
   //

   task preset(input [31:0] addrMTDIR);
      $fwrite(fd_mtstat, "[%11.3f] TAPE: Preset command.\n", $time/1.0e3);
      void'($fseek(fd_tape, 0, SEEK_SET));
      waitRewind(mtDIR);
      $fwrite(fd_mtstat, "[%11.3f] TAPE: Preset command completed.\n", $time/1.0e3);
   endtask

   //
   // Erase Command
   // Erase 3 inches of tape at either 800 BPI or 1600 BPI
   // The tape moves at 75 inches per second
   //

   task erase(input [31:0] addrMTDIR);
      int gaps;
      gaps = (mtDIR[`mtDIR_DEN] == mtDEN_1600PE) ? 4800/4 : 2400/4;
      $fwrite(fd_mtstat, "[%11.3f] TAPE: Erase command.\n", $time/1.0e3);
      $fwrite(fd_mtstat, "[%11.3f] TAPE: GAPS is %0d\n", $time/1.0e3, gaps);
      $fflush(fd_mtstat);

      for (int i = 0; i < gaps; i++)
        begin
           #(mtSPD_ERASE * 1ns) writeHeader(h_GAP);
        end
      $fwrite(fd_mtstat, "[%11.3f] TAPE: Erase command completed.\n", $time/1.0e3);
   endtask

   //
   // Write Tape Mark Command
   //

   task wrtm(input [31:0] addrMTDIR);
      $fwrite(fd_mtstat, "[%11.3f] TAPE: Write tape mark command.\n", $time/1.0e3);
      writeHeader(h_TM);
      conWRITE64(addrMTDIR, mtDIR_SETTM);
   endtask

   //
   // Space Forward Command
   //

   task spaceForward(input [31:0] addrMTDIR);
      reg        done;
      reg [31:0] header;

      $fwrite(fd_mtstat, "[%11.3f] TAPE: Space forward command.\n", $time/1.0e3);
      done = 0;

      do
        begin
           header = readHeader();
           if (header == h_GAP)
             begin
                ;
             end
           else if ($feof(fd_tape))
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Physical EOT. Signal EOT.\n", $time/1.0e3);
                conWRITE64(addrMTDIR, mtDIR_SETEOT);
                done = 1;
             end
           else if ((header >= 32'hff00_0000) && (header <= 32'hffff_0000))
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Header Error.\n", $time/1.0e3);
                done = 1;
             end
           else if ((header == h_TM) && !lastTM)
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Found Tape Mark. End of tape file %0d. (obj was %0d, pos was %0d)\n",
                        $time/1.0e3, filcnt, objcnt, $ftell(fd_tape), );
                filcnt += 1;
                objcnt += 1;
                reccnt = 1;
                done = 1;
             end
           else if ((header == h_TM) && lastTM)
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Found Tape Mark. Logical EOT. (obj was %0d, pos was %0d)\n",
                        $time/1.0e3, objcnt, $ftell(fd_tape));
                done = 1;
             end
           else
             begin
                if (lastTM)
                  begin
                     $fwrite(fd_mtstat, "[%11.3f] TAPE: Processing tape file %0d.\n", $time/1.0e3, filcnt);
                  end

                header = header & 32'h0000ffff;

                $fwrite(fd_mtstat, "[%11.3f] TAPE: Start of record. (obj was %0d, pos was %0d, rec was %0d, len was %0d)\n",
                        $time/1.0e3, objcnt, $ftell(fd_tape), reccnt, header);
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Increment Frame Counter.\n", $time/1.0e3);
                conWRITE64(addrMTDIR, mtDIR_INCFC);
                objcnt += 1;
                reccnt += 1;
                void'($fseek(fd_tape, header + 4, SEEK_CUR));
                conREAD64(addrMTDIR, mtDIR);
                waitReadWrite(mtDIR, header);

                if (mtDIR[42]) // WCZ
                  begin
                     $fwrite(fd_mtstat, "[%11.3f] TAPE: Frame Count incremented to zero.\n", $time/1.0e3);
                     done = 1;
                  end
             end

           if (header == h_TM)
             begin
                lastTM = 1;
                conWRITE64(addrMTDIR, mtDIR_SETTM);
             end
           else
             begin
                lastTM = 0;
                conWRITE64(addrMTDIR, mtDIR_CLRTM);
             end

        end
      while (!done);
      #1ms
        $fwrite(fd_mtstat, "[%11.3f] TAPE: Space forward command completed.\n", $time/1.0e3);
   endtask

   //
   // Space Reverse Command
   //

   task spaceReverse(input [31:0] addrMTDIR);
      reg        done;
      reg [31:0] header;

      $fwrite(fd_mtstat, "[%11.3f] TAPE: Space reverse command.\n", $time/1.0e3);
      done = 0;

      do
        begin

           //
           // Check for BOT
           //

           if ($ftell(fd_tape) < 4)
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Space Reverse. Backspaced from BOT.\n", $time/1.0e3);
                break;
             end

           //
           // Seek to previous header
           //

           void'($fseek(fd_tape, -4, SEEK_CUR));
           header = readHeader();
           $fwrite(fd_mtstat, "[%11.3f] TAPE: Header was %0d (0x%08x). (pos was %0d)\n", $time/1.0e3, header, header, $ftell(fd_tape) - 4);
           void'($fseek(fd_tape, -4, SEEK_CUR));

           if (header == h_GAP)
             begin
                ;
             end
           else if ($feof(fd_tape))
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Physical EOT. Signal EOT.\n", $time/1.0e3);
                conWRITE64(addrMTDIR, mtDIR_SETEOT);
                break;
             end
           else if ((header >= 32'hff00_0000) && (header <= 32'hffff_0000))
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Header Error.\n", $time/1.0e3);
                break;
             end
           else if ((header == h_TM) && !lastTM)
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Found Tape Mark. End of tape file %0d. (obj was %0d, pos was %0d)\n",
                        $time/1.0e3, filcnt, objcnt, $ftell(fd_tape), );
                filcnt -= 1;
                objcnt -= 1;
                reccnt = -1;
                lastTM = 1;
                done = 1;
             end
           else if ((header == h_TM) && lastTM)
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Found Tape Mark. Logical EOT. (obj was %0d, pos was %0d)\n",
                        $time/1.0e3, objcnt, $ftell(fd_tape));
                lastTM = 1;
                done = 1;
             end
           else
             begin

                if (lastTM)
                  begin
                     $fwrite(fd_mtstat, "[%11.3f] TAPE: Processing tape file %0d.\n", $time/1.0e3, filcnt);
                  end

                header = header & 32'h0000ffff;

                $fwrite(fd_mtstat, "[%11.3f] TAPE: Start of record. (obj was %0d, pos was %0d, rec was %0d, len was %0d)\n",
                        $time/1.0e3, objcnt, $ftell(fd_tape), reccnt, header);
                conWRITE64(addrMTDIR, mtDIR_INCFC);
                objcnt -= 1;
                reccnt -= 1;

                //
                // Skip reverse over the record data and the header that preceeds the data
                // This should not fail at BOF. We've already validated the tape file.
                //

    `ifdef PARANOID

                if ($ftell(fd_tape) - header - 4 < 0)
                  begin
                     $fwrite(fd_mtstat, "[%11.3f] TAPE: Space Reverse. Would space backward past BOT.\n", $time/1.0e3);
                     done = 1;
                     break;
                  end
                else
                  void'($fseek(fd_tape, -(header + 4), SEEK_CUR));

    `else
                void'($fseek(fd_tape, -(header + 4), SEEK_CUR));
    `endif

                //
                // Simulate delay from tape motion
                //

                conREAD64(addrMTDIR, mtDIR);
                waitReadWrite(mtDIR, header);

                //
                // Done when frame count is incremented to zero
                //

                conREAD64(addrMTDIR, mtDIR);
                if (mtDIR[42]) // WCZ
                  begin
                     $fwrite(fd_mtstat, "[%11.3f] TAPE: Space Reverse. Frame Count incremented to zero.\n", $time/1.0e3);
                     done = 1;
                  end

             end

           if (header == h_TM)
             begin
                lastTM = 1;
                conWRITE64(addrMTDIR, mtDIR_SETTM);
             end
           else
             begin
                lastTM = 0;
                conWRITE64(addrMTDIR, mtDIR_CLRTM);
             end
        end
      while (!done);

      #1ms
        $fwrite(fd_mtstat, "[%11.3f] TAPE: Space reverse command completed.\n", $time/1.0e3);
   endtask

   //
   // Write Check Forward Command
   //

   task writeCheckForward(input [31:0] addrMTDIR);
      $fwrite(fd_mtstat, "[%11.3f] TAPE: Write check forward command.\n", $time/1.0e3);
   endtask

   //
   // Write Check Reverse Command
   //

   task writeCheckReverse(input [31:0] addrMTDIR);
      $fwrite(fd_mtstat, "[%11.3f] TAPE: Write check reverse command.\n", $time/1.0e3);
   endtask

   //
   // Write Forward Command
   //

   task writeForward(input [31:0] addrMTDIR);

      reg [35:0] data;
      int        length;
      int        bpw;
      int        start;
      int        finish;
      int        wordcnt;
      longint    pos;   //FIXME

      $fwrite(fd_mtstat, "[%11.3f] TAPE: Write forward command.\n", $time/1.0e3);
      $fflush(fd_mtstat);

      conREAD64(addrMTDIR, mtDIR);
      bpw = bytes_per_word(mtDIR);


      length = 0;
      wordcnt = 0;

      //
      // Write zero header
      //

      start = $ftell(fd_tape);

      $fwrite(fd_mtstat, "[%11.3f] TAPE: Writing header. (pos is %0d, bpw is %0d.\n", $time/1.0e3, start, bpw);
      writeHeader(0);

      do
        begin

           conREAD64(addrMTDIR, mtDIR);
           if (mtDIR[62])
             begin

                //
                // If the Word Counter is zero, we are done.
                //

                if (mtDIR[43])
                  begin
                     $fwrite(fd_mtstat, "[%11.3f] TAPE: Word Count incremented to zero.\n", $time/1.0e3);
                     $fflush(fd_mtstat);
                     break;
                  end

                //
                // If the Frame Counter is zero, we are done.
                //

                if (mtDIR[42])
                  begin
                     $fwrite(fd_mtstat, "[%11.3f] TAPE: Frame Count incremented to zero.\n", $time/1.0e3);
                     $fflush(fd_mtstat);
                     break;
                  end

                //
                // Increment Frame Counter
                //

                for (int j = 0; j < bpw; j++)
                  begin
                     #1us conWRITE64(addrMTDIR, mtDIR_INCFC | mtDIR_STB);
                     length += 1;
                  end

                //
                // Read the data from the tape controller
                // Negate STB after data is read
                //

                wordcnt += 1;
                data = mtDIR[35:0];
/*FIXME*/       pos = $ftell(fd_tape);
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Write Forward: Data was %06o,,%06o (wordcnt was %0d, pos was %0d, bpw was %0d)\n",
                        $time/1.0e3, data[35:18], data[17:0], wordcnt, $ftell(fd_tape), bpw);
                writeData(data);
/*FIXME*/       void'($fseek(fd_tape, pos+bpw, SEEK_SET));
                conWRITE64(addrMTDIR, 0);

             end
        end
      while (1);

      //
      // Simulate tape speed
      //

      waitReadWrite(mtDIR, length);

      //
      // Update status
      //

      objcnt += 1;
      reccnt += 1;

      //
      // Write the footer
      //

      writeHeader(length);
      finish = $ftell(fd_tape);

      //
      // Rewrite the header
      //

      void'($fseek(fd_tape, start, SEEK_SET));
      writeHeader(length);
      void'($fseek(fd_tape, finish, SEEK_SET));

      $fwrite(fd_mtstat, "[%11.3f] TAPE: Write Forward Done. Pos = %0d. Length = %0d\n", $time/1.0e3, $ftell(fd_tape), length);
      $fflush(fd_mtstat);

   endtask

   //
   // Read Forward Command
   //

   task readForward(input [31:0] addrMTDIR);
      reg done;
      reg [31:0] header;
      reg [63:0] data;
      int        total;
      int        bpw;
      int        wordcnt;
      longint    pos;   //FIXME

      $fwrite(fd_mtstat, "[%11.3f] TAPE: Read forward command.\n", $time/1.0e3);
      bpw = bytes_per_word(mtDIR);
      done = 0;
      total = 0;
      wordcnt = 0;

      do
        begin

           header = readHeader();
           $fwrite(fd_mtstat, "[%11.3f] TAPE: Header was %0d (0x%08x), (pos was %0d)\n", $time/1.0e3, header, header, $ftell(fd_tape) - 4);
           if (header == h_GAP)
             begin
                ;
             end
           else if ($feof(fd_tape))
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Physical EOT. Signal EOT.\n", $time/1.0e3);
                done = 1;
             end
           else if ((header >= 32'hff00_0000) && (header <= 32'hffff_0000))
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Header Error.\n", $time/1.0e3);
                done = 1;
             end
           else if ((header == h_TM) && !lastTM)
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Found Tape Mark. End of tape file %0d. (obj was %0d, pos was %0d)\n",
                        $time/1.0e3, filcnt, objcnt, $ftell(fd_tape), );
                filcnt += 1;
                objcnt += 1;
                reccnt = 1;
                done = 1;
             end
           else if ((header == h_TM) && lastTM)
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Found Tape Mark. Logical EOT. (obj was %0d, pos was %0d)\n",
                        $time/1.0e3, objcnt, $ftell(fd_tape));
                done = 1;
             end
           else
             begin
                if (lastTM)
                  begin
                     $fwrite(fd_mtstat, "[%11.3f] TAPE: Processing tape file %0d.\n", $time/1.0e3, filcnt);
                  end

                lastTM = 0;
                header = header & 32'h0000ffff;

                $fwrite(fd_mtstat, "[%11.3f] TAPE: Start of record. (obj was %0d, pos was %0d, rec was %0d, len was %0d)\n",
                        $time/1.0e3, objcnt, $ftell(fd_tape), reccnt, header);
                objcnt += 1;
                reccnt += 1;
                for (int i = 0; i < header; i += bpw)
                  begin

                     //
                     // Read a word of data from the Tape File and write to Tape Controller
                     //

                     wordcnt += 1;
/*FIXME*/            pos = $ftell(fd_tape);
                     data = {28'b0, readData()};
                     conWRITE64(addrMTDIR, mtDIR_STB | data);

                     $fwrite(fd_mtstat, "[%11.3f] TAPE: Read Forward: Data was %06o,,%06o (wordcnt was %0d, pos was %0d, header was %0d, bpw was %0d)\n",
                             $time/1.0e3, data[35:18], data[17:0], wordcnt, $ftell(fd_tape)-bpw, header, bpw);

/*FIXME*/            void'($fseek(fd_tape, pos+bpw, SEEK_SET));


                     //
                     // Increment the Frame Counter
                     //

                     for (int j = 0; j < bpw; j++)
                       begin
                          #1us conWRITE64(addrMTDIR, mtDIR_INCFC);
                       end

                     total += 1;

                     //
                     // Wait for the Word Count register to increment after strobe command.
                     // Otherwise you will check the Word Count Register (WCZ) before it increments.
                     //

                     conREAD64(addrMTDIR, mtDIR);

                     if (mtDIR[43]) // WCZ
                       begin
                          $fwrite(fd_mtstat, "[%11.3f] TAPE: Word Count incremented to zero.\n", $time/1.0e3);
                          done = 1;
                          break;
                       end

                  end

                //
                // Skip past footer
                //

                header = readHeader();

                //
                // Simulate delay from tape motion
                //

                waitReadWrite(mtDIR, header);
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Read Loop Done.\n", $time/1.0e3);
             end

           if (header == h_TM)
             begin
                lastTM = 1;
                conWRITE64(addrMTDIR, mtDIR_SETTM);
             end
           else
             begin
                lastTM = 0;
                conWRITE64(addrMTDIR, mtDIR_CLRTM);
             end
        end
      while (!done);
      #1ms
        $fwrite(fd_mtstat, "[%11.3f] TAPE: Read forward command completed. Read %0d words.\n", $time/1.0e3, total);

   endtask

   //
   // Read Reverse Command
   //

   task readReverse(input [31:0] addrMTDIR);
      reg done;
      reg [31:0] header;
      reg [63:0] data;
      int        total;
      int        bpw;
      int        wordcnt;

      $fwrite(fd_mtstat, "[%11.3f] TAPE: Read reverse command.\n", $time/1.0e3);
      $fflush(fd_mtstat);

      conREAD64(addrMTDIR, mtDIR);
      bpw = bytes_per_word(mtDIR);

      $fwrite(fd_mtstat, "[%11.3f] TAPE: bits per word = %0d.\n", $time/1.0e3, bpw);

      done = 0;
      total = 0;
      wordcnt = 0;

      do
        begin
           if ($ftell(fd_tape) < 4)
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Read Reverse. Backspaced from BOT.\n", $time/1.0e3);
                break;
             end

           void'($fseek(fd_tape, -4, SEEK_CUR));
           header = readHeader();
           $fwrite(fd_mtstat, "[%11.3f] TAPE: Header was %0d (0x%08x), (pos = %0d)\n",
                   $time/1.0e3, header, header, $ftell(fd_tape) - 4);
           void'($fseek(fd_tape, -4, SEEK_CUR));

           if (header == h_GAP)
             begin
                continue;
             end
           else if ($feof(fd_tape))
               begin
                  $fwrite(fd_mtstat, "[%11.3f] TAPE: Physical EOT. Signal EOT.\n", $time/1.0e3);
                  conWRITE64(addrMTDIR, mtDIR_SETEOT);
                  done = 1;
               end
           else if ((header >= 32'hff00_0000) && (header <= 32'hffff_0000))
               begin
                  $fwrite(fd_mtstat, "[%11.3f] TAPE: Header Error.\n", $time/1.0e3);
                  done = 1;
               end
           else if ((header == h_TM) && !lastTM)
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Found Tape Mark. End of tape file %0d. (obj was %0d, pos was %0d)\n",
                        $time/1.0e3, filcnt, objcnt, $ftell(fd_tape), );
                filcnt -= 1;
                objcnt -= 1;
                reccnt = -1;
                done = 1;
             end
           else if ((header == h_TM) && lastTM)
             begin
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Found Tape Mark. Logical EOT. (obj was %0d, pos was %0d)\n",
                        $time/1.0e3, objcnt, $ftell(fd_tape));
                done = 1;
             end
           else
             begin
                if (lastTM)
                  begin
                     $fwrite(fd_mtstat, "[%11.3f] TAPE: Processing tape file %0d.\n", $time/1.0e3, filcnt);
                  end

                header = header & 32'h0000ffff;

                //
                // Read data from file then strobe it into the tape controller.
                // The strobe will increment the MTBA and MTWC registers. Wait
                // a microsecond for the before checking Word Count Zero (WCZ).
                // If WCZ is asserted, we are done.
                //
                // In CORDMP mode, the frame counter is incremented 5 times.
                // In COMPAT mode, the frame counter is incremented 4 times.
                //

                 $fwrite(fd_mtstat, "[%11.3f] TAPE: Start of record. (obj was %0d, pos was %0d, rec was %0d, len was %0d)\n",
                        $time/1.0e3, objcnt, $ftell(fd_tape), reccnt, header);
                objcnt -= 1;
                reccnt -= 1;

                for (int i = 0; i < header; i += bpw)
                  begin

                     //
                     // Check for beginning of file
                     //

                     if ($ftell(fd_tape) < 4)
                       begin
                          $fwrite(fd_mtstat, "[%11.3f] TAPE: Read Reverse. Backspaced from BOT reading data.\n", $time/1.0e3);
                          break;
                       end

                     //
                     // Read a word of data from the Tape File and write to Tape Controller
                     //

                     wordcnt += 1;
                     void'($fseek(fd_tape, -bpw, SEEK_CUR));
                     data = {28'b0, readData()};
                     conWRITE64(addrMTDIR, mtDIR_STB | data);
                     void'($fseek(fd_tape, -bpw, SEEK_CUR));
                     $fwrite(fd_mtstat, "[%11.3f] TAPE: Read Reverse: Data was %06o,,%06o (wordcnt was %0d, pos was %0d, header was %0d, bpw was %0d)\n",
                             $time/1.0e3, data[35:18], data[17:0], wordcnt, $ftell(fd_tape), header, bpw);

                     //
                     // Increment the Frame Counter
                     //

                     for (int j = 0; j < bpw; j++)
                       begin
                          #1us conWRITE64(addrMTDIR, mtDIR_INCFC);
                       end
                     total += 1;

                     //
                     // Wait for a short time for the Frame Count and Word Counter
                     // to increment then check the Word Counter. If the Word
                     // Counter is zero, we are done.
                     //

                     conREAD64(addrMTDIR, mtDIR);
                     if (mtDIR[43]) // WCZ
                       begin
                          $fwrite(fd_mtstat, "[%11.3f] TAPE: Word Count incremented to zero.\n", $time/1.0e3);
                          done = 1;
                          break;
                       end
                  end

                //
                // Skip post-record header
                // This should not fail at BOF. We've already validated the tape file.
                //

                void'($fseek(fd_tape, -4, SEEK_CUR));
                header = readHeader();
                void'($fseek(fd_tape, -4, SEEK_CUR));

                //
                // Simulate delay from tape motion
                //

                waitReadWrite(mtDIR, header);
                $fwrite(fd_mtstat, "[%11.3f] TAPE: Read Loop Done.\n", $time/1.0e3);
             end

           if (header == h_TM)
             begin
                lastTM = 1;
                conWRITE64(addrMTDIR, mtDIR_SETTM);
             end
           else
             begin
                lastTM = 0;
                conWRITE64(addrMTDIR, mtDIR_CLRTM);
             end

        end
      while (!done);

      $fwrite(fd_mtstat, "[%11.3f] TAPE: Read reverse command completed.\n", $time/1.0e3);
   endtask

   //
   // Task to Initialize the MT simulator
   //

   task mtSIM_INIT();
      objcnt = 1;
      reccnt = 1;
      filcnt = 1;
      lastTM = 1;

      //
      // Open tape file
      //

      fd_tape = $fopen(`UNIT0_TAP, "r+b");
      if (fd_tape == 0)
        begin
           $display("[%11.3f] TAPE: MTSIM - Unable to open \"%s\" on unit 0.", $time/1.0e3, `UNIT0_TAP);
           $stop;
        end
      $display("[%11.3f] TAPE: MTSIM - Opened \"%s\" on unit 0.", $time/1.0e3, `UNIT0_TAP);

      //
      // Open MT simulator transcript file
      //

      fd_mtstat = $fopen("mtstatus.txt", "w");
      if (fd_mtstat == 0)
        begin
           $display("[%11.3f] TAPE: MTSIM - Unable to open \"mtstatus.txt\".", $time/1.0e3);
           $stop;
        end
      $display("[%11.3f] TAPE: MTSIM - Opened \"mtstatus.txt\".", $time/1.0e3);
      $fwrite(fd_mtstat, "[%11.3f] TAPE: Initialized successfully.\n",  $time/1.0e3);

   endtask;

   //
   // MT Simulator
   //

   task mtSIM_RUN(input [31:0] addrMTDIR);
      reg [63:0] mtDIR;

      begin

         conREAD64(addrMTDIR, mtDIR);

         if (!mtDIR[60])
           begin
              $fwrite(fd_mtstat, "[%11.3f] TAPE: Got GO.\n", $time/1.0e3);
              $fflush(fd_mtstat);
              case (mtDIR[`mtDIR_FUN])
                5'o00: nop(addrMTDIR);
                5'o01: unload(addrMTDIR);
                5'o03: rewind(addrMTDIR);
                5'o10: preset(addrMTDIR);
                5'o12: erase(addrMTDIR);
                5'o13: wrtm(addrMTDIR);
                5'o14: spaceForward(addrMTDIR);
                5'o15: spaceReverse(addrMTDIR);
                5'o24: writeCheckForward(addrMTDIR);
                5'o27: writeCheckReverse(addrMTDIR);
                5'o30: writeForward(addrMTDIR);
                5'o34: readForward(addrMTDIR);
                5'o37: readReverse(addrMTDIR);
                default: $fwrite(fd_mtstat, "[%11.3f] TAPE: WTF FUN=%o.\n", $time/1.0e3, mtDIR[52:48]);
              endcase
              $fwrite(fd_mtstat, "[%11.3f] TAPE: Debug ----> pos = %0d\n", $time/1.0e3, $ftell(fd_tape));
              #100us
                if ($ftell(fd_tape) == 0)
                  begin
                     $fwrite(fd_mtstat, "[%11.3f] TAPE: AT BOT\n", $time/1.0e3);
                     conWRITE64(addrMTDIR, mtDIR_SETBOT | mtDIR_READY);
                  end
                else
                  begin
                     $fwrite(fd_mtstat, "[%11.3f] TAPE: NOT AT BOT\n", $time/1.0e3);
                     conWRITE64(addrMTDIR, mtDIR_CLRBOT | mtDIR_READY);
                  end
              $fflush(fd_mtstat);
           end

      end
   endtask

