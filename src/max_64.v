module max_64
#(
  parameter NUM_ENTRY = 64,
  parameter CNT_SIZE = 32
)
(
  input clk,
  input rstn,
  input [CNT_SIZE-1:0] cnt_table_0,
  input [CNT_SIZE-1:0] cnt_table_1,
  input [CNT_SIZE-1:0] cnt_table_2,
  input [CNT_SIZE-1:0] cnt_table_3,
  input [CNT_SIZE-1:0] cnt_table_4,
  input [CNT_SIZE-1:0] cnt_table_5,
  input [CNT_SIZE-1:0] cnt_table_6,
  input [CNT_SIZE-1:0] cnt_table_7,
  input [CNT_SIZE-1:0] cnt_table_8,
  input [CNT_SIZE-1:0] cnt_table_9,
  input [CNT_SIZE-1:0] cnt_table_10,
  input [CNT_SIZE-1:0] cnt_table_11,
  input [CNT_SIZE-1:0] cnt_table_12,
  input [CNT_SIZE-1:0] cnt_table_13,
  input [CNT_SIZE-1:0] cnt_table_14,
  input [CNT_SIZE-1:0] cnt_table_15,
  input [CNT_SIZE-1:0] cnt_table_16,
  input [CNT_SIZE-1:0] cnt_table_17,
  input [CNT_SIZE-1:0] cnt_table_18,
  input [CNT_SIZE-1:0] cnt_table_19,
  input [CNT_SIZE-1:0] cnt_table_20,
  input [CNT_SIZE-1:0] cnt_table_21,
  input [CNT_SIZE-1:0] cnt_table_22,
  input [CNT_SIZE-1:0] cnt_table_23,
  input [CNT_SIZE-1:0] cnt_table_24,
  input [CNT_SIZE-1:0] cnt_table_25,
  input [CNT_SIZE-1:0] cnt_table_26,
  input [CNT_SIZE-1:0] cnt_table_27,
  input [CNT_SIZE-1:0] cnt_table_28,
  input [CNT_SIZE-1:0] cnt_table_29,
  input [CNT_SIZE-1:0] cnt_table_30,
  input [CNT_SIZE-1:0] cnt_table_31,
  input [CNT_SIZE-1:0] cnt_table_32,
  input [CNT_SIZE-1:0] cnt_table_33,
  input [CNT_SIZE-1:0] cnt_table_34,
  input [CNT_SIZE-1:0] cnt_table_35,
  input [CNT_SIZE-1:0] cnt_table_36,
  input [CNT_SIZE-1:0] cnt_table_37,
  input [CNT_SIZE-1:0] cnt_table_38,
  input [CNT_SIZE-1:0] cnt_table_39,
  input [CNT_SIZE-1:0] cnt_table_40,
  input [CNT_SIZE-1:0] cnt_table_41,
  input [CNT_SIZE-1:0] cnt_table_42,
  input [CNT_SIZE-1:0] cnt_table_43,
  input [CNT_SIZE-1:0] cnt_table_44,
  input [CNT_SIZE-1:0] cnt_table_45,
  input [CNT_SIZE-1:0] cnt_table_46,
  input [CNT_SIZE-1:0] cnt_table_47,
  input [CNT_SIZE-1:0] cnt_table_48,
  input [CNT_SIZE-1:0] cnt_table_49,
  input [CNT_SIZE-1:0] cnt_table_50,
  input [CNT_SIZE-1:0] cnt_table_51,
  input [CNT_SIZE-1:0] cnt_table_52,
  input [CNT_SIZE-1:0] cnt_table_53,
  input [CNT_SIZE-1:0] cnt_table_54,
  input [CNT_SIZE-1:0] cnt_table_55,
  input [CNT_SIZE-1:0] cnt_table_56,
  input [CNT_SIZE-1:0] cnt_table_57,
  input [CNT_SIZE-1:0] cnt_table_58,
  input [CNT_SIZE-1:0] cnt_table_59,
  input [CNT_SIZE-1:0] cnt_table_60,
  input [CNT_SIZE-1:0] cnt_table_61,
  input [CNT_SIZE-1:0] cnt_table_62,
  input [CNT_SIZE-1:0] cnt_table_63,

  output [CNT_SIZE-1:0] next_max_cnt
);


