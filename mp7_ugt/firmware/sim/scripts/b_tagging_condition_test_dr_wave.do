onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /b_tagging_condition_tb/lhc_clk
add wave -noupdate -radix hexadecimal -childformat {{/b_tagging_condition_tb/jet_bx_0(0) -radix hexadecimal} {/b_tagging_condition_tb/jet_bx_0(1) -radix hexadecimal}} -subitemconfig {/b_tagging_condition_tb/jet_bx_0(0) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/jet_bx_0(1) {-height 17 -radix hexadecimal}} /b_tagging_condition_tb/jet_bx_0
add wave -noupdate -radix hexadecimal /b_tagging_condition_tb/jet_bx_0_ff
add wave -noupdate -radix hexadecimal -childformat {{/b_tagging_condition_tb/muon_bx_0(0) -radix hexadecimal} {/b_tagging_condition_tb/muon_bx_0(1) -radix hexadecimal} {/b_tagging_condition_tb/muon_bx_0(2) -radix hexadecimal}} -subitemconfig {/b_tagging_condition_tb/muon_bx_0(0) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/muon_bx_0(1) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/muon_bx_0(2) {-height 17 -radix hexadecimal}} /b_tagging_condition_tb/muon_bx_0
add wave -noupdate -radix hexadecimal /b_tagging_condition_tb/muon_bx_0_ff
add wave -noupdate -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/calo_obj_vs_templ(0) -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/calo_obj_vs_templ(0)(1) -radix hexadecimal}}} {/b_tagging_condition_tb/dut/calo_obj_vs_templ(1) -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/calo_obj_vs_templ(1)(1) -radix hexadecimal}}}} -expand -subitemconfig {/b_tagging_condition_tb/dut/calo_obj_vs_templ(0) {-height 17 -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/calo_obj_vs_templ(0)(1) -radix hexadecimal}} -expand} /b_tagging_condition_tb/dut/calo_obj_vs_templ(0)(1) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/dut/calo_obj_vs_templ(1) {-height 17 -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/calo_obj_vs_templ(1)(1) -radix hexadecimal}} -expand} /b_tagging_condition_tb/dut/calo_obj_vs_templ(1)(1) {-height 17 -radix hexadecimal}} /b_tagging_condition_tb/dut/calo_obj_vs_templ
add wave -noupdate -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/calo_obj_vs_templ_pipe(0) -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/calo_obj_vs_templ_pipe(0)(1) -radix hexadecimal}}} {/b_tagging_condition_tb/dut/calo_obj_vs_templ_pipe(1) -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/calo_obj_vs_templ_pipe(1)(1) -radix hexadecimal}}}} -subitemconfig {/b_tagging_condition_tb/dut/calo_obj_vs_templ_pipe(0) {-height 17 -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/calo_obj_vs_templ_pipe(0)(1) -radix hexadecimal}} -expand} /b_tagging_condition_tb/dut/calo_obj_vs_templ_pipe(0)(1) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/dut/calo_obj_vs_templ_pipe(1) {-height 17 -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/calo_obj_vs_templ_pipe(1)(1) -radix hexadecimal}} -expand} /b_tagging_condition_tb/dut/calo_obj_vs_templ_pipe(1)(1) {-height 17 -radix hexadecimal}} /b_tagging_condition_tb/dut/calo_obj_vs_templ_pipe
add wave -noupdate -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/muon_obj_vs_templ(0) -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/muon_obj_vs_templ(0)(1) -radix hexadecimal} {/b_tagging_condition_tb/dut/muon_obj_vs_templ(0)(2) -radix hexadecimal}}} {/b_tagging_condition_tb/dut/muon_obj_vs_templ(1) -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/muon_obj_vs_templ(1)(1) -radix hexadecimal} {/b_tagging_condition_tb/dut/muon_obj_vs_templ(1)(2) -radix hexadecimal}}} {/b_tagging_condition_tb/dut/muon_obj_vs_templ(2) -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/muon_obj_vs_templ(2)(1) -radix hexadecimal} {/b_tagging_condition_tb/dut/muon_obj_vs_templ(2)(2) -radix hexadecimal}}}} -expand -subitemconfig {/b_tagging_condition_tb/dut/muon_obj_vs_templ(0) {-height 17 -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/muon_obj_vs_templ(0)(1) -radix hexadecimal} {/b_tagging_condition_tb/dut/muon_obj_vs_templ(0)(2) -radix hexadecimal}} -expand} /b_tagging_condition_tb/dut/muon_obj_vs_templ(0)(1) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/dut/muon_obj_vs_templ(0)(2) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/dut/muon_obj_vs_templ(1) {-height 17 -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/muon_obj_vs_templ(1)(1) -radix hexadecimal} {/b_tagging_condition_tb/dut/muon_obj_vs_templ(1)(2) -radix hexadecimal}} -expand} /b_tagging_condition_tb/dut/muon_obj_vs_templ(1)(1) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/dut/muon_obj_vs_templ(1)(2) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/dut/muon_obj_vs_templ(2) {-height 17 -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/muon_obj_vs_templ(2)(1) -radix hexadecimal} {/b_tagging_condition_tb/dut/muon_obj_vs_templ(2)(2) -radix hexadecimal}} -expand} /b_tagging_condition_tb/dut/muon_obj_vs_templ(2)(1) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/dut/muon_obj_vs_templ(2)(2) {-height 17 -radix hexadecimal}} /b_tagging_condition_tb/dut/muon_obj_vs_templ
add wave -noupdate -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(0) -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(0)(1) -radix hexadecimal} {/b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(0)(2) -radix hexadecimal}}} {/b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(1) -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(1)(1) -radix hexadecimal} {/b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(1)(2) -radix hexadecimal}}} {/b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(2) -radix hexadecimal}} -subitemconfig {/b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(0) {-height 17 -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(0)(1) -radix hexadecimal} {/b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(0)(2) -radix hexadecimal}} -expand} /b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(0)(1) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(0)(2) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(1) {-height 17 -radix hexadecimal -childformat {{/b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(1)(1) -radix hexadecimal} {/b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(1)(2) -radix hexadecimal}} -expand} /b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(1)(1) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(1)(2) {-height 17 -radix hexadecimal} /b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe(2) {-height 17 -radix hexadecimal}} /b_tagging_condition_tb/dut/muon_obj_vs_templ_pipe
add wave -noupdate -radix hexadecimal /b_tagging_condition_tb/dut/dr_comp
add wave -noupdate -radix hexadecimal /b_tagging_condition_tb/dut/dr_comp_pipe
add wave -noupdate -radix hexadecimal /b_tagging_condition_tb/dut/condition_and_or
add wave -noupdate /b_tagging_condition_tb/dut/condition_o
add wave -noupdate -divider Details
add wave -noupdate -radix decimal /b_tagging_condition_tb/dut/delta_l_1(0)/delta_l_2(0)/dr_i/dr_calculator_i/upper_limit_vector
add wave -noupdate -radix decimal /b_tagging_condition_tb/dut/delta_l_1(0)/delta_l_2(0)/dr_i/dr_calculator_i/lower_limit_vector
add wave -noupdate -radix decimal /b_tagging_condition_tb/dut/delta_l_1(0)/delta_l_2(0)/dr_i/dr_calculator_i/dr_squared
add wave -noupdate /b_tagging_condition_tb/dut/delta_l_1(0)/delta_l_2(0)/dr_i/dr_calculator_i/dr_comp
add wave -noupdate -radix decimal /b_tagging_condition_tb/dut/delta_l_1(0)/delta_l_2(1)/dr_i/dr_calculator_i/dr_squared
add wave -noupdate /b_tagging_condition_tb/dut/delta_l_1(0)/delta_l_2(1)/dr_i/dr_calculator_i/dr_comp
add wave -noupdate -radix decimal /b_tagging_condition_tb/dut/delta_l_1(0)/delta_l_2(2)/dr_i/dr_calculator_i/dr_squared
add wave -noupdate /b_tagging_condition_tb/dut/delta_l_1(0)/delta_l_2(2)/dr_i/dr_calculator_i/dr_comp
add wave -noupdate -radix decimal /b_tagging_condition_tb/dut/delta_l_1(1)/delta_l_2(0)/dr_i/dr_calculator_i/dr_squared
add wave -noupdate /b_tagging_condition_tb/dut/delta_l_1(1)/delta_l_2(0)/dr_i/dr_calculator_i/dr_comp
add wave -noupdate -radix decimal /b_tagging_condition_tb/dut/delta_l_1(1)/delta_l_2(1)/dr_i/dr_calculator_i/dr_squared
add wave -noupdate /b_tagging_condition_tb/dut/delta_l_1(1)/delta_l_2(1)/dr_i/dr_calculator_i/dr_comp
add wave -noupdate -radix decimal /b_tagging_condition_tb/dut/delta_l_1(1)/delta_l_2(2)/dr_i/dr_calculator_i/dr_squared
add wave -noupdate /b_tagging_condition_tb/dut/delta_l_1(1)/delta_l_2(2)/dr_i/dr_calculator_i/dr_comp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {155417 ps} 0} {{Cursor 2} {36007 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 457
configure wave -valuecolwidth 126
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {13354 ps} {509039 ps}
