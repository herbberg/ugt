-- Description:
-- Differences in phi.

-- Version-history:
-- HB 2019-06-27: Changed type of outputs.
-- HB 2019-01-11: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;
use work.lut_pkg.all;

entity sub_phi is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        PHI_HALF_RANGE : positive
    );
    port(
        phi_1 : in conv_integer_array;
        phi_2 : in conv_integer_array;
--         sub_phi_o : out dim2_max_phi_range_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1)
        sub_phi_o : out max_phi_range_array := (others => (others => 0))
    );
end sub_phi;

architecture rtl of sub_phi is

    signal sub_temp : max_phi_range_array := (others => (others => 0));
    
begin
    
    loop_1: for i in 0 to N_OBJ_1-1 generate
        loop_2: for j in 0 to N_OBJ_2-1 generate
            sub_temp(i,j) <= abs(phi_1(i) - phi_2(j));
            sub_phi_o(i,j) <= sub_temp(i,j) when (sub_temp(i,j) < PHI_HALF_RANGE) else (PHI_HALF_RANGE*2-sub_temp(i,j));
        end generate loop_2;
    end generate loop_1;

end architecture rtl;
