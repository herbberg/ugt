-- Description:
-- Calculation of transverse mass based on LUTs.

-- Version history:
-- HB 2019-08-20: Changed types.
-- HB 2019-01-14: No output register.
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity transverse_mass is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        PT1_WIDTH : positive;
        PT2_WIDTH : positive;
        COSH_COS_WIDTH : positive;
        COSH_COS_PREC : positive
    );
    port(
        pt1 : in conv_pt_vector_array;
        pt2 : in conv_pt_vector_array;
        cos_dphi : in corr_cuts_std_logic_array;
        transverse_mass_o : out corr_cuts_std_logic_array := (others => (others => (others => '0')))
    );
end transverse_mass;

architecture rtl of transverse_mass is

    constant MASS_WIDTH : positive := PT1_WIDTH+PT2_WIDTH+COSH_COS_WIDTH;
    type mass_vector_i_array is array (0 to N_OBJ_1-1, 0 to N_OBJ_2-1) of std_logic_vector(MASS_WIDTH-1 downto 0);
    signal transverse_mass_sq_div2 : mass_vector_i_array := (others => (others => (others => '0')));
    signal cos_dphi_i : cosh_cos_vector_array;
    
-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead
    attribute use_dsp : string;
    attribute use_dsp of transverse_mass_sq_div2 : signal is "yes";

begin

-- HB 2016-12-12: calculation of transverse mass with formular M**2/2=pt1*pt2*(1-cos(phi1-phi2))
--                "conv_std_logic_vector((10**COSH_COS_PREC), COSH_COS_WIDTH)" means 1 multiplied with 10**COSH_COS_PREC, converted to std_logic_vector with COSH_COS_WIDTH
    l_1: for i in 0 to N_OBJ_1-1 generate
        l_2: for j in 0 to N_OBJ_2-1 generate
            conv_i: for k in 0 to  COSH_COS_WIDTH-1 generate
                cos_dphi_i(i,j)(k) <= cos_dphi(i,j,k);
            end generate conv_i;
            transverse_mass_sq_div2(i,j) <= pt1(i)(PT1_WIDTH-1 downto 0) * pt2(j)(PT2_WIDTH-1 downto 0) * 
                ((conv_std_logic_vector((10**COSH_COS_PREC), COSH_COS_WIDTH)) - (cos_dphi_i(i,j)(COSH_COS_WIDTH-1 downto 0)));
            l_3: for k in 0 to MASS_WIDTH-1 generate
                transverse_mass_o(i,j,k) <= transverse_mass_sq_div2(i,j)(k);                 
            end generate l_3;
        end generate l_2;
    end generate l_1;

end architecture rtl;
