
module testbench;

   reg clk;
   reg rst;

   initial
     begin
        $display($time, " << Starting the Simulation >>");
        clk = 1'b0;     	// initial state of clock
        rst = 1'b1;     	// initial state of reset
        #91 rst = 1'b0;        // release reset at 90 nS
     end
   
   always
     #10 clk = ~clk;    	// invert every ten nS

   KS10 UUT(.clk(clk),
            .rst(rst),
            .clken(1'b1),
            .cons_run(1'b1),
            .cons_msec_en(1'b1),
            .cons_exec(1'b1),
            .cons_cont(1'b1),
            .consTRAPEN(1'b1),
            .bus_ac_lo(1'b0),
            .crom(),
            .t());

endmodule
