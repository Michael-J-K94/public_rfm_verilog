`timescale 1ns / 1ps

module rfm_unit_bank
#(
  parameter NUM_ENTRY = 64,
  parameter NUM_ENTRY_BITS = 6, // log2 (NUM_ENTRY)
  parameter RFM_TH = 20,
  parameter ADDR_SIZE = 18,
  parameter CNT_SIZE = 32
)
(
  input clk,
  input rstn,
  input act_cmd,
  input [ADDR_SIZE-1:0] act_addr,
  input rfm_cmd,

  output reg nrr_cmd,
  output reg [ADDR_SIZE-1:0] nrr_addr
);

// Paramters for FSM states
localparam STATE_IDLE  = 4'd0;
localparam STATE_ACT   = 4'd1;
localparam STATE_RFM   = 4'd2;

// Finite State Machine
reg [3:0] state;
reg [3:0] prev_state;
reg [ADDR_SIZE-1:0] act_addr_reg;
reg rfm_cmd_reg;

integer iter;

// RFM Table
//reg [ADDR_SIZE-1:0] addr_table [0:NUM_ENTRY-1];
//wire [NUM_ENTRY-1:0] addr_matches;
//reg [CNT_SIZE-1:0] cnt_table [0:NUM_ENTRY-1];
//wire [NUM_ENTRY-1:0] cnt_matches;

reg [CNT_SIZE-1:0] spcnt;
reg [CNT_SIZE-1:0] max_cnt;
wire [CNT_SIZE-1:0] next_max_cnt;
reg [ADDR_SIZE-1:0] max_addr;
wire [NUM_ENTRY_BITS-1:0] hit_addr_idx;
wire [NUM_ENTRY_BITS-1:0] hit_cnt_idx;

wire table_hit;
wire cnt_hit;
wire act_cmd_d1;
reg act_cmd_d2;
reg act_cmd_d3;
wire rfm_cmd_d1;
reg rfm_cmd_d2;
reg rfm_cmd_d3;
reg rfm_cmd_d4;
reg max_update_end;
reg max_en;







/* ADDRESS CAM */
wire [ADDR_SIZE-1:0] addr_cam_data_in;
wire [NUM_ENTRY_BITS-1:0] addr_cam_addr_in;
wire addr_cam_read_en;
wire addr_cam_write_en;
wire addr_cam_search_en;
wire addr_cam_reset;
wire [ADDR_SIZE-1:0] addr_cam_data_out;
wire [NUM_ENTRY_BITS-1:0] addr_cam_addr_out;
wire addr_cam_match;

/* COUNT CAM */
wire [CNT_SIZE-1:0] cnt_cam_data_in;
wire [NUM_ENTRY_BITS-1:0] cnt_cam_addr_in;
wire cnt_cam_read_en;
wire cnt_cam_write_en;
wire cnt_cam_search_en;
wire cnt_cam_reset;
wire [CNT_SIZE-1:0] cnt_cam_data_out;
wire [NUM_ENTRY_BITS-1:0] cnt_cam_addr_out;
wire cnt_cam_match;






// Finite State Machine
always @(posedge clk or negedge rstn) begin
  if(!rstn) begin
    state <= STATE_IDLE;
  end
  else begin
    case(state)
      STATE_IDLE: begin
        if(act_cmd) begin
          state <= STATE_ACT;
        end
        else if(rfm_cmd) begin
          state <= STATE_RFM;
        end
        else begin
          state <= STATE_IDLE;
        end
      end
      STATE_ACT: begin
        if(act_cmd_d3) begin
          state <= STATE_IDLE;
        end
        else begin
          state <= STATE_ACT;
        end
      end
      STATE_RFM: begin
        if(max_update_end) begin
          state <= STATE_IDLE;
        end
        else begin
          state <= STATE_RFM;
        end
      end
      default: begin
        state <= STATE_IDLE;
      end
    endcase
  end
end

// Table Management
always @(posedge clk or negedge rstn) begin
  if(!rstn) begin
    for(iter=0;iter<NUM_ENTRY;iter=iter+1) begin
//      addr_table[iter] <= {ADDR_SIZE{1'b0}};
//      cnt_table[iter] <= {ADDR_SIZE{1'b0}};
    end
    spcnt <= {CNT_SIZE{1'b0}};
    max_cnt <= {CNT_SIZE{1'b0}};
    max_addr <= {ADDR_SIZE{1'b0}};
    max_update_end <= 1'b0;
  end
  else begin
    case(state)
      STATE_IDLE: begin
        nrr_cmd <= 1'b0;
        nrr_addr <= {ADDR_SIZE{1'b0}};
        max_update_end <= 1'b0;
      end

      STATE_ACT: begin
        if(act_cmd_d2) begin
          if(table_hit) begin
//            cnt_table[hit_addr_idx] <= cnt_table[hit_addr_idx] + 1;
//            if(cnt_table[hit_addr_idx] + 1 > max_cnt) begin
            if(cnt_cam_data_out + 1 > max_cnt) begin
              max_cnt <= cnt_cam_data_out + 1;
            end
          end
          else begin
            if(spcnt + 1 > max_cnt) begin
              max_cnt <= spcnt + 1;
            end
            if(cnt_hit) begin
//              addr_table[hit_cnt_idx] <= act_addr_reg;
//              cnt_table[hit_cnt_idx] <= spcnt + 1;
            end
            else begin
              spcnt <= spcnt + 1;
            end
          end
        end
      end
    
      STATE_RFM: begin
        if(rfm_cmd_d4) begin
//          cnt_table[hit_cnt_idx] <= spcnt;
          nrr_cmd <= 1'b1;
          //nrr_addr <= addr_table[hit_cnt_idx];
          nrr_addr <= addr_cam_data_out;
          max_update_end <= 1'b1;
          max_en <= 1'b1;
        end
        if(max_update_end) begin
          max_en <= 1'b0;
          max_cnt <= next_max_cnt;
          max_update_end <= 1'b0;
        end
      end
    endcase
  end
end


// ACT Address Save
always @(posedge clk or negedge rstn) begin
  if(!rstn) begin
    act_addr_reg <= {ADDR_SIZE{1'b1}};
  end
  else begin
    if(state == STATE_ACT) begin
      act_addr_reg <= act_addr_reg;
    end
    else begin
      act_addr_reg <= act_addr;
    end
  end
end


// Commands
assign act_cmd_d1 = (state == STATE_ACT && prev_state == STATE_IDLE) ? 1'b1 : 1'b0;
assign rfm_cmd_d1 = (state == STATE_RFM && prev_state == STATE_IDLE) ? 1'b1 : 1'b0;

// Delays
always @(posedge clk or negedge rstn) begin
  if(!rstn) begin
    prev_state <= 4'b0;
    act_cmd_d2 <= 1'b0;
    rfm_cmd_d2 <= 1'b0;
    rfm_cmd_d3 <= 1'b0;
    rfm_cmd_d4 <= 1'b0;
  end
  else begin
    prev_state <= state;
    act_cmd_d2 <= act_cmd_d1;
    act_cmd_d3 <= act_cmd_d2;
    rfm_cmd_d2 <= rfm_cmd_d1;
    rfm_cmd_d3 <= rfm_cmd_d2;
    rfm_cmd_d4 <= rfm_cmd_d3;
  end
end




assign hit_addr_idx = addr_cam_addr_out;
assign table_hit = addr_cam_match;

assign hit_cnt_idx = cnt_cam_addr_out;
assign cnt_hit     = cnt_cam_match;


/* ADDR CAM SIGNALS */
assign addr_cam_data_in   = act_addr_reg;
assign addr_cam_addr_in   = hit_cnt_idx;
assign addr_cam_read_en   =  (state == STATE_RFM) && rfm_cmd_d4;
assign addr_cam_write_en  =  (state == STATE_ACT) && act_cmd_d3 && ~table_hit && cnt_hit;
assign addr_cam_search_en =  (state == STATE_ACT) && act_cmd_d1;
assign addr_cam_reset     = ~rstn;

/* COUNT CAM SIGNALS */
assign cnt_cam_data_in    = ((state == STATE_ACT) && act_cmd_d1)               ? spcnt                :
                             (state == STATE_RFM) && rfm_cmd_d3                ? max_cnt              :
                             (state == STATE_RFM) && rfm_cmd_d4                ? spcnt                :
                             (state == STATE_ACT) && act_cmd_d3 && table_hit   ? cnt_cam_data_out + 1 : 
                                                                                 spcnt + 1;
assign cnt_cam_addr_in    =  (state == STATE_ACT) &&               table_hit   ? hit_addr_idx         : 
                                                                                 hit_cnt_idx;
assign cnt_cam_read_en    =  (state == STATE_ACT) && act_cmd_d2 && table_hit;
assign cnt_cam_write_en   =  (state == STATE_RFM) && rfm_cmd_d4 ||
                            ((state == STATE_ACT) && act_cmd_d3 && (table_hit ||
                                                                   (~table_hit && cnt_hit)));
assign cnt_cam_search_en  = ((state == STATE_ACT) && act_cmd_d1) || 
                             (state == STATE_RFM) && rfm_cmd_d3;
assign cnt_cam_reset      = ~rstn;





/* CAM INSTANTIATION */
addr_cam #(.WORD_SIZE(ADDR_SIZE), .ROW_NUM(NUM_ENTRY), .ENTRY_WIDTH(NUM_ENTRY_BITS)) addr_cam (addr_cam_data_in, addr_cam_addr_in, addr_cam_read_en, addr_cam_write_en, addr_cam_search_en,
  addr_cam_reset, addr_cam_data_out, addr_cam_addr_out, addr_cam_match);

cnt_cam #(.WORD_SIZE(CNT_SIZE), .ROW_NUM(NUM_ENTRY), .ENTRY_WIDTH(NUM_ENTRY_BITS)) cnt_cam (cnt_cam_data_in, cnt_cam_addr_in, cnt_cam_read_en, cnt_cam_write_en, cnt_cam_search_en, cnt_cam_reset, cnt_cam_data_out, cnt_cam_addr_out, cnt_cam_match, clk, rstn, max_en, next_max_cnt);



// Address Table CAM
// Need to optimize (jhpark)
genvar i;
/*
generate
  for (i = 0; i < NUM_ENTRY; i=i+1) begin: addr_cam
    assign addr_matches[i] = ~(|(addr_table[i]^act_addr_reg));   // 0: hit, 1: miss
  end
endgenerate
*/


/*
// Count Table CAM
// Need to optimize (jhpark)
generate
  for (i = 0; i < NUM_ENTRY; i=i+1) begin: cnt_min_cam
    assign cnt_matches[i] = (state == STATE_RFM) ? ~|(cnt_table[i]^max_cnt) : ~|(cnt_table[i]^spcnt);   // 0: hit, 1: miss
  end
endgenerate
*/

/*
// pe for CAMs
pe_cam pe_addr
(
  .clk(clk),
  .rst(~rstn),
  .oht(addr_matches),
  .bin(hit_addr_idx),
  .vld(table_hit)
);
*/

/*
pe_cam pe_cnt
(
  .clk(clk),
  .rst(~rstn),
  .oht(cnt_matches),
  .bin(hit_cnt_idx),
  .vld(cnt_hit)
);
*/
/*
pe_cam pe_max
(
  .clk(clk),
  .rst(~rstn),
  .oht(cnt_max_matches),
  .bin(max_idx),
  .vld()
);
*/

// Unit for Finding Max in RFM
// Need to optimize (jhpark)

/*
max_64
#(
  .NUM_ENTRY (NUM_ENTRY),
  .CNT_SIZE  (CNT_SIZE)
)
finding_max
(
  .clk(clk),
  .rstn(rstn),
  .cnt_table_0(cnt_table[0]),
  .cnt_table_1(cnt_table[1]),
  .cnt_table_2(cnt_table[2]),
  .cnt_table_3(cnt_table[3]),
  .cnt_table_4(cnt_table[4]),
  .cnt_table_5(cnt_table[5]),
  .cnt_table_6(cnt_table[6]),
  .cnt_table_7(cnt_table[7]),
  .cnt_table_8(cnt_table[8]),
  .cnt_table_9(cnt_table[9]),
  .cnt_table_10(cnt_table[10]),
  .cnt_table_11(cnt_table[11]),
  .cnt_table_12(cnt_table[12]),
  .cnt_table_13(cnt_table[13]),
  .cnt_table_14(cnt_table[14]),
  .cnt_table_15(cnt_table[15]),
  .cnt_table_16(cnt_table[16]),
  .cnt_table_17(cnt_table[17]),
  .cnt_table_18(cnt_table[18]),
  .cnt_table_19(cnt_table[19]),
  .cnt_table_20(cnt_table[20]),
  .cnt_table_21(cnt_table[21]),
  .cnt_table_22(cnt_table[22]),
  .cnt_table_23(cnt_table[23]),
  .cnt_table_24(cnt_table[24]),
  .cnt_table_25(cnt_table[25]),
  .cnt_table_26(cnt_table[26]),
  .cnt_table_27(cnt_table[27]),
  .cnt_table_28(cnt_table[28]),
  .cnt_table_29(cnt_table[29]),
  .cnt_table_30(cnt_table[30]),
  .cnt_table_31(cnt_table[31]),
  .cnt_table_32(cnt_table[32]),
  .cnt_table_33(cnt_table[33]),
  .cnt_table_34(cnt_table[34]),
  .cnt_table_35(cnt_table[35]),
  .cnt_table_36(cnt_table[36]),
  .cnt_table_37(cnt_table[37]),
  .cnt_table_38(cnt_table[38]),
  .cnt_table_39(cnt_table[39]),
  .cnt_table_40(cnt_table[40]),
  .cnt_table_41(cnt_table[41]),
  .cnt_table_42(cnt_table[42]),
  .cnt_table_43(cnt_table[43]),
  .cnt_table_44(cnt_table[44]),
  .cnt_table_45(cnt_table[45]),
  .cnt_table_46(cnt_table[46]),
  .cnt_table_47(cnt_table[47]),
  .cnt_table_48(cnt_table[48]),
  .cnt_table_49(cnt_table[49]),
  .cnt_table_50(cnt_table[50]),
  .cnt_table_51(cnt_table[51]),
  .cnt_table_52(cnt_table[52]),
  .cnt_table_53(cnt_table[53]),
  .cnt_table_54(cnt_table[54]),
  .cnt_table_55(cnt_table[55]),
  .cnt_table_56(cnt_table[56]),
  .cnt_table_57(cnt_table[57]),
  .cnt_table_58(cnt_table[58]),
  .cnt_table_59(cnt_table[59]),
  .cnt_table_60(cnt_table[60]),
  .cnt_table_61(cnt_table[61]),
  .cnt_table_62(cnt_table[62]),
  .cnt_table_63(cnt_table[63]),
  .next_max_cnt(next_max_cnt)
);
*/

endmodule