wire [CNT_SIZE-1:0] max_0;
wire [CNT_SIZE-1:0] max_1;
wire [CNT_SIZE-1:0] max_0_0;
wire [CNT_SIZE-1:0] max_0_1;
wire [CNT_SIZE-1:0] max_1_0;
wire [CNT_SIZE-1:0] max_1_1;
wire [CNT_SIZE-1:0] max_0_0_0;
wire [CNT_SIZE-1:0] max_0_0_1;
wire [CNT_SIZE-1:0] max_0_1_0;
wire [CNT_SIZE-1:0] max_0_1_1;
wire [CNT_SIZE-1:0] max_1_0_0;
wire [CNT_SIZE-1:0] max_1_0_1;
wire [CNT_SIZE-1:0] max_1_1_0;
wire [CNT_SIZE-1:0] max_1_1_1;
wire [CNT_SIZE-1:0] max_0_0_0_0;
wire [CNT_SIZE-1:0] max_0_0_0_1;
wire [CNT_SIZE-1:0] max_0_0_1_0;
wire [CNT_SIZE-1:0] max_0_0_1_1;
wire [CNT_SIZE-1:0] max_0_1_0_0;
wire [CNT_SIZE-1:0] max_0_1_0_1;
wire [CNT_SIZE-1:0] max_0_1_1_0;
wire [CNT_SIZE-1:0] max_0_1_1_1;
wire [CNT_SIZE-1:0] max_1_0_0_0;
wire [CNT_SIZE-1:0] max_1_0_0_1;
wire [CNT_SIZE-1:0] max_1_0_1_0;
wire [CNT_SIZE-1:0] max_1_0_1_1;
wire [CNT_SIZE-1:0] max_1_1_0_0;
wire [CNT_SIZE-1:0] max_1_1_0_1;
wire [CNT_SIZE-1:0] max_1_1_1_0;
wire [CNT_SIZE-1:0] max_1_1_1_1;
wire [CNT_SIZE-1:0] max_0_0_0_0_0;
wire [CNT_SIZE-1:0] max_0_0_0_0_1;
wire [CNT_SIZE-1:0] max_0_0_0_1_0;
wire [CNT_SIZE-1:0] max_0_0_0_1_1;
wire [CNT_SIZE-1:0] max_0_0_1_0_0;
wire [CNT_SIZE-1:0] max_0_0_1_0_1;
wire [CNT_SIZE-1:0] max_0_0_1_1_0;
wire [CNT_SIZE-1:0] max_0_0_1_1_1;
wire [CNT_SIZE-1:0] max_0_1_0_0_0;
wire [CNT_SIZE-1:0] max_0_1_0_0_1;
wire [CNT_SIZE-1:0] max_0_1_0_1_0;
wire [CNT_SIZE-1:0] max_0_1_0_1_1;
wire [CNT_SIZE-1:0] max_0_1_1_0_0;
wire [CNT_SIZE-1:0] max_0_1_1_0_1;
wire [CNT_SIZE-1:0] max_0_1_1_1_0;
wire [CNT_SIZE-1:0] max_0_1_1_1_1;
wire [CNT_SIZE-1:0] max_1_0_0_0_0;
wire [CNT_SIZE-1:0] max_1_0_0_0_1;
wire [CNT_SIZE-1:0] max_1_0_0_1_0;
wire [CNT_SIZE-1:0] max_1_0_0_1_1;
wire [CNT_SIZE-1:0] max_1_0_1_0_0;
wire [CNT_SIZE-1:0] max_1_0_1_0_1;
wire [CNT_SIZE-1:0] max_1_0_1_1_0;
wire [CNT_SIZE-1:0] max_1_0_1_1_1;
wire [CNT_SIZE-1:0] max_1_1_0_0_0;
wire [CNT_SIZE-1:0] max_1_1_0_0_1;
wire [CNT_SIZE-1:0] max_1_1_0_1_0;
wire [CNT_SIZE-1:0] max_1_1_0_1_1;
wire [CNT_SIZE-1:0] max_1_1_1_0_0;
wire [CNT_SIZE-1:0] max_1_1_1_0_1;
wire [CNT_SIZE-1:0] max_1_1_1_1_0;
wire [CNT_SIZE-1:0] max_1_1_1_1_1;

assign next_max_cnt = (max_0 > max_1) ? max_0 : max_1;
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

