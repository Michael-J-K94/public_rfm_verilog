
import math

params = [] # N_entry, RFM_th, Counter-bits
#params.append([16, 1, 2])
#params.append([16, 4, 4])
#params.append([32, 1, 3])
#params.append([32, 4, 5])
#params.append([32, 1320, 13])
#params.append([64, 1, 3])
#params.append([64, 4, 5])
#params.append([64, 558, 12])
#params.append([64, 2735, 14])
#params.append([128, 3, 5])
#params.append([128, 246, 11])
#params.append([128, 1214, 13])
#params.append([128, 3159, 15])
#params.append([256, 3, 5])
#params.append([256, 113, 10])
#params.append([256, 547, 12])
#params.append([256, 1424, 14])
#params.append([256, 3179, 15])
#params.append([512, 3, 5])
#params.append([512, 54, 9])
#params.append([512, 249, 11])
#params.append([512, 649, 13])
#params.append([512, 1448, 14])
#params.append([512, 3048, 15])
params.append([1024, 24, 8])
params.append([1024, 115, 10])
params.append([1024, 298, 12])
params.append([1024, 665, 13])
params.append([1024, 1399, 14])
params.append([1024, 2868, 15])


BASE_DIR = ".."
TSMC_STD_CELL = "/scale/cal/home/jhpark/logic_design/db/tsmc40/g"
SYN_FREQ = "70.0"
TSMC_TARGET_LIB = "sc9_cln40g_base_rvt_tt_typical_max_0p90v_25c"



for param in params:
  print( "mkdir -p ./log/rfm_{}; ".format(SYN_FREQ), end='')
  print( "export BASE_DIR={}; ".format(BASE_DIR), end='')
  print( "export TSMC_STD_CELL={}; ".format(TSMC_STD_CELL), end='')
  print( "export SYN_FREQ={}; ".format(SYN_FREQ), end='')
  print( "export TSMC_TARGET_LIB={}; ".format(TSMC_TARGET_LIB), end='')
  print( "export NUM_ENTRY={}; ".format(int(param[0])), end='')
  print( "export RFM_TH={}; ".format(int(param[1])), end='')
  print( "dc_shell-xg-t -f {}/syn/rfm.tcl -no_gui > ./log/rfm_{}/{}_{}.log".format(BASE_DIR, SYN_FREQ, int(param[0]), int(param[1])))

