## Resource details (Slice LUTs and DSPs) for VHDL Producer:

***`UNDER CONSTRUCTION`***

### Modules for calculations:
#### Values for one instance:

| Module                    | Instance       | Slice LUTs | DSPs |
| --------------------------|----------------|:----------:|:----:|
| diff_eta_lut (calo-calo)  | luts_corr_cuts |         51 |    0 |
| diff_eta_lut (calo-muon)  | luts_corr_cuts |        154 |    0 |
| diff_phi_lut (calo-calo)  | luts_corr_cuts |         50 |    0 |
| diff_phi_lut (calo-muon)  | luts_corr_cuts |        142 |    0 |
| sub_eta                   | sub_eta_calc   |         56 |    0 |
| sub_phi                   | sub_phi_calc   |         44 |    0 |
| delta_r                   | delta_r_calc   |          0 |    2 |
| inv_mass                  | inv_mass_calc  |          0 |    4 |
| cosh_deta_lut (calo-calo) | luts_corr_cuts |         83 |    0 |
| cos_dphi_lut (calo-calo)  | luts_corr_cuts |         40 |    0 |

* Resource calculation for a module with "same object type":
 
   (number of objects-1) x (number of objects/2) x (value of instance)
 
* Resource calculation for a module with "different object types":
 
   (number of objects type a) x (number of objects type b) x (value of instance)

#### Value for entire modules: 

| Module                   | Slice LUTs | DSPs |
| -------------------------|:-----:|:----:|
| muon_charge_correlation  |   135 |    0 |

### Modules for comparators:
#### Values for one instance:

| Module                | Instance      | Mode     | Slice LUTs |
| ----------------------|---------------|----------|:-----:|
| comparators_obj_cuts  | comp_unsigned | pt       |     2 |
| comparators_obj_cuts  | comp_unsigned | phi      |     2 |
| comparators_obj_cuts  | comp_signed   | eta      |     2 |
| comparators_obj_cuts  | lut           | iso      |     1 |
| comparators_obj_cuts  | lut           | qual     |     1 |
| comparators_corr_cuts | comp_unsigned | deltaR   |    12 |
| comparators_corr_cuts | comp_unsigned | inv_mass |    25 |

* Resource calculation for comparators_obj_cuts and lut_comparator:
 
   (number of objects) x (value of instance)
 
* Resource calculation for comparators_corr_cuts with "same object type":
 
   (number of objects-1) x (number of objects/2) x (value of instance)
 
* Resource calculation for comparators_corr_cuts with "different object types":
 
   (number of objects type a) x (number of objects type b) x (value of instance)

#### Value for entire modules: 

| Module                     | Slice LUTs | Calculation |
| ---------------------------|:-----:|:----------------:|
| comparators_muon_cc_doube  |    56 | 8x7 x 1 LUT      |
| comparators_muon_cc_triple |   336 | 8x7x6 x 1 LUT    |
| comparators_muon_cc_quad   |  1680 | 8x7x6x5 x 1 LUT  |

### Modules for conditions:

| Condition type             | Slice LUTs |
| ---------------------------|:-----:|
| single_calo                |     3 |
| double_calo                |    19 |
| triple_calo                |    60 |
| quad_calo                  |  1995 |
| quad_muon                  |   956 |
| esums                      |     0 | [comparators_obj_cuts output used in algo]
