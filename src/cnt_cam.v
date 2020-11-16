module cnt_cam (data_in, addr_in, read_en, write_en, search_en, reset, data_out, addr_out, match, clk, rstn, max_en, max);

parameter WORD_SIZE = 16;
parameter ENTRY_WIDTH = 7; // [log2(ROW_NUM)]
parameter ROW_NUM = 68;

input [WORD_SIZE-1:0] data_in;
input [ENTRY_WIDTH-1:0] addr_in;
input read_en, write_en, search_en;
input reset;

output [WORD_SIZE-1:0] data_out;
output [ENTRY_WIDTH-1:0] addr_out;
output match;


wire we_array [ROW_NUM-1:0];
wire [WORD_SIZE-1:0] data_array [0:ROW_NUM-1];
wire [ROW_NUM-1:0] match_array;

wire [WORD_SIZE-1:0] data_in_tmp;
assign data_in_tmp = reset ? 0 : data_in;

genvar i;
generate for (i = 0; i < ROW_NUM; i = i+1) begin: larray_inst
          assign we_array[i] = reset? 1 : write_en & (addr_in == i);
    latch_array #(.WORD_SIZE(WORD_SIZE)) latch_array_(.data_in(data_in_tmp), .write_en(we_array[i]), .search_en(search_en), .data_out(data_array[i]), .match(match_array[i]));
  end
endgenerate

assign data_out = read_en ? data_array[addr_in] : data_out;

encoder #(.ROW_NUM(ROW_NUM), .ENTRY_WIDTH(ENTRY_WIDTH)) encoder_ (match_array, match, addr_out);




/*  Find Max   */
input clk;
input rstn;
input max_en;
output [WORD_SIZE-1:0] max;

wire [WORD_SIZE-1:0] max_0;
wire [WORD_SIZE-1:0] max_1;
wire [WORD_SIZE-1:0] max_0_0;
wire [WORD_SIZE-1:0] max_0_1;
wire [WORD_SIZE-1:0] max_1_0;
wire [WORD_SIZE-1:0] max_1_1;
wire [WORD_SIZE-1:0] max_0_0_0;
wire [WORD_SIZE-1:0] max_0_0_1;
wire [WORD_SIZE-1:0] max_0_1_0;
wire [WORD_SIZE-1:0] max_0_1_1;
wire [WORD_SIZE-1:0] max_1_0_0;
wire [WORD_SIZE-1:0] max_1_0_1;
wire [WORD_SIZE-1:0] max_1_1_0;
wire [WORD_SIZE-1:0] max_1_1_1;
wire [WORD_SIZE-1:0] max_0_0_0_0;
wire [WORD_SIZE-1:0] max_0_0_0_1;
wire [WORD_SIZE-1:0] max_0_0_1_0;
wire [WORD_SIZE-1:0] max_0_0_1_1;
wire [WORD_SIZE-1:0] max_0_1_0_0;
wire [WORD_SIZE-1:0] max_0_1_0_1;
wire [WORD_SIZE-1:0] max_0_1_1_0;
wire [WORD_SIZE-1:0] max_0_1_1_1;
wire [WORD_SIZE-1:0] max_1_0_0_0;
wire [WORD_SIZE-1:0] max_1_0_0_1;
wire [WORD_SIZE-1:0] max_1_0_1_0;
wire [WORD_SIZE-1:0] max_1_0_1_1;
wire [WORD_SIZE-1:0] max_1_1_0_0;
wire [WORD_SIZE-1:0] max_1_1_0_1;
wire [WORD_SIZE-1:0] max_1_1_1_0;
wire [WORD_SIZE-1:0] max_1_1_1_1;
wire [WORD_SIZE-1:0] max_0_0_0_0_0;
wire [WORD_SIZE-1:0] max_0_0_0_0_1;
wire [WORD_SIZE-1:0] max_0_0_0_1_0;
wire [WORD_SIZE-1:0] max_0_0_0_1_1;
wire [WORD_SIZE-1:0] max_0_0_1_0_0;
wire [WORD_SIZE-1:0] max_0_0_1_0_1;
wire [WORD_SIZE-1:0] max_0_0_1_1_0;
wire [WORD_SIZE-1:0] max_0_0_1_1_1;
wire [WORD_SIZE-1:0] max_0_1_0_0_0;
wire [WORD_SIZE-1:0] max_0_1_0_0_1;
wire [WORD_SIZE-1:0] max_0_1_0_1_0;
wire [WORD_SIZE-1:0] max_0_1_0_1_1;
wire [WORD_SIZE-1:0] max_0_1_1_0_0;
wire [WORD_SIZE-1:0] max_0_1_1_0_1;
wire [WORD_SIZE-1:0] max_0_1_1_1_0;
wire [WORD_SIZE-1:0] max_0_1_1_1_1;
wire [WORD_SIZE-1:0] max_1_0_0_0_0;
wire [WORD_SIZE-1:0] max_1_0_0_0_1;
wire [WORD_SIZE-1:0] max_1_0_0_1_0;
wire [WORD_SIZE-1:0] max_1_0_0_1_1;
wire [WORD_SIZE-1:0] max_1_0_1_0_0;
wire [WORD_SIZE-1:0] max_1_0_1_0_1;
wire [WORD_SIZE-1:0] max_1_0_1_1_0;
wire [WORD_SIZE-1:0] max_1_0_1_1_1;
wire [WORD_SIZE-1:0] max_1_1_0_0_0;
wire [WORD_SIZE-1:0] max_1_1_0_0_1;
wire [WORD_SIZE-1:0] max_1_1_0_1_0;
wire [WORD_SIZE-1:0] max_1_1_0_1_1;
wire [WORD_SIZE-1:0] max_1_1_1_0_0;
wire [WORD_SIZE-1:0] max_1_1_1_0_1;
wire [WORD_SIZE-1:0] max_1_1_1_1_0;
wire [WORD_SIZE-1:0] max_1_1_1_1_1;

