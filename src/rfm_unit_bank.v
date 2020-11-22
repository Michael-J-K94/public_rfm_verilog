`timescale 1ns / 1ps

module rfm_unit_bank
#(
  parameter NUM_ENTRY = 64,
  parameter NUM_ENTRY_BITS = 6, // log2 (NUM_ENTRY)
  parameter RFM_TH = 4,
  parameter ADDR_SIZE = 18,
  parameter CNT_SIZE = 5
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


reg [CNT_SIZE-1:0] spcnt;
reg [CNT_SIZE-1:0] max_cnt;
wire [CNT_SIZE-1:0] next_max_cnt;
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
reg rfm_cmd_d5;
reg rfm_cmd_d6;
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
        if(rfm_cmd_d6) begin
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


// Spillover Count
always @(posedge clk or negedge rstn) begin
  if(!rstn) begin
    spcnt <= {CNT_SIZE{1'b0}};
  end
  else if ((state == STATE_ACT) && act_cmd_d2 && ~table_hit && ~cnt_hit) begin
    spcnt <= spcnt + 1;
  end
  else begin
    spcnt <= spcnt;
  end
end

// Maximum Count
always @(posedge clk or negedge rstn) begin
  if(!rstn) begin
    max_cnt <= {CNT_SIZE{1'b0}};
  end
  else if ((state == STATE_ACT) && act_cmd_d2 && table_hit && (cnt_cam_data_out + 1 > max_cnt)) begin
    max_cnt <= cnt_cam_data_out + 1;
  end
  else if ((state == STATE_ACT) && act_cmd_d2 && ~table_hit && (spcnt + 1 > max_cnt)) begin
    max_cnt <= spcnt + 1;
  end
  else if ((state == STATE_RFM) && rfm_cmd_d6) begin
    max_cnt <= next_max_cnt;
  end
  else begin
    max_cnt <= max_cnt;
  end
end


// Near Row Refresh
always @(posedge clk) begin
  if ((state == STATE_RFM) && act_cmd_d2) begin
    nrr_cmd <= 1'b1;
    nrr_addr <= addr_cam_data_out;
  end
  else begin
    nrr_cmd <= 1'b0;
    nrr_addr <= {ADDR_SIZE{1'b0}};
  end
end



// Finding Next Max

always @(posedge clk or negedge rstn) begin
  if(~rstn) begin
    max_en <= 1'b0;
  end
  else begin
    if (state == STATE_RFM) begin
      if(rfm_cmd_d2) begin
        max_en <= 1'b1;
      end
      if(rfm_cmd_d6) begin
        max_en <= 1'b0;
      end
    end
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
    rfm_cmd_d5 <= 1'b0;
    rfm_cmd_d6 <= 1'b0;
  end
  else begin
    prev_state <= state;
    act_cmd_d2 <= act_cmd_d1;
    act_cmd_d3 <= act_cmd_d2;
    rfm_cmd_d2 <= rfm_cmd_d1;
    rfm_cmd_d3 <= rfm_cmd_d2;
    rfm_cmd_d4 <= rfm_cmd_d3;
    rfm_cmd_d5 <= rfm_cmd_d4;
    rfm_cmd_d6 <= rfm_cmd_d5;
  end
end




assign hit_addr_idx = addr_cam_addr_out;
assign table_hit = addr_cam_match;

assign hit_cnt_idx = cnt_cam_addr_out;
assign cnt_hit     = cnt_cam_match;


/* ADDR CAM SIGNALS */
assign addr_cam_data_in   = act_addr_reg;
assign addr_cam_addr_in   = hit_cnt_idx;
assign addr_cam_read_en   =  (state == STATE_RFM) && rfm_cmd_d2;
assign addr_cam_write_en  =  (state == STATE_ACT) && act_cmd_d3 && ~table_hit && cnt_hit;
assign addr_cam_search_en =  (state == STATE_ACT) && act_cmd_d1;
assign addr_cam_reset     = ~rstn;

/* COUNT CAM SIGNALS */
assign cnt_cam_data_in    = ((state == STATE_ACT) && act_cmd_d1)               ? spcnt                :
                             (state == STATE_RFM) && rfm_cmd_d1                ? max_cnt              :
                             (state == STATE_RFM) && rfm_cmd_d2                ? spcnt                :
                             (state == STATE_ACT) && act_cmd_d3 && table_hit   ? cnt_cam_data_out + 1 : 
                                                                                 spcnt + 1;
assign cnt_cam_addr_in    =  (state == STATE_ACT) &&               table_hit   ? hit_addr_idx         : 
                                                                                 hit_cnt_idx;
assign cnt_cam_read_en    =  (state == STATE_ACT) && act_cmd_d2 && table_hit;
assign cnt_cam_write_en   =  (state == STATE_RFM) && rfm_cmd_d2 ||
                            ((state == STATE_ACT) && act_cmd_d3 && (table_hit ||
                                                                   (~table_hit && cnt_hit)));
assign cnt_cam_search_en  = ((state == STATE_ACT) && act_cmd_d1) || 
                             (state == STATE_RFM) && rfm_cmd_d1;
assign cnt_cam_reset      = ~rstn;





/* CAM INSTANTIATION */
addr_cam #(.WORD_SIZE(ADDR_SIZE), .ROW_NUM(NUM_ENTRY), .ENTRY_WIDTH(NUM_ENTRY_BITS)) addr_cam (addr_cam_data_in, addr_cam_addr_in, addr_cam_read_en, addr_cam_write_en, addr_cam_search_en,
  addr_cam_reset, addr_cam_data_out, addr_cam_addr_out, addr_cam_match);

cnt_cam #(.WORD_SIZE(CNT_SIZE), .ROW_NUM(NUM_ENTRY), .ENTRY_WIDTH(NUM_ENTRY_BITS)) cnt_cam (cnt_cam_data_in, cnt_cam_addr_in, cnt_cam_read_en, cnt_cam_write_en, cnt_cam_search_en, cnt_cam_reset, cnt_cam_data_out, cnt_cam_addr_out, cnt_cam_match, clk, rstn, max_en, next_max_cnt);



endmodule
