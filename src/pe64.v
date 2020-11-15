// pe64: recursive priority encoder based; Automatically generated
// Ameer Abedlhadi ; April 2014 - The University of British Columbia
// i: 64, l2i: 6, l4i: 3
module pe64(input clk, input rst, input [64-1:0] oht, output [6-1:0] bin, output vld);
  // recursive calls for four narrower (fourth the inout width) priority encoders
  wire [6-3:0] binI[3:0];
  wire [   3:0] vldI     ;
  pe16 pe16_in0(clk, rst, oht[  64/4-1:0        ],binI[0],vldI[0]);
  pe16 pe16_in1(clk, rst, oht[  64/2-1:  64/4 ],binI[1],vldI[1]);
  pe16 pe16_in2(clk, rst, oht[3*64/4-1:  64/2 ],binI[2],vldI[2]);
  pe16 pe16_in3(clk, rst, oht[  64  -1:3*64/4 ],binI[3],vldI[3]);
  // register input priority encoders outputs if pipelining is required; otherwise assign only
  wire [6-3:0] binII[3:0];
  wire [   3:0] vldII     ;
  reg  [6-3:0] binIR[3:0];
  reg  [   3:0] vldIR     ;
  always @(posedge clk, posedge rst)
    if (rst) {binIR[3],binIR[2],binIR[1],binIR[0],vldIR} <= {(4*(6-1)){1'b0}};
    else     {binIR[3],binIR[2],binIR[1],binIR[0],vldIR} <= {binI[3],binI[2],binI[1],binI[0],vldI};
  assign {binII[3],binII[2],binII[1],binII[0],vldII} = {binIR[3],binIR[2],binIR[1],binIR[0],vldIR};
  // output pe4 to generate indices from valid bits
  pe4 pe4_out0(clk,rst,vldII,bin[6-1:6-2],vld);
  // a 4->1 mux to steer indices from the narrower pe's
  reg [6-3:0] binO;
  always @(*)
    case (bin[6-1:6-2])
      2'b00: binO = binII[0];
      2'b01: binO = binII[1];
      2'b10: binO = binII[2];
      2'b11: binO = binII[3];
  endcase
  assign bin[6-3:0] = binO;
endmodule
