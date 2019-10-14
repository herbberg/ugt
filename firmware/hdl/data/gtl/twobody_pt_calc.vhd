
-- Description:
-- Calculation of twobody_pt.

-- Version history:
-- HB 2019-10-10: First design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity twobody_pt_calc is
    generic (
        PT1_WIDTH : positive;
        PT2_WIDTH : positive;
        SIN_COS_WIDTH: positive
    );
    port(
        pt1 : in std_logic_vector(PT1_WIDTH-1 downto 0);
        pt2 : in std_logic_vector(PT2_WIDTH-1 downto 0);
        cos_phi_1 : in integer;
        cos_phi_2 : in integer;
        sin_phi_1 : in integer;
        sin_phi_2 : in integer;
        twobody_pt_o : out std_logic_vector(2+PT1_WIDTH+PT2_WIDTH+2*SIN_COS_WIDTH-1 downto 0) := (others => '0')
    );
end twobody_pt_calc;

architecture rtl of twobody_pt_calc is

    signal cos_phi_1x2, sin_phi_1x2 : integer;
    signal cos_plus_sin_vec_temp : std_logic_vector(2*SIN_COS_WIDTH-1 downto 0);
    signal cos_plus_sin_vec : std_logic_vector(2*SIN_COS_WIDTH-1 downto 0);
    signal pt1_sq : std_logic_vector(PT1_WIDTH+PT1_WIDTH-1 downto 0);
    signal pt2_sq : std_logic_vector(PT2_WIDTH+PT2_WIDTH-1 downto 0);
    signal pt_sq : std_logic_vector(max(PT1_WIDTH+PT1_WIDTH,PT2_WIDTH+PT2_WIDTH)-1 downto 0);

-- HB 2017-03-23: calculation of twobody_pt with formular => pt**2 = pt1**2+pt2**2+2*pt1*pt2*(cos(phi1)*cos(phi2)+sin(phi1)*sin(phi2))
-- PT_SQ_VECTOR_WIDTH based on formular for pt**2 [2+... because of ...+2*pt1*pt2*(cos(phi1)*cos(phi2)+sin(phi1)*sin(phi2))]
    constant PT_SQ_VECTOR_WIDTH : positive := 2+PT1_WIDTH+PT2_WIDTH+2*SIN_COS_WIDTH;
    signal pt1_pt2_cos_sin_temp : std_logic_vector(PT_SQ_VECTOR_WIDTH-1 downto 0);
    signal pt1_pt2_cos_sin : std_logic_vector(PT_SQ_VECTOR_WIDTH-1 downto 0);
    signal twobody_pt_sq : std_logic_vector(PT_SQ_VECTOR_WIDTH-1 downto 0);

-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead attribute
--     attribute use_dsp : string;
--     attribute use_dsp of cos_phi_1x2 : signal is "yes";
--     attribute use_dsp of sin_phi_1x2 : signal is "yes";
--     attribute use_dsp of pt1_pt2_cos_sin : signal is "yes";
--     attribute use_dsp of pt1_sq : signal is "yes";
--     attribute use_dsp of pt2_sq : signal is "yes";

begin

-- HB 2017-03-23: calculation of pt**2 with formular => pt**2 = pt1**2+pt2**2+2*pt1*pt2*(cos(phi1)*cos(phi2)+sin(phi1)*sin(phi2))
-- in VHDL used: cos_plus_sin_integer = (cos(phi1)*cos(phi2)+sin(phi1)*sin(phi2))
--               conversion cos_plus_sin_integer to cos_plus_sin_vec, depending on pos. or neg. value of cos_plus_sin_integer
--               twobody_pt_sq = pt1**2+pt2**2+2*pt1*pt2*cos_plus_sin_vec

    cos_phi_1x2 <= cos_phi_1*cos_phi_2;
    sin_phi_1x2 <= sin_phi_1*sin_phi_2;
    cos_plus_sin_vec_temp <= CONV_STD_LOGIC_VECTOR((cos_phi_1x2 + sin_phi_1x2), 2*sin_cos_width);
-- HB 2017-03-22: use two's complement when cos_plus_sin_vec_temp is negative
    cos_plus_sin_vec <= cos_plus_sin_vec_temp when cos_plus_sin_vec_temp(cos_plus_sin_vec_temp'high) = '0' else (not(cos_plus_sin_vec_temp)+1);
    pt1_pt2_cos_sin_temp <= conv_std_logic_vector(2,2) * pt1(PT1_WIDTH-1 downto 0) * pt2(PT2_WIDTH-1 downto 0) * cos_plus_sin_vec;
    pt1_pt2_cos_sin <= pt1_pt2_cos_sin_temp when cos_plus_sin_vec_temp(cos_plus_sin_vec_temp'high) = '0' else (not(pt1_pt2_cos_sin_temp)+1);
    pt1_sq <= pt1(PT1_WIDTH-1 downto 0) * pt1(PT1_WIDTH-1 downto 0);            
    pt2_sq <= pt2(PT2_WIDTH-1 downto 0) * pt2(PT2_WIDTH-1 downto 0);             
    pt_sq <= pt1_sq + pt2_sq;
    twobody_pt_o <= pt_sq + pt1_pt2_cos_sin;
        
end architecture rtl;
