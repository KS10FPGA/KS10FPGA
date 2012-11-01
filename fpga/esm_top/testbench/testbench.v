
module testbench;

   reg clk;
   reg rst;

   initial
     begin
        $display($time, " << Starting the Simulation >>");
        clk = 1'b0;     	// initial state of clock
        rst = 1'b1;     	// initial state of reset
        #95 rst = 1'b0;        // release reset at 95 nS
     end
   
   always
     #10 clk = ~clk;    	// invert every ten nS

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
           .crom(),
           .dp(),
           .pageNUMBER());

endmodule
