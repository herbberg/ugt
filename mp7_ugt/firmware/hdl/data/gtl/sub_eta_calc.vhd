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
        sub_eta_o : out integer := 0
    );
end sub_eta_calc;

architecture rtl of sub_eta_calc is

begin

-- only positive difference in eta
    sub_eta_o <= abs(eta_1 - eta_2);
                    
end architecture rtl;
