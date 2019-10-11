-- Description:
-- Calculation of differences in phi.

-- Version-history:
-- HB 2019-08-22: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity sub_phi_calc is
    generic(
        PHI_HALF_RANGE : positive
    );
    port(
        phi_1 : in integer;
        phi_2 : in integer;
        sub_phi : out integer := 0
    );
end sub_phi_calc;

architecture rtl of sub_phi_calc is

    signal abs_dphi : integer := 0;

-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead
    attribute use_dsp : string;
    attribute use_dsp of abs_dphi : signal is "yes";
    attribute use_dsp of sub_phi : signal is "yes";

begin
    
    abs_dphi <= abs(phi_1 - phi_2);
    sub_phi <= abs_dphi when (abs_dphi < PHI_HALF_RANGE) else (PHI_HALF_RANGE*2-abs_dphi);

end architecture rtl;