assign max          = (max_0 > max_1) ? max_0 : max_1;
assign max_0        = (max_0_0 > max_0_1) ? max_0_0 : max_0_1;
assign max_1        = (max_1_0 > max_1_1) ? max_1_0 : max_1_1;
assign max_0_0      = (max_0_0_0 > max_0_0_1) ? max_0_0_0 : max_0_0_1;
assign max_0_1      = (max_0_1_0 > max_0_1_1) ? max_0_1_0 : max_0_1_1;
assign max_1_0      = (max_1_0_0 > max_1_0_1) ? max_1_0_0 : max_1_0_1;
assign max_1_1      = (max_1_1_0 > max_1_1_1) ? max_1_1_0 : max_1_1_1;

assign max_0_0_0    = (max_0_0_0_0 > max_0_0_0_1) ? max_0_0_0_0 : max_0_0_0_1;
assign max_0_0_1    = (max_0_0_1_0 > max_0_0_1_1) ? max_0_0_1_0 : max_0_0_1_1;
assign max_0_1_0    = (max_0_1_0_0 > max_0_1_0_1) ? max_0_1_0_0 : max_0_1_0_1;
assign max_0_1_1    = (max_0_1_1_0 > max_0_1_1_1) ? max_0_1_1_0 : max_0_1_1_1;
assign max_1_0_0    = (max_1_0_0_0 > max_1_0_0_1) ? max_1_0_0_0 : max_1_0_0_1;
assign max_1_0_1    = (max_1_0_1_0 > max_1_0_1_1) ? max_1_0_1_0 : max_1_0_1_1;
assign max_1_1_0    = (max_1_1_0_0 > max_1_1_0_1) ? max_1_1_0_0 : max_1_1_0_1;
assign max_1_1_1    = (max_1_1_1_0 > max_1_1_1_1) ? max_1_1_1_0 : max_1_1_1_1;

assign max_0_0_0_0    = (max_0_0_0_0_0 > max_0_0_0_0_1) ? max_0_0_0_0_0 : max_0_0_0_0_1;
assign max_0_0_0_1    = (max_0_0_0_1_0 > max_0_0_0_1_1) ? max_0_0_0_1_0 : max_0_0_0_1_1;
assign max_0_0_1_0    = (max_0_0_1_0_0 > max_0_0_1_0_1) ? max_0_0_1_0_0 : max_0_0_1_0_1;
assign max_0_0_1_1    = (max_0_0_1_1_0 > max_0_0_1_1_1) ? max_0_0_1_1_0 : max_0_0_1_1_1;
assign max_0_1_0_0    = (max_0_1_0_0_0 > max_0_1_0_0_1) ? max_0_1_0_0_0 : max_0_1_0_0_1;
assign max_0_1_0_1    = (max_0_1_0_1_0 > max_0_1_0_1_1) ? max_0_1_0_1_0 : max_0_1_0_1_1;
assign max_0_1_1_0    = (max_0_1_1_0_0 > max_0_1_1_0_1) ? max_0_1_1_0_0 : max_0_1_1_0_1;
assign max_0_1_1_1    = (max_0_1_1_1_0 > max_0_1_1_1_1) ? max_0_1_1_1_0 : max_0_1_1_1_1;
assign max_1_0_0_0    = (max_1_0_0_0_0 > max_1_0_0_0_1) ? max_1_0_0_0_0 : max_1_0_0_0_1;
assign max_1_0_0_1    = (max_1_0_0_1_0 > max_1_0_0_1_1) ? max_1_0_0_1_0 : max_1_0_0_1_1;
assign max_1_0_1_0    = (max_1_0_1_0_0 > max_1_0_1_0_1) ? max_1_0_1_0_0 : max_1_0_1_0_1;
assign max_1_0_1_1    = (max_1_0_1_1_0 > max_1_0_1_1_1) ? max_1_0_1_1_0 : max_1_0_1_1_1;
assign max_1_1_0_0    = (max_1_1_0_0_0 > max_1_1_0_0_1) ? max_1_1_0_0_0 : max_1_1_0_0_1;
assign max_1_1_0_1    = (max_1_1_0_1_0 > max_1_1_0_1_1) ? max_1_1_0_1_0 : max_1_1_0_1_1;
assign max_1_1_1_0    = (max_1_1_1_0_0 > max_1_1_1_0_1) ? max_1_1_1_0_0 : max_1_1_1_0_1;
assign max_1_1_1_1    = (max_1_1_1_1_0 > max_1_1_1_1_1) ? max_1_1_1_1_0 : max_1_1_1_1_1;

