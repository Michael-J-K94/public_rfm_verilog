`timescale 1ns / 1ps

module rfm_unit_bank
#(
  parameter NUM_ENTRY = 64,
  parameter NUM_ENTRY_BITS = 6, // log2 (NUM_ENTRY)
  parameter RFM_TH = 8,
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
reg [ADDR_SIZE-1:0] act_addr_reg;
reg rfm_cmd_reg;

integer iter;

// RFM Table
reg [ADDR_SIZE-1:0] addr_table [0:NUM_ENTRY-1];
wire [NUM_ENTRY-1:0] addr_matches;
reg [CNT_SIZE-1:0] cnt_table [0:NUM_ENTRY-1];
//wire [NUM_ENTRY-1:0] cnt_matches;
wire [NUM_ENTRY-1:0] cnt_min_matches;
wire [NUM_ENTRY-1:0] cnt_max_matches;
reg [CNT_SIZE-1:0] spcnt;
reg [CNT_SIZE-1:0] max_cnt;
wire [CNT_SIZE-1:0] next_max_cnt;
reg [ADDR_SIZE-1:0] max_addr;
wire [NUM_ENTRY_BITS-1:0] hit_idx;
wire [NUM_ENTRY_BITS-1:0] min_idx;
wire [NUM_ENTRY_BITS-1:0] max_idx;
wire table_hit;
wire min_hit;
reg act_update_end;
reg act_update_end_d1;
reg find_max_end;
reg max_update_end;
reg [NUM_ENTRY_BITS:0] tail_idx;
wire full;

assign full = (tail_idx == NUM_ENTRY);

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
        if(act_update_end) begin
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

// Main
always @(posedge clk or negedge rstn) begin
  if(!rstn) begin
    for(iter=0;iter<NUM_ENTRY;iter=iter+1) begin
      addr_table[iter] <= {ADDR_SIZE{1'b1}};
      cnt_table[iter] <= {ADDR_SIZE{1'b0}};
    end
    spcnt <= {CNT_SIZE{1'b0}};
    max_cnt <= {CNT_SIZE{1'b0}};
    max_addr <= {ADDR_SIZE{1'b0}};
    act_update_end_d1 <= 1'b0;
    find_max_end <= 1'b0;
    max_update_end <= 1'b0;
    tail_idx <= {CNT_SIZE{1'b0}};
  end
  else begin
    case(state)
      STATE_IDLE: begin
        nrr_cmd <= 1'b0;
        nrr_addr <= {ADDR_SIZE{1'b0}};
        act_update_end_d1 <= 1'b0;
        find_max_end <= 1'b0;
        max_update_end <= 1'b0;
      end

      STATE_ACT: begin
        act_update_end_d1 <= 1'b1;
        if(act_update_end) begin
          if(table_hit) begin
            cnt_table[hit_idx] <= cnt_table[hit_idx] + 1;
            if(cnt_table[hit_idx] + 1 > max_cnt) begin
              max_cnt <= cnt_table[hit_idx] + 1;
            end
          end
          else begin
            if(spcnt + 1 > max_cnt) begin
              max_cnt <= spcnt + 1;
            end
            if(~full) begin
              addr_table[tail_idx] <= act_addr_reg;
              cnt_table[tail_idx] <= 1;
              tail_idx <= tail_idx + 1;
            end
            else if(min_hit) begin
              addr_table[min_idx] <= act_addr_reg;
              cnt_table[min_idx] <= spcnt + 1;
            end
            else begin
              spcnt <= spcnt + 1;
            end
          end
        end
      end
    
      STATE_RFM: begin
        find_max_end <= 1'b1;
        if(find_max_end) begin
          cnt_table[max_idx] <= spcnt;
          nrr_cmd <= 1'b1;
          nrr_addr <= addr_table[max_idx];
          max_update_end <= 1'b1;
        end
        if(max_update_end) begin
          max_cnt <= next_max_cnt;
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


// Delays
always @(posedge clk or negedge rstn) begin
  if(!rstn) begin
    act_update_end <= 1'b0;
  end
  else begin
    act_update_end <= act_update_end_d1;
  end
end

// Address Table CAM
// Need to optimize (jhpark)
genvar i;
generate
  for (i = 0; i < NUM_ENTRY; i=i+1) begin: addr_cam
    assign addr_matches[i] = ~(|(addr_table[i]^act_addr_reg));   // 0: hit, 1: miss
  end
endgenerate


// Count Table CAM (MIN)
// Need to optimize (jhpark), CAM 세 개 합쳐보기
generate
  for (i = 0; i < NUM_ENTRY; i=i+1) begin: cnt_min_cam
//    assign cnt_matches[i] = (state == STATE_RFM) ? |(cnt_table[i]^max_cnt) : |(cnt_table[i]^spcnt);   // 0: hit, 1: miss
    assign cnt_min_matches[i] = ~(|(cnt_table[i]^spcnt));   // 0: hit, 1: miss
  end
endgenerate


// Count Table CAM (MAX)
// Need to optimize (jhpark)
generate
  for (i = 0; i < NUM_ENTRY; i=i+1) begin: cnt_max_cam
    assign cnt_max_matches[i] = ~(|(cnt_table[i]^max_cnt));   // 0: hit, 1: miss
  end
endgenerate



// pe for CAMs
pe_cam pe_addr
(
  .clk(clk),
  .rst(~rstn),
  .oht(addr_matches),
  .bin(hit_idx),
  .vld(table_hit)
);

pe_cam pe_min
(
  .clk(clk),
  .rst(~rstn),
  .oht(cnt_min_matches),
  .bin(min_idx),
  .vld(min_hit)
);

pe_cam pe_max
(
  .clk(clk),
  .rst(~rstn),
  .oht(cnt_max_matches),
  .bin(max_idx),
  .vld()
);


// Unit for Finding Max in RFM
// Need to optimize (jhpark)
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

assign max_0_0_0_0_0  = (cnt_table[0]  > cnt_table[1])  ? cnt_table[0]  : cnt_table[1];
assign max_0_0_0_0_1  = (cnt_table[2]  > cnt_table[3])  ? cnt_table[2]  : cnt_table[3];
assign max_0_0_0_1_0  = (cnt_table[4]  > cnt_table[5])  ? cnt_table[4]  : cnt_table[5];
assign max_0_0_0_1_1  = (cnt_table[6]  > cnt_table[7])  ? cnt_table[6]  : cnt_table[7];
assign max_0_0_1_0_0  = (cnt_table[8]  > cnt_table[9])  ? cnt_table[8]  : cnt_table[9];
assign max_0_0_1_0_1  = (cnt_table[10] > cnt_table[11]) ? cnt_table[10] : cnt_table[11];
assign max_0_0_1_1_0  = (cnt_table[12] > cnt_table[13]) ? cnt_table[12] : cnt_table[13];
assign max_0_0_1_1_1  = (cnt_table[14] > cnt_table[15]) ? cnt_table[14] : cnt_table[15];
assign max_0_1_0_0_0  = (cnt_table[16] > cnt_table[17]) ? cnt_table[16] : cnt_table[17];
assign max_0_1_0_0_1  = (cnt_table[18] > cnt_table[19]) ? cnt_table[18] : cnt_table[19];
assign max_0_1_0_1_0  = (cnt_table[20]  > cnt_table[21])  ? cnt_table[20]  : cnt_table[21];
assign max_0_1_0_1_1  = (cnt_table[22]  > cnt_table[23])  ? cnt_table[22]  : cnt_table[23];
assign max_0_1_1_0_0  = (cnt_table[24]  > cnt_table[25])  ? cnt_table[24]  : cnt_table[25];
assign max_0_1_1_0_1  = (cnt_table[26]  > cnt_table[27])  ? cnt_table[26]  : cnt_table[27];
assign max_0_1_1_1_0  = (cnt_table[28]  > cnt_table[29])  ? cnt_table[28]  : cnt_table[29];
assign max_0_1_1_1_1  = (cnt_table[30]  > cnt_table[31])  ? cnt_table[30]  : cnt_table[31];
assign max_1_0_0_0_0  = (cnt_table[32]  > cnt_table[33])  ? cnt_table[32]  : cnt_table[33];
assign max_1_0_0_0_1  = (cnt_table[34]  > cnt_table[35])  ? cnt_table[34]  : cnt_table[35];
assign max_1_0_0_1_0  = (cnt_table[36]  > cnt_table[37])  ? cnt_table[36]  : cnt_table[37];
assign max_1_0_0_1_1  = (cnt_table[38]  > cnt_table[39])  ? cnt_table[38]  : cnt_table[39];
assign max_1_0_1_0_0  = (cnt_table[40]  > cnt_table[41])  ? cnt_table[40]  : cnt_table[41];
assign max_1_0_1_0_1  = (cnt_table[42]  > cnt_table[43])  ? cnt_table[42]  : cnt_table[43];
assign max_1_0_1_1_0  = (cnt_table[44]  > cnt_table[45])  ? cnt_table[44]  : cnt_table[45];
assign max_1_0_1_1_1  = (cnt_table[46]  > cnt_table[47])  ? cnt_table[46]  : cnt_table[47];
assign max_1_1_0_0_0  = (cnt_table[48]  > cnt_table[49])  ? cnt_table[48]  : cnt_table[49];
assign max_1_1_0_0_1  = (cnt_table[40]  > cnt_table[51])  ? cnt_table[50]  : cnt_table[51];
assign max_1_1_0_1_0  = (cnt_table[52]  > cnt_table[53])  ? cnt_table[52]  : cnt_table[53];
assign max_1_1_0_1_1  = (cnt_table[54]  > cnt_table[55])  ? cnt_table[54]  : cnt_table[55];
assign max_1_1_1_0_0  = (cnt_table[56]  > cnt_table[57])  ? cnt_table[56]  : cnt_table[57];
assign max_1_1_1_0_1  = (cnt_table[58]  > cnt_table[59])  ? cnt_table[58]  : cnt_table[59];
assign max_1_1_1_1_0  = (cnt_table[60]  > cnt_table[61])  ? cnt_table[60]  : cnt_table[61];
assign max_1_1_1_1_1  = (cnt_table[62]  > cnt_table[63])  ? cnt_table[62]  : cnt_table[63];

endmodule
