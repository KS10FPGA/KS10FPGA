
module testbench;

   reg clk;
   reg rst;

   wire cpuCONT;
   wire cpuHALT;
   wire cpuRUN;

   //
   // Initialization
   //
   
   initial
     begin
        $display("KS10 Simulation Starting");
        clk = 1'b0;             // initial state of clock
        rst = 1'b1;             // initial state of reset
        #95 rst = 1'b0;         // release reset at 95 nS
     end

   //
   // Clock generator
   //
   
   always
     #10 clk = ~clk;            // clock is inverted every ten nS

   //
   // UUT
   //
   
   CPU UUT(.clk(clk),
           .rst(rst),
           .clken(1'b1),
           .consTIMEREN(1'b1),
           .consSTEP(1'b0),
           .consRUN(1'b1),
           .consEXEC(1'b1),
           .consCONT(1'b1),
           .consTRAPEN(1'b1),
           .consCACHEEN(1'b0),
           .intPWR(intPWR),
           .intCONS(intCONS),
           .bus_data_in(),
           .bus_data_out(),
           .bus_pi_req_in(),
           .bus_pi_req_out(),
           .bus_pi_current(),
           .cpuCONT(cpuCONT),
           .cpuHALT(cpuHALT),
           .cpuRUN(cpuRUN),
           .crom(),
           .dp(),
           .pageNUMBER());

   //
   // Display of Processor Status
   //
   
   reg lastHALT;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          lastHALT = 1'b0;
        else
          begin
             if (cpuHALT & ~lastHALT)
               $display("KS10 CPU Halted at t = %f us", $time / 1.0e3);
             else if (~cpuHALT & lastHALT)
               $display("KS10 CPU Unhalted at t = %f us.", $time / 1.0e3);
             lastHALT = cpuHALT;
          end
     end
   
endmodule
