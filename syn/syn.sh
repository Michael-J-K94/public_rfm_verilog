export MAX_CORE=8
export BASE_DIR=".."
export TSMC_STD_CELL="/scale/cal/home/jhpark/logic_design/db/tsmc40"
export SYN_FREQ="100.0"
export TSMC_TARGET_LIB="sc9_cln40g_base_rvt_tt_typical_max_0p90v_25c"

#rm -rf run__.sh

for TSMC_TARGET_LIB in sc9_cln40g_base_rvt_tt_typical_max_0p90v_25c
do
  for SYN_FREQ in 600.0
  do
#      echo " \
export TSMC_STD_CELL=$TSMC_STD_CELL; \
export SYN_FREQ=$SYN_FREQ; \
export TSMC_TARGET_LIB=$TSMC_TARGET_LIB; \
export DW_IP_NAME=$DW_IP_NAME; \
dc_shell-xg-t -f $BASE_DIR/syn/rfm_tsmc40.tcl -no_gui | tee dc_shell.log \
#" >> run__.sh
  done
done

#./run_multiprog.py --process $MAX_CORE --script run__.sh
#rm -rf run__.sh
