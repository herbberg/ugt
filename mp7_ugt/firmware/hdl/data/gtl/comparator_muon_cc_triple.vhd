-- Description:
-- Comparators for muon charge correlation triple.

-- Version-history:
-- HB 2019-08-27: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity comparator_muon_cc_triple is
    generic(
        REQ : std_logic_vector(MUON_CHARGE_WIDTH-1 downto 0)
    );
    port(
        clk : in std_logic;
        cc_triple: in muon_cc_triple_array := (others => (others => (others => (others => '0'))));
        comp_o_triple : out muon_cc_triple_std_logic_array
    );
end comparator_muon_cc_triple;

architecture rtl of comparator_muon_cc_triple is
        
    signal cc_triple_i :muon_cc_triple_array;
    
    type comp_i_triple_array is array (0 to N_MUON_OBJECTS-1, 0 to N_MUON_OBJECTS-1, 0 to N_MUON_OBJECTS-1) of std_logic_vector(0 downto 0);
    signal comp_i_triple : comp_i_triple_array := (others => (others => (others => (others => '0'))));
    signal comp_r_triple : comp_i_triple_array;
    constant dummy_limit : std_logic_vector(1 downto 0) := (others => '0');

begin
    
    l1: for i in 0 to N_MUON_OBJECTS-1 generate
        l2: for j in 0 to N_MUON_OBJECTS-1 generate
            l3: for k in 0 to N_MUON_OBJECTS-1 generate
                in_reg_i : entity work.reg_mux
                    generic map(MUON_CHARGE_WIDTH, IN_REG_COMP)  
                    port map(clk, cc_triple(i,j,k), cc_triple_i(i,j,k));
                comp_i : entity work.comp_unsigned
                    generic map(chargeCorr, dummy_limit, dummy_limit, REQ)  
                    port map(cc_triple_i(i,j,k), comp_i_triple(i,j,k)(0));
                out_reg_i : entity work.reg_mux
                    generic map(1, OUT_REG_COMP)  
                    port map(clk, comp_i_triple(i,j,k), comp_r_triple(i,j,k));
                comp_o_triple(i,j,k) <= comp_r_triple(i,j,k)(0);
            end generate l3;
        end generate l2;
    end generate l1;

end architecture rtl;
