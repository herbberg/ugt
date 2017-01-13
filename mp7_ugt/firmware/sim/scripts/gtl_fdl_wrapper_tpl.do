##--------------------------------------------------------------------------------
##-- Simulator   : ModelSim 10.3b
##-- Platform    : Linux Ubuntu 10.04
##-- Targets     : Simulation
##--------------------------------------------------------------------------------
##-- This work is held in copyright as an unpublished work by HEPHY (Institute
##-- of High Energy Physics) All rights reserved.  This work may not be used
##-- except by authorized licensees of HEPHY. This work is the
##-- confidential information of HEPHY.
##--------------------------------------------------------------------------------
##---Description: 
##-- $HeadURL: https://svn.cern.ch/reps/cactus/trunk/cactusupgrades/projects/ugt/mp7_ugt/firmware/sim/scripts/gtl_fdl_wrapper_test_tpl.do $
##-- $Date: 2015-09-08 11:26:11 +0200 (Tue, 08 Sep 2015) $
##-- $Author: hbergaue $
##-- $Revision: 39037 $
##--------------------------------------------------------------------------------

##***************************** Beginning of Script ***************************
        
## If MTI_LIBS is defined, map unisim and simprim directories using MTI_LIBS
## This mode of mapping the unisims libraries is provided for backward 
## compatibility with previous wizard releases. If you don't set MTI_LIBS
## the unisim libraries will be loaded from the paths set up by compxlib in
## your modelsim.ini file

set XILINX   $env(XILINX)
if [info exists env(MTI_LIBS)] {    
    set MTI_LIBS $env(MTI_LIBS)
    vlib UNISIM
    vlib SECUREIP
    vmap UNISIM $MTI_LIBS/unisim
    vmap SECUREIP $MTI_LIBS/secureip  
}

## set your src files directory for your design

##set MP7_BRDS _MP7_TAG_/boards/mp7/base_fw
set MP7_COMPONENTS _MP7_TAG_/components

## HB 2016-11-16: vhdl_temp is a temporary directory, which is removed after simulation
set L1TM ./../sim/vhdl_temp

set GT_SRC ./../hdl
set GT_CORES ./../ngc
set TESTBENCH ./../sim/testbench

## Create and map work directory
vlib work
vmap work work

##Design files
vcom -93 -work work $MP7_COMPONENTS/mp7_datapath/firmware/hdl/mp7_data_types.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/ipbus_package.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/ipbus_trans_decl.vhd
vcom -93 -work work $GT_SRC/lhc_data_pkg.vhd
vcom -93 -work work $GT_SRC/math_pkg.vhd
## HB 2016-12-05: used gt_mp7_core_pkg_sim.vhd for simulation without other MP7 packages
vcom -93 -work work $GT_SRC/gt_mp7_core/gt_mp7_core_pkg_sim.vhd
vcom -93 -work work $L1TM/gtl_pkg.vhd
vcom -93 -work work $TESTBENCH/lhc_data_debug_util_pkg.vhd
vcom -93 -work work $TESTBENCH/txt_util_pkg.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/p_m_2_bx_pipeline.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/phi_windows_comp.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/eta_comp_signed.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/eta_windows_comp.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_signed_eta.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_unsigned_phi.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_comparators_v2.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions_v2.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions_v3.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_comparators.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/esums_comparators.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/esums_conditions.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/min_bias_hf_conditions.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_comparators.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_comparators_v2.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_conditions.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_conditions_v2.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_conditions_v3.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_charge_correlations.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_signed_eta.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_unsigned_phi.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_eta_obj_vs_obj.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_phi_obj_vs_obj.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_eta_integer_obj_vs_obj.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_phi_integer_obj_vs_obj.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/dr_calculator.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/invariant_mass.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/mass_cuts.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/towercount_condition.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_muon_correlation_condition.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_calo_correlation_condition.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_calo_correlation_condition_v2.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_muon_correlation_condition.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_esums_correlation_condition.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_esums_correlation_condition.vhd
vcom -93 -work work $L1TM/gtl_module.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/frame/dm/delay_element.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/update_process.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/pulse_converter.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_addr_decode.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_fabric.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_pre_scaler.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_rate_counter.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_post_dead_time_counter.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_slice.vhd
vcom -93 -work work $GT_CORES/dp_mem_4096x32/dp_mem_4096x32.vhd
vcom -93 -work work $GT_SRC/ipbus/slaves/ipb_dpmem_4096_32.vhd
vcom -93 -work work $GT_SRC/ipbus/slaves/ipb_read_regs.vhd
vcom -93 -work work $GT_SRC/ipbus/slaves/ipb_write_regs.vhd
vcom -93 -work work $GT_SRC/ipbus/slaves/ipb_pulse_regs.vhd
vcom -93 -work work $L1TM/algo_mapping_rop.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_module.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/gtl_fdl_wrapper.vhd

##Testbench
vcom -93 -work work $TESTBENCH/gtl_fdl_wrapper_tb.vhd

##Load Design
vsim -t 1ps work.gtl_fdl_wrapper_TB 

##Load signals in wave window
#view wave
#do $TESTBENCH/../scripts/gtl_fdl_wrapper_test_wave.do

##Run simulation
run 91000 ns

# eof
