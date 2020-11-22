export MAX_CORE=8
export BASE_DIR=".."
export TSMC_STD_CELL="/scale/cal/home/jhpark/logic_design/db/tsmc40/g"
export SYN_FREQ="100.0"
export TSMC_TARGET_LIB="sc9mc_cln40lp_hdlpk_rvt_c40_tt_typical_max_1p10v_25c"

export NUM_ENTRY=64
export RFM_TH=8

rm -rf run__.sh

for TSMC_TARGET_LIB in sc9_cln40g_base_rvt_tt_typical_max_0p90v_25c
do
  for SYN_FREQ in 70.0
  do
#    for NUM_ENTRY in 16 64 256
    for NUM_ENTRY in 64
    do
#      for RFM_TH in 8 32 80 160 400
      for RFM_TH in 8 32
      do
      echo " \
mkdir -p ./log/rfm_${SYN_FREQ}; \
export TSMC_STD_CELL=$TSMC_STD_CELL; \
export SYN_FREQ=$SYN_FREQ; \
export TSMC_TARGET_LIB=$TSMC_TARGET_LIB; \
export NUM_ENTRY=$NUM_ENTRY; \
export RFM_TH=$RFM_TH; \
dc_shell-xg-t -f $BASE_DIR/syn/rfm.tcl -no_gui > ./log/rfm_${SYN_FREQ}/${NUM_ENTRY}_$RFM_TH.log \
" >> run__.sh
      done
    done
  done
done

/scale/cal/home/jhpark/scripts/run_multiprog.py --process $MAX_CORE --script run__.sh
rm -rf run__.sh
