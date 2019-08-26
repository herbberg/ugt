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
        sub_phi_o : out integer := 0
    );
end sub_phi_calc;

architecture rtl of sub_phi_calc is

begin
    
    sub_phi_o <= abs(phi_1 - phi_2) when ((abs(phi_1 - phi_2)) < PHI_HALF_RANGE) else (PHI_HALF_RANGE*2-(abs(phi_1 - phi_2)));

end architecture rtl;
