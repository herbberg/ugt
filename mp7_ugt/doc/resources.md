## Resource details (Slice LUTs and DSPs) for VHDL Producer:

***`UNDER CONSTRUCTION`***

### Modules for calculations:
#### Values for one instance:

| Module                   | Instance       | Slice LUTs | DSPs |
| -------------------------|----------------|:----------:|:----:|
| diff_eta_lut             | luts_corr_cuts |         51 |    0 |
| diff_phi_lut             | luts_corr_cuts |         50 |    0 |
| sub_eta                  | sub_eta_calc   |         31 |    0 |
| sub_phi                  | sub_phi_calc   |         40 |    0 |
| delta_r                  | delta_r_calc   |          0 |    2 |
| inv_mass                 | inv_mass_calc  |          0 |    4 |
| cosh_deta_lut            | luts_corr_cuts |         83 |    0 |
| cos_dphi_lut             | luts_corr_cuts |         40 |    0 |
| twobody_pt               | twobody_pt_calc|        139 |    7 |

* Resource calculation for a module with "same object type":
 
   (number of objects-1) x (number of objects/2) x (value of instance)
 
* Resource calculation for a module with "different object types":
 
   (number of objects type a) x (number of objects type b) x (value of instance)

#### Value for entire module: 

| Module                   | Slice LUTs | DSPs |
| -------------------------|:-----:|:----:|
| muon_charge_correlation  |   135 |    0 |

### Modules for comparators:
#### Values for one instance:

| Module                | Instance      | Mode      | Slice LUTs |
| ----------------------|---------------|-----------|:-----:|
| comparators_obj_cuts  | comp_unsigned | pt        |     2 |
| comparators_obj_cuts  | comp_unsigned | phi       |     2 |
| comparators_obj_cuts  | comp_signed   | eta       |     2 |
| comparators_corr_cuts | comp_unsigned | deltaEta  |     ? |
| comparators_corr_cuts | comp_unsigned | deltaPhi  |     ? |
| comparators_corr_cuts | comp_unsigned | deltaR    |    12 |
| comparators_corr_cuts | comp_unsigned | mass      |    25 |
| comparators_corr_cuts | comp_unsigned | twoBodyPt |     9 |
| lut_comparator        |               | qual      |     1 |

* Resource calculation for comparators_obj_cuts and lut_comparator:
 
   (number of objects) x (value of instance)
 
* Resource calculation for comparators_corr_cuts with "same object type":
 
   (number of objects-1) x (number of objects/2) x (value of instance)
 
* Resource calculation for comparators_corr_cuts with "different object types":
 
   (number of objects type a) x (number of objects type b) x (value of instance)

#### Value for entire module: 

| Module                     | Slice LUTs |
| ---------------------------|:-----:|
| comparators_muon_cc_doube  |    56 |
| comparators_muon_cc_triple |   336 |
| comparators_muon_cc_quad   |  1680 |

### Modules for conditions:

| Condition type             | Slice LUTs | Comments |
| ---------------------------|:-----:|:-------------:|
| single_calo                |     3 |               |
| double_calo                |    38 |               |
| triple_calo                |     ? | value missing |
| quad_calo                  |     ? | value missing |
| single_muon                |     ? | value missing |
| double_muon                |     ? | value missing |
| triple_muon                |     ? | value missing |
| quad_muon                  |   956 |               |
| correlation                |   134 | to be checked |
| correlation_ovrm           |   247 | to be checked |
