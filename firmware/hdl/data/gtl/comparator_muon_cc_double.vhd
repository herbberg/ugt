-- Description:
-- Comparators for muon charge correlation double.

-- Version-history:
-- HB 2019-08-27: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity comparator_muon_cc_double is
    generic(
        REQ : std_logic_vector(MUON_CHARGE_WIDTH-1 downto 0)
    );
    port(
        clk : in std_logic;
        cc_double: in muon_cc_double_array := (others => (others => (others => '0')));
        comp_o_double : out muon_cc_double_std_logic_array
    );
end comparator_muon_cc_double;

architecture rtl of comparator_muon_cc_double is
        
    signal cc_double_i :muon_cc_double_array;
    
    type comp_i_double_array is array (0 to N_MUON_OBJECTS-1, 0 to N_MUON_OBJECTS-1) of std_logic_vector(0 downto 0);
    signal comp_i_double : comp_i_double_array := (others => (others => (others => '0')));
    signal comp_r_double : comp_i_double_array;
    constant dummy_limit : std_logic_vector(1 downto 0) := (others => '0');

begin
    
    l1: for i in 0 to N_MUON_OBJECTS-1 generate
        l2: for j in 0 to N_MUON_OBJECTS-1 generate
            in_reg_i : entity work.reg_mux
                generic map(MUON_CHARGE_WIDTH, IN_REG_COMP)  
                port map(clk, cc_double(i,j), cc_double_i(i,j));
            comp_i : entity work.comp_unsigned
                generic map(chargeCorr, dummy_limit, dummy_limit, REQ)  
                port map(cc_double_i(i,j), comp_i_double(i,j)(0));
            out_reg_i : entity work.reg_mux
                generic map(1, OUT_REG_COMP)  
                port map(clk, comp_i_double(i,j), comp_r_double(i,j));
            comp_o_double(i,j) <= comp_r_double(i,j)(0);
        end generate l2;
    end generate l1;

end architecture rtl;
