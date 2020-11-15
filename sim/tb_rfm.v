`timescale 1ps/1ps

module rfm_tb();


localparam NUM_ENTRY = 64; 
localparam NUM_ENTRY_BITS = 6; // log2 (NUM_ENTRY)
localparam RFM_TH = 8; 
localparam ADDR_SIZE = 18; 
localparam CNT_SIZE = 32; 

reg clk;
reg rstn;
reg act_cmd;
reg [ADDR_SIZE-1:0] act_addr;
reg rfm_cmd;

wire nrr_cmd;
wire [ADDR_SIZE-1:0] nrr_addr;

integer f;
integer trace_file;
integer iter;
genvar i;
reg [8:0] act_count=0;




// For Test
localparam STATE_IDLE  = 4'd0;
localparam STATE_ACT   = 4'd1;
localparam STATE_RFM   = 4'd2;
wire [3:0] state;
wire [ADDR_SIZE-1:0] act_addr_reg;
wire rfm_cmd_reg;
wire [ADDR_SIZE-1:0] addr_table [0:NUM_ENTRY-1];
wire [NUM_ENTRY-1:0] addr_matches;
wire [CNT_SIZE-1:0] cnt_table [0:NUM_ENTRY-1];
//wire [NUM_ENTRY-1:0] cnt_matches;
wire [CNT_SIZE-1:0] spcnt;
wire [ADDR_SIZE-1:0] max_addr;




// Clock
initial begin
  clk = 1'b0;
  forever #5 clk = ~clk;
end


// Activation
initial begin
  trace_file = $fopen("trace.txt", "r");
  act_cmd = 1'b0;
  act_addr = {ADDR_SIZE{1'b0}};
  #20
  forever begin
    repeat (59) @(posedge clk);
    act_cmd <= 1'b1;
    act_count = act_count +1;
    $fscanf(trace_file, "%d\n", act_addr);
    repeat (1) @(posedge clk);
    act_cmd <= 1'b0;
    if ($feof(trace_file)) begin
      repeat (300) @(posedge clk);
      $finish;
    end
  end
end


// RFM
initial begin
  #20
  forever begin
    repeat (60) @(posedge clk);
    wait((act_count % RFM_TH) == 0)
    repeat (5) @(posedge clk);
    rfm_cmd <= 1'b1;
    repeat (1) @(posedge clk);
    rfm_cmd <= 1'b0;
  end
end



// Main Function
initial begin
  f = $fopen("result.txt","w");

  rstn = 1'b1;
  #10
  rstn = 1'b0;
  #10
  rstn = 1'b1;
  repeat (100000) @(posedge clk);
  $fclose(f);
  $finish;
end

// Display
initial begin
  #20
  forever begin
//    wait(state==STATE_HISTORY_TABLE_UPDATE);
//    wait(state==STATE_IDLE);
    wait(act_cmd == 1'b0);
    wait(act_cmd == 1'b1);
    repeat (10) @(posedge clk);
    $fwrite(f,"////////  ACT %d ////////\n", act_count);
    $fwrite(f,"ACT Address : %d\n", act_addr);
    for(iter = 0; iter < NUM_ENTRY; iter = iter+1) begin
      $fwrite(f,"%d: %d, %d\n", iter, addr_table[iter], cnt_table [iter]);
    end
    $fwrite(f,"\n\n");
  end
end


assign state                = u_rfm_unit_bank.state;
assign act_addr_reg         = u_rfm_unit_bank.act_addr_reg;
assign rfm_cmd_reg          = u_rfm_unit_bank.act_addr_reg;
assign addr_matches         = u_rfm_unit_bank.addr_matches;
assign spcnt                = u_rfm_unit_bank.spcnt;
assign max_addr             = u_rfm_unit_bank.max_addr;
generate
  for (i = 0; i < NUM_ENTRY; i=i+1) begin
    assign addr_table[i]    = u_rfm_unit_bank.addr_table[i];
    assign cnt_table[i]     = u_rfm_unit_bank.cnt_table[i];
  end
endgenerate

rfm_unit_bank
#(
  .NUM_ENTRY      (NUM_ENTRY),
  .NUM_ENTRY_BITS (NUM_ENTRY_BITS),
  .RFM_TH         (RFM_TH),
  .ADDR_SIZE      (ADDR_SIZE),
  .CNT_SIZE       (CNT_SIZE)
)
u_rfm_unit_bank
(
  .clk(clk),
  .rstn(rstn),
  .act_cmd(act_cmd),
  .act_addr(act_addr),
  .rfm_cmd(rfm_cmd),

  .nrr_cmd(nrr_cmd),
  .nrr_addr(nrr_addr)
);


`ifdef WAVE 
  initial begin
    $shm_open("WAVE");
    $shm_probe("ASM");
  end  
`endif


endmodule
