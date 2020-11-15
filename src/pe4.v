// pe4: recursive priority encoder based; Automatically generated
// Ameer Abedlhadi ; April 2014 - The University of British Columbia
// i: 4, l2i: 2, l4i: 1
module pe4(input clk, input rst, input [4-1:0] oht, output [2-1:0] bin, output vld);
  assign {bin,vld} = {!(oht[0]||oht[1]),!oht[0]&&(oht[1]||!oht[2]),|oht};
endmodule
