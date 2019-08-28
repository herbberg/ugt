# Resources details (for VHDL Producer) in Slice LUTs and DSPs:

**`UNDER CONSTRUCTION`**

| Module         |                | Slice |      |
| (calculations) | Instance       | LUTs  | DSPs |
| ---------------|----------------|------:| ----:|
| diff_eta_lut   | luts_corr_cuts |    51 |    0 |
| diff_phi_lut   | luts_corr_cuts |    50 |    0 |
| sub_eta        | sub_eta_calc   |    31 |    0 |
| sub_phi        | sub_phi_calc   |    40 |    0 |
| delta_r        | delta_r_calc   |     0 |    2 |
| inv_mass       | inv_mass_calc  |     0 |    4 |
| cosh_deta_lut  | luts_corr_cuts |    83 |    0 |
| cos_dphi_lut   | luts_corr_cuts |    40 |    0 |

 Resource calculation for a module with "same object type": (number of objects-1) x (number of objects/2) x (value of instance)
 Resource calculation for a module with "different object types": (number of objects type 1) x (number of objects type 2) x (value of instance)

| Module                |               |          | Slice |      |
| (comparators)         | Instance      | Mode     | LUTs  | DSPs |
| ----------------------|---------------|----------|------:| ----:|
| comparators_obj_cuts  | comp_unsigned | pt       |     2 |    0 |
| comparators_obj_cuts  | comp_unsigned | phi      |     2 |    0 |
| comparators_obj_cuts  | comp_signed   | eta      |     2 |    0 |
| comparators_corr_cuts | comp_unsigned | deltaR   |    12 |    0 |
| comparators_corr_cuts | comp_unsigned | inv_mass |    25 |    0 |

 Resource calculation for comparators_obj_cuts: (number of objects) x (value of instance)
 Resource calculation for comparators_corr_cuts with "same object type": (number of objects-1) x (number of objects/2) x (value of instance)
 Resource calculation for comparators_corr_cuts with "different object types": (number of objects type 1) x (number of objects type 2) x (value of instance)

| Module                   | Slice |      |
| (calculations)           | LUTs  | DSPs |
| -------------------------|------:| ----:|
| muon_charge_correlation  |   135 |    0 |

| Module                   | Slice |      |
| (comparators)            | LUTs  | DSPs |
| -------------------------|------:| ----:|
| comparators_muon_cc_quad |  1680 |    0 |

