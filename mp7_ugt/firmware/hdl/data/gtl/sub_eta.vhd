-- Description:
-- Subtraction in eta.

-- Version-history:
-- HB 2019-06-27: Changed type of inputs.
-- HB 2019-01-11: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;
use work.lut_pkg.all;

entity sub_eta is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive
    );
    port(
        eta_1 : in conv_integer_array;
        eta_2 : in conv_integer_array;
        sub_eta_o : out dim2_max_eta_range_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1)
    );
end sub_eta;

architecture rtl of sub_eta is

begin

    loop_1: for i in 0 to N_OBJ_1-1 generate
        loop_2: for j in 0 to N_OBJ_2-1 generate
-- only positive difference in eta
            sub_eta_o(i,j) <= abs(eta_1(i) - eta_2(j));
        end generate loop_2;
    end generate loop_1;
                    
end architecture rtl;
