// pe16: recursive priority encoder based; Automatically generated
// Ameer Abedlhadi ; April 2014 - The University of British Columbia
// i: 16, l2i: 4, l4i: 2
module pe16(input clk, input rst, input [16-1:0] oht, output [4-1:0] bin, output vld);
  // recursive calls for four narrower (fourth the inout width) priority encoders
  wire [4-3:0] binI[3:0];
  wire [   3:0] vldI     ;
  pe4 pe4_in0(clk, rst, oht[  16/4-1:0        ],binI[0],vldI[0]);
  pe4 pe4_in1(clk, rst, oht[  16/2-1:  16/4 ],binI[1],vldI[1]);
  pe4 pe4_in2(clk, rst, oht[3*16/4-1:  16/2 ],binI[2],vldI[2]);
  pe4 pe4_in3(clk, rst, oht[  16  -1:3*16/4 ],binI[3],vldI[3]);
  // register input priority encoders outputs if pipelining is required; otherwise assign only
  wire [4-3:0] binII[3:0];
  wire [   3:0] vldII     ;
  assign {binII[3],binII[2],binII[1],binII[0],vldII} = {binI[3],binI[2],binI[1],binI[0],vldI};
  // output pe4 to generate indices from valid bits
  pe4 pe4_out0(clk,rst,vldII,bin[4-1:4-2],vld);
  // a 4->1 mux to steer indices from the narrower pe's
  reg [4-3:0] binO;
  always @(*)
    case (bin[4-1:4-2])
      2'b00: binO = binII[0];
      2'b01: binO = binII[1];
      2'b10: binO = binII[2];
      2'b11: binO = binII[3];
  endcase
  assign bin[4-3:0] = binO;
endmodule
