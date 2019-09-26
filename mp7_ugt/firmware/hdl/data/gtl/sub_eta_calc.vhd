-- Description:
-- Calculation of differences in eta.

-- Version-history:
-- HB 2019-08-22: First design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

use work.gtl_pkg.all;

entity sub_eta_calc is
    port(
        eta_1 : in integer;
        eta_2 : in integer;
        sub_eta : out integer := 0
    );
end sub_eta_calc;

architecture rtl of sub_eta_calc is

-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead
    attribute use_dsp : string;
    attribute use_dsp of sub_eta : signal is "yes";

begin

-- only positive difference in eta
    sub_eta <= abs(eta_1 - eta_2);
                    
end architecture rtl;
