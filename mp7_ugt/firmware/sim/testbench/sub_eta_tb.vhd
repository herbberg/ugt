-- Description:
-- Testbench for simulation of conversions.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity sub_eta_tb is
end sub_eta_tb;

architecture rtl of sub_eta_tb is

    constant LHC_CLK_PERIOD : time :=  25 ns;
    signal lhc_clk: std_logic;

    signal eta : conv_integer_array;

--*********************************Main Body of Code**********************************
begin
    
    -- Clock
    process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;

    process
    begin
        wait for LHC_CLK_PERIOD; 
            eta <= (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        wait for LHC_CLK_PERIOD; 
--             eta <= (X"2d",X"22",X"de",X"42",X"ee",X"2d",X"b7",X"04",X"e2",X"9e",X"19",X"a4");
            eta <= (45,34,-34,66,-18,45,-73,4,-30,-98,25,-92);
        wait for LHC_CLK_PERIOD; 
            eta <= (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        wait;
    end process;

    ------------------- Instantiate  modules  -----------------
 
dut: entity work.sub_eta
    generic map(N_JET_OBJECTS, N_JET_OBJECTS, (eg_t,jet_t))
    port map(
        eta, eta, open
    );

end rtl;

