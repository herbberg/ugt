
-- Description:
-- Calculation of twobody_pt (pt**2) based on LUTs.

-- Version history:
-- HB 2019-07-02: First design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity twobody_pt is
    generic (
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        PT1_WIDTH : positive;
        PT2_WIDTH : positive;
        SIN_COS_WIDTH: positive
    );
    port(
        pt1 : in pt_array(N_OBJ_1-1 downto 0);
        pt2 : in pt_array(N_OBJ_2-1 downto 0);
        cos_phi_1 : in sin_cos_vector_array;
        cos_phi_2 : in sin_cos_vector_array;
        sin_phi_1 : in sin_cos_vector_array;
        sin_phi_2 : in sin_cos_vector_array;
        twobody_pt_o : out corr_cuts_std_logic_array := (others => (others => (others => '0')))
    );
end twobody_pt;

architecture rtl of twobody_pt is

    type cos_plus_sin_vec_array is array (N_OBJ_1-1 downto 0, N_OBJ_2-1 downto 0) of std_logic_vector(2*SIN_COS_WIDTH-1 downto 0);
    signal cos_plus_sin_vec_temp : cos_plus_sin_vec_array := (others => (others => (others => '0')));
    signal cos_plus_sin_vec : cos_plus_sin_vec_array := (others => (others => (others => '0')));

-- HB 2017-03-23: calculation of twobody_pt with formular => pt**2 = pt1**2+pt2**2+2*pt1*pt2*(cos(phi1)*cos(phi2)+sin(phi1)*sin(phi2))
-- PT_SQ_VECTOR_WIDTH based on formular for pt**2 [2+... because of ...+2*pt1*pt2*(cos(phi1)*cos(phi2)+sin(phi1)*sin(phi2))]
    constant PT_SQ_VECTOR_WIDTH : positive := 2+PT1_WIDTH+PT2_WIDTH+2*SIN_COS_WIDTH;
    type pt_sq_vector_i_array is array (N_OBJ_1-1 downto 0, N_OBJ_2-1 downto 0) of std_logic_vector(PT_SQ_VECTOR_WIDTH-1 downto 0);
    signal pt1_pt2_cos_sin_temp : pt_sq_vector_i_array := (others => (others => (others => '0')));
    signal pt1_pt2_cos_sin : pt_sq_vector_i_array := (others => (others => (others => '0')));
    signal pt_sq : pt_sq_vector_i_array := (others => (others => (others => '0')));
    signal twobody_pt_sq : pt_sq_vector_i_array := (others => (others => (others => '0')));

-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead attribute
    attribute use_dsp : string;
    attribute use_dsp of cos_plus_sin_vec : signal is "yes";
    attribute use_dsp of pt1_pt2_cos_sin : signal is "yes";
    attribute use_dsp of twobody_pt_sq : signal is "yes";

begin

-- HB 2017-03-23: calculation of pt**2 with formular => pt**2 = pt1**2+pt2**2+2*pt1*pt2*(cos(phi1)*cos(phi2)+sin(phi1)*sin(phi2))
-- in VHDL used: cos_plus_sin_integer = (cos(phi1)*cos(phi2)+sin(phi1)*sin(phi2))
--               conversion cos_plus_sin_integer to cos_plus_sin_vec, depending on pos. or neg. value of cos_plus_sin_integer
--               twobody_pt_sq = pt1**2+pt2**2+2*pt1*pt2*cos_plus_sin_vec

    l_1: for i in 0 to  N_OBJ_1-1 generate
        l_2: for j in 0 to N_OBJ_2-1 generate
	    cos_plus_sin_vec_temp(i,j) <= CONV_STD_LOGIC_VECTOR(((cos_phi_1(i,j)**2) + (sin_phi_1(i,j)**2)), (2*sin_cos_width));
-- HB 2017-03-22: use two's complement when cos_plus_sin_vec_temp is negative
	    cos_plus_sin_vec(i,j) <= cos_plus_sin_vec_temp(i,j) when cos_plus_sin_vec_temp(i,j)(cos_plus_sin_vec_temp(i,j)'high) = '0' else (not(cos_plus_sin_vec_temp(i,j))+1);
	    pt1_pt2_cos_sin_temp(i,j) <= conv_std_logic_vector(2,2) * pt1(i)(PT1_WIDTH-1 downto 0) * pt2(j)(PT2_WIDTH-1 downto 0) * cos_plus_sin_vec(i,j);
	    pt1_pt2_cos_sin(i,j) <= pt1_pt2_cos_sin_temp(i,j) when cos_plus_sin_vec_temp(i,j)(cos_plus_sin_vec_temp(i,j)'high) = '0' else (not(pt1_pt2_cos_sin_temp(i,j))+1);
            pt_sq(i,j) <= (pt1(i)(PT1_WIDTH-1 downto 0)**2) * (pt2(j)(PT2_WIDTH-1 downto 0)**2);
	    twobody_pt_sq(i,j) <= pt_sq(i,j) + pt1_pt2_cos_sin(i,j);
	    l_3: for k in 0 to MASS_WIDTH-1 generate
                twobody_pt_o(i,j,k) <= twobody_pt_sq(i,j)(k);                 
            end generate l_3;
        end generate l_2;
    end generate l_1;
        
end architecture rtl;
