// pe_cam.v: priority encoder top module file
// Automatically generated for priority encoder design
// Ameer Abedlhadi; April 2014 - University of British Columbia

module pe_cam(input clk, input rst, input [64-1:0] oht, output [6-1:0] bin, output vld);
  // register input (oht)
  reg [64-1:0] ohtR;
  always @(posedge clk, posedge rst)
    if (rst) ohtR <= {64{1'b0}};
    else    ohtR <= oht;
  wire [6-1:0] binII;
  wire          vldI ;
  // instantiate peiority encoder
  pe64 pe64_0(clk,rst,ohtR,binII,vldI);
  // register outputs (bin, vld)
  reg [6-1:0] binIIR;
  reg          vldIR ;
  always @(posedge clk, posedge rst)
    if (rst) {binIIR,vldIR} <= {(6+1){1'b0}};
    else    {binIIR,vldIR} <= {binII,vldI};
  assign {bin,vld} = {binIIR,vldIR};
endmodule