assign max_0_0_0_0_0  = (cnt_table_0  > cnt_table_1)  ? cnt_table_0  : cnt_table_1;
assign max_0_0_0_0_1  = (cnt_table_2  > cnt_table_3)  ? cnt_table_2  : cnt_table_3;
assign max_0_0_0_1_0  = (cnt_table_4  > cnt_table_5)  ? cnt_table_4  : cnt_table_5;
assign max_0_0_0_1_1  = (cnt_table_6  > cnt_table_7)  ? cnt_table_6  : cnt_table_7;
assign max_0_0_1_0_0  = (cnt_table_8  > cnt_table_9)  ? cnt_table_8  : cnt_table_9;
assign max_0_0_1_0_1  = (cnt_table_10 > cnt_table_11) ? cnt_table_10 : cnt_table_11;
assign max_0_0_1_1_0  = (cnt_table_12 > cnt_table_13) ? cnt_table_12 : cnt_table_13;
assign max_0_0_1_1_1  = (cnt_table_14 > cnt_table_15) ? cnt_table_14 : cnt_table_15;
assign max_0_1_0_0_0  = (cnt_table_16 > cnt_table_17) ? cnt_table_16 : cnt_table_17;
assign max_0_1_0_0_1  = (cnt_table_18 > cnt_table_19) ? cnt_table_18 : cnt_table_19;
assign max_0_1_0_1_0  = (cnt_table_20  > cnt_table_21)  ? cnt_table_20  : cnt_table_21;
assign max_0_1_0_1_1  = (cnt_table_22  > cnt_table_23)  ? cnt_table_22  : cnt_table_23;
assign max_0_1_1_0_0  = (cnt_table_24  > cnt_table_25)  ? cnt_table_24  : cnt_table_25;
assign max_0_1_1_0_1  = (cnt_table_26  > cnt_table_27)  ? cnt_table_26  : cnt_table_27;
assign max_0_1_1_1_0  = (cnt_table_28  > cnt_table_29)  ? cnt_table_28  : cnt_table_29;
assign max_0_1_1_1_1  = (cnt_table_30  > cnt_table_31)  ? cnt_table_30  : cnt_table_31;
assign max_1_0_0_0_0  = (cnt_table_32  > cnt_table_33)  ? cnt_table_32  : cnt_table_33;
assign max_1_0_0_0_1  = (cnt_table_34  > cnt_table_35)  ? cnt_table_34  : cnt_table_35;
assign max_1_0_0_1_0  = (cnt_table_36  > cnt_table_37)  ? cnt_table_36  : cnt_table_37;
assign max_1_0_0_1_1  = (cnt_table_38  > cnt_table_39)  ? cnt_table_38  : cnt_table_39;
assign max_1_0_1_0_0  = (cnt_table_40  > cnt_table_41)  ? cnt_table_40  : cnt_table_41;
assign max_1_0_1_0_1  = (cnt_table_42  > cnt_table_43)  ? cnt_table_42  : cnt_table_43;
assign max_1_0_1_1_0  = (cnt_table_44  > cnt_table_45)  ? cnt_table_44  : cnt_table_45;
assign max_1_0_1_1_1  = (cnt_table_46  > cnt_table_47)  ? cnt_table_46  : cnt_table_47;
assign max_1_1_0_0_0  = (cnt_table_48  > cnt_table_49)  ? cnt_table_48  : cnt_table_49;
assign max_1_1_0_0_1  = (cnt_table_40  > cnt_table_51)  ? cnt_table_50  : cnt_table_51;
assign max_1_1_0_1_0  = (cnt_table_52  > cnt_table_53)  ? cnt_table_52  : cnt_table_53;
assign max_1_1_0_1_1  = (cnt_table_54  > cnt_table_55)  ? cnt_table_54  : cnt_table_55;
assign max_1_1_1_0_0  = (cnt_table_56  > cnt_table_57)  ? cnt_table_56  : cnt_table_57;
assign max_1_1_1_0_1  = (cnt_table_58  > cnt_table_59)  ? cnt_table_58  : cnt_table_59;
assign max_1_1_1_1_0  = (cnt_table_60  > cnt_table_61)  ? cnt_table_60  : cnt_table_61;
assign max_1_1_1_1_1  = (cnt_table_62  > cnt_table_63)  ? cnt_table_62  : cnt_table_63;


endmodule
