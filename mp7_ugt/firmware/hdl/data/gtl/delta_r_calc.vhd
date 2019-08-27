-- Description:
-- Calculation of deltaR based on LUTs.

-- Version history:
-- HB 2019-08-28: First design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity delta_r_calc is
    port(
        diff_eta : in std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
        diff_phi : in std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
        dr_squared : out std_logic_vector((2*DETA_DPHI_VECTOR_WIDTH)-1 downto 0) := (others => '0')
    );
end delta_r_calc;

architecture rtl of delta_r_calc is

    signal diff_eta_sq, diff_phi_sq : std_logic_vector((2*DETA_DPHI_VECTOR_WIDTH)-1 downto 0);

-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead
    attribute use_dsp : string;
    attribute use_dsp of diff_eta_sq : signal is "yes";
    attribute use_dsp of diff_phi_sq : signal is "yes";
    attribute use_dsp of dr_squared : signal is "yes";

begin

    diff_eta_sq <= diff_eta*diff_eta;
    diff_phi_sq <= diff_phi*diff_phi;
    dr_squared <= diff_eta_sq+diff_phi_sq;
           
end architecture rtl;
