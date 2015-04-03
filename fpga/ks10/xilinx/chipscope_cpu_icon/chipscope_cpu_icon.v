///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2015 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 13.3
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : chipscope_cpu_icon.v
// /___/   /\     Timestamp  : Wed Feb 18 12:34:47 US Mountain Standard Time 2015
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module chipscope_cpu_icon(
    CONTROL0,
    CONTROL1);


inout [35 : 0] CONTROL0;
inout [35 : 0] CONTROL1;

endmodule
