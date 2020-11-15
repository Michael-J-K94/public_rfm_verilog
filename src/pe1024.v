// pe1024: recursive priority encoder based; Automatically generated
// Ameer Abedlhadi ; April 2014 - The University of British Columbia
// i: 1024, l2i: 10, l4i: 5
module pe1024(input clk, input rst, input [1024-1:0] oht, output [10-1:0] bin, output vld);
  // recursive calls for four narrower (fourth the inout width) priority encoders
  wire [10-3:0] binI[3:0];
  wire [   3:0] vldI     ;
  pe256 pe256_in0(clk, rst, oht[  1024/4-1:0        ],binI[0],vldI[0]);
  pe256 pe256_in1(clk, rst, oht[  1024/2-1:  1024/4 ],binI[1],vldI[1]);
  pe256 pe256_in2(clk, rst, oht[3*1024/4-1:  1024/2 ],binI[2],vldI[2]);
  pe256 pe256_in3(clk, rst, oht[  1024  -1:3*1024/4 ],binI[3],vldI[3]);
  // register input priority encoders outputs if pipelining is required; otherwise assign only
  wire [10-3:0] binII[3:0];
  wire [   3:0] vldII     ;
  reg  [10-3:0] binIR[3:0];
  reg  [   3:0] vldIR     ;
  always @(posedge clk, posedge rst)
    if (rst) {binIR[3],binIR[2],binIR[1],binIR[0],vldIR} <= {(4*(10-1)){1'b0}};
    else     {binIR[3],binIR[2],binIR[1],binIR[0],vldIR} <= {binI[3],binI[2],binI[1],binI[0],vldI};
  assign {binII[3],binII[2],binII[1],binII[0],vldII} = {binIR[3],binIR[2],binIR[1],binIR[0],vldIR};
  // output pe4 to generate indices from valid bits
  pe4 pe4_out0(clk,rst,vldII,bin[10-1:10-2],vld);
  // a 4->1 mux to steer indices from the narrower pe's
  reg [10-3:0] binO;
  always @(*)
    case (bin[10-1:10-2])
      2'b00: binO = binII[0];
      2'b01: binO = binII[1];
      2'b10: binO = binII[2];
      2'b11: binO = binII[3];
  endcase
  assign bin[10-3:0] = binO;
endmodule
