
import math

params = [] # N_entry, RFM_th, Counter-bits
params.append([16, 1, 2])
params.append([16, 4, 4])
params.append([32, 1, 3])
params.append([32, 4, 5])
params.append([32, 1320, 13])
params.append([64, 1, 3])
params.append([64, 4, 5])
params.append([64, 558, 12])
params.append([64, 2735, 14])
params.append([128, 3, 5])
params.append([128, 246, 11])
params.append([128, 1214, 13])
params.append([128, 3159, 15])
params.append([256, 3, 5])
params.append([256, 113, 10])
params.append([256, 547, 12])
params.append([256, 1424, 14])
params.append([256, 3179, 15])
#params.append([512, 3, 5])
#params.append([512, 54, 9])
#params.append([512, 249, 11])
#params.append([512, 649, 13])
#params.append([512, 1448, 14])
#params.append([512, 3048, 15])
#params.append([1024, 24, 8])
#params.append([1024, 115, 10])
#params.append([1024, 298, 12])
#params.append([1024, 665, 13])
#params.append([1024, 1399, 14])
#params.append([1024, 2868, 15])


for param in params:

  r_file = open('rfm_unit_bank.v', 'r') 
  lines = r_file.readlines() 

  w_file = open('rfm_unit_bank/rfm_unit_bank_{}_{}.v'.format(int(param[0]), int(param[1])), 'w') 
    
  for line in lines:
    if line == "module rfm_unit_bank\n":
      line = "module rfm_unit_bank_{}_{}\n".format(int(param[0]), int(param[1]))
    if line == "  parameter NUM_ENTRY = 64,\n":
      line = "  parameter NUM_ENTRY = {},\n".format(int(param[0]))
    if line == "  parameter NUM_ENTRY_BITS = 6, // log2 (NUM_ENTRY)\n":
      line = "  parameter NUM_ENTRY_BITS = {}, // log2 (NUM_ENTRY)\n".format(int(math.log2(param[0])))
    if line == "  parameter RFM_TH = 20,\n":
      line = "  parameter RFM_TH = {},\n".format(int(param[1]))
    if line == "  parameter CNT_SIZE = 32\n":
      line = "  parameter CNT_SIZE = {}\n".format(int(param[2]))
    if line == "cnt_cam #(.WORD_SIZE(CNT_SIZE), .ROW_NUM(NUM_ENTRY), .ENTRY_WIDTH(NUM_ENTRY_BITS)) cnt_cam (cnt_cam_data_in, cnt_cam_addr_in, cnt_cam_read_en, cnt_cam_write_en, cnt_cam_search_en, cnt_cam_reset, cnt_cam_data_out, cnt_cam_addr_out, cnt_cam_match, clk, rstn, max_en, next_max_cnt);\n":
      line = "cnt_cam_{} #(.WORD_SIZE(CNT_SIZE), .ROW_NUM(NUM_ENTRY), .ENTRY_WIDTH(NUM_ENTRY_BITS)) cnt_cam (cnt_cam_data_in, cnt_cam_addr_in, cnt_cam_read_en, cnt_cam_write_en, cnt_cam_search_en, cnt_cam_reset, cnt_cam_data_out, cnt_cam_addr_out, cnt_cam_match, clk, rstn, max_en, next_max_cnt);\n".format(int(param[0]))

    w_file.write(line)

  r_file.close()
  w_file.close()