assign max_0_0_0_0_0  = (data_array[0]  > data_array[1])   ? data_array[0]   : data_array[1];
assign max_0_0_0_0_1  = (data_array[2]  > data_array[3])   ? data_array[2]   : data_array[3];
assign max_0_0_0_1_0  = (data_array[4]  > data_array[5])   ? data_array[4]   : data_array[5];
assign max_0_0_0_1_1  = (data_array[6]  > data_array[7])   ? data_array[6]   : data_array[7];
assign max_0_0_1_0_0  = (data_array[8]  > data_array[9])   ? data_array[8]   : data_array[9];
assign max_0_0_1_0_1  = (data_array[10] > data_array[11])  ? data_array[10]  : data_array[11];
assign max_0_0_1_1_0  = (data_array[12] > data_array[13])  ? data_array[12]  : data_array[13];
assign max_0_0_1_1_1  = (data_array[14] > data_array[15])  ? data_array[14]  : data_array[15];
assign max_0_1_0_0_0  = (data_array[16] > data_array[17])  ? data_array[16]  : data_array[17];
assign max_0_1_0_0_1  = (data_array[18] > data_array[19])  ? data_array[18]  : data_array[19];
assign max_0_1_0_1_0  = (data_array[20] > data_array[21])  ? data_array[20]  : data_array[21];
assign max_0_1_0_1_1  = (data_array[22] > data_array[23])  ? data_array[22]  : data_array[23];
assign max_0_1_1_0_0  = (data_array[24] > data_array[25])  ? data_array[24]  : data_array[25];
assign max_0_1_1_0_1  = (data_array[26] > data_array[27])  ? data_array[26]  : data_array[27];
assign max_0_1_1_1_0  = (data_array[28] > data_array[29])  ? data_array[28]  : data_array[29];
assign max_0_1_1_1_1  = (data_array[30] > data_array[31])  ? data_array[30]  : data_array[31];
assign max_1_0_0_0_0  = (data_array[32] > data_array[33])  ? data_array[32]  : data_array[33];
assign max_1_0_0_0_1  = (data_array[34] > data_array[35])  ? data_array[34]  : data_array[35];
assign max_1_0_0_1_0  = (data_array[36] > data_array[37])  ? data_array[36]  : data_array[37];
assign max_1_0_0_1_1  = (data_array[38] > data_array[39])  ? data_array[38]  : data_array[39];
assign max_1_0_1_0_0  = (data_array[40] > data_array[41])  ? data_array[40]  : data_array[41];
assign max_1_0_1_0_1  = (data_array[42] > data_array[43])  ? data_array[42]  : data_array[43];
assign max_1_0_1_1_0  = (data_array[44] > data_array[45])  ? data_array[44]  : data_array[45];
assign max_1_0_1_1_1  = (data_array[46] > data_array[47])  ? data_array[46]  : data_array[47];
assign max_1_1_0_0_0  = (data_array[48] > data_array[49])  ? data_array[48]  : data_array[49];
assign max_1_1_0_0_1  = (data_array[40] > data_array[51])  ? data_array[50]  : data_array[51];
assign max_1_1_0_1_0  = (data_array[52] > data_array[53])  ? data_array[52]  : data_array[53];
assign max_1_1_0_1_1  = (data_array[54] > data_array[55])  ? data_array[54]  : data_array[55];
assign max_1_1_1_0_0  = (data_array[56] > data_array[57])  ? data_array[56]  : data_array[57];
assign max_1_1_1_0_1  = (data_array[58] > data_array[59])  ? data_array[58]  : data_array[59];
assign max_1_1_1_1_0  = (data_array[60] > data_array[61])  ? data_array[60]  : data_array[61];
assign max_1_1_1_1_1  = (data_array[62] > data_array[63])  ? data_array[62]  : data_array[63];


endmodule

