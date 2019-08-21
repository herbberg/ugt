-- Description:
-- COSH LUTs of Differences in eta.

-- Version-history:
-- HB 2019-08-20: Changed type of outputs.
-- HB 2019-06-27: Changed type of inputs.
-- HB 2019-01-11: First design.

library ieee;
use ieee.std_logic_1164.all;

-- used for CONV_STD_LOGIC_VECTOR
use ieee.std_logic_arith.all;
-- used for CONV_INTEGER
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;
use work.lut_pkg.all;

entity cosh_deta_lut is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        OBJ : obj_type_array;
        MODE : lut_mode := CaloCaloCoshDeta   
    );
    port(
        sub_eta : in max_eta_range_array;
        cosh_deta_o : out corr_cuts_std_logic_array := (others => (others => (others => '0')))
    );
end cosh_deta_lut;

architecture rtl of cosh_deta_lut is

    signal cosh_deta_i : cosh_cos_vector_array := (others => (others => (others => '0')));

begin

    l_1: for i in 0 to N_OBJ_1-1 generate
        l_2: for j in 0 to N_OBJ_2-1 generate
            lut_i : entity work.luts_corr_cuts
                generic map(MODE)  
                port map(sub_eta(i,j), cosh_deta_i(i,j));
            l_3: for k in 0 to MAX_COSH_COS_WIDTH-1 generate
                cosh_deta_o(i,j,k) <= cosh_deta_i(i,j)(k);
            end generate l_3;
        end generate l_2;
    end generate l_1;

end architecture rtl;
