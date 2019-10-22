-- Description:
-- Combinatorial conditions with overlap removal

-- Version-history:
-- HB 2019-10-17: Bug fixed.
-- HB 2019-10-14: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity combinatorial_conditions_ovrm is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        N_REQ : positive;
        SLICES : slices_type_array;
        SLICES_OVRM : slices_type_array;
        CHARGE_CORR_SEL : boolean
    );
    port(
        clk : in std_logic;        
        comb_1 : in std_logic_vector(0 to N_OBJ_1-1) := (others => '0');
        comb_2 : in std_logic_vector(0 to N_OBJ_1-1) := (others => '0');
        comb_3 : in std_logic_vector(0 to N_OBJ_1-1) := (others => '0');
        comb_4 : in std_logic_vector(0 to N_OBJ_1-1) := (others => '0');
        comb_ovrm : in std_logic_vector(0 to N_OBJ_2-1) := (others => '0');
        tbpt : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_1-1) := (others => (others => '1'));
        charge_corr_double : in muon_cc_double_std_logic_array := (others => (others => '1'));
        charge_corr_triple : in muon_cc_triple_std_logic_array := (others => (others => (others => '1')));
        charge_corr_quad : in muon_cc_quad_std_logic_array := (others => (others => (others => (others => '1'))));
        deta_ovrm : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => '0'));
        dphi_ovrm : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => '0'));
        dr_ovrm : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => '0'));
        cond_o : out std_logic
    );
end combinatorial_conditions_ovrm;

architecture rtl of combinatorial_conditions_ovrm is

    constant N_SLICE_1 : positive := SLICES(1)(1) - SLICES(1)(0) + 1;
    constant N_SLICE_2 : positive := SLICES(2)(1) - SLICES(2)(0) + 1;
    constant N_SLICE_3 : positive := SLICES(3)(1) - SLICES(3)(0) + 1;
    constant N_SLICE_4 : positive := SLICES(4)(1) - SLICES(4)(0) + 1;
    constant N_SLICE_OVRM : positive := SLICES_OVRM(1)(1) - SLICES_OVRM(1)(0) + 1;
    
    type double_array is array (0 to N_OBJ_1-1, 0 to N_OBJ_1-1) of std_logic;
    type triple_array is array (0 to N_OBJ_1-1, 0 to N_OBJ_1-1, 0 to N_OBJ_1-1) of std_logic;
    type quad_array is array (0 to N_OBJ_1-1, 0 to N_OBJ_1-1, 0 to N_OBJ_1-1, 0 to N_OBJ_1-1) of std_logic;
    signal cc_double_i : double_array := (others => (others => '1'));
    signal cc_triple_i : triple_array := (others => (others => (others => '1')));
    signal cc_quad_i : quad_array := (others => (others => (others => (others => '1'))));
    signal cond_and_or, cond_o_v : std_logic_vector(0 to 0);

begin

-- Creating internal charge correlations for muon objects
    cc_i: if CHARGE_CORR_SEL generate
        l1: for i in 0 to N_MUON_OBJECTS-1 generate
            l2: for j in 0 to N_MUON_OBJECTS-1 generate
                cc_double_i(i,j) <= charge_corr_double(i,j);
                l3: for k in 0 to N_MUON_OBJECTS-1 generate
                    cc_triple_i(i,j,k) <= charge_corr_triple(i,j,k);
                    l4: for l in 0 to N_MUON_OBJECTS-1 generate
                        cc_quad_i(i,j,k,l) <= charge_corr_quad(i,j,k,l);
                    end generate;    
                end generate;    
            end generate;    
        end generate;    
    end generate;    

-- AND-OR matrix
    and_or_p: process(comb_1, comb_2, comb_3, comb_4, cc_double_i, cc_triple_i, cc_quad_i, tbpt)
        variable index : integer := 0;
        variable and_vec : std_logic_vector((N_SLICE_1*N_SLICE_2*N_SLICE_3*N_SLICE_4*N_SLICE_OVRM) downto 1) := (others => '0');
        variable tmp : std_logic := '0';
    begin
        index := 0;
        and_vec := (others => '0');
        tmp := '0';
        for m in SLICES_OVRM(1)(0) to SLICES_OVRM(1)(1) loop
            for i in SLICES(1)(0) to SLICES(1)(1) loop
                if N_REQ = 1 then
                    index := index + 1;
                    and_vec(index) := comb_1(i) and comb_ovrm(m) and not ((deta_ovrm(i,m) or dphi_ovrm(i,m) or dr_ovrm(i,m)) and comb_ovrm(m));
                end if;
                for j in SLICES(2)(0) to SLICES(2)(1) loop
                    if N_REQ = 2 and (j/=i) then
                        index := index + 1;
                        and_vec(index) := comb_1(i) and comb_2(j) and cc_double_i(i,j) and tbpt(i,j) and comb_ovrm(m) and not
                        ((deta_ovrm(i,m) or dphi_ovrm(i,m) or dr_ovrm(i,m) or deta_ovrm(j,m) or dphi_ovrm(j,m) or dr_ovrm(j,m)) and comb_ovrm(m));
                    end if;
                    for k in SLICES(3)(0) to SLICES(3)(1) loop
                        if N_REQ = 3 and (j/=i and k/=i and k/=j) then
                            index := index + 1;
                            and_vec(index) := comb_1(i) and comb_2(j) and comb_3(k) and cc_triple_i(i,j,k) and comb_ovrm(m) and not
                            ((deta_ovrm(i,m) or dphi_ovrm(i,m) or dr_ovrm(i,m) or deta_ovrm(j,m) or dphi_ovrm(j,m) or dr_ovrm(j,m) or 
                            deta_ovrm(k,m) or dphi_ovrm(k,m) or dr_ovrm(k,m)) and comb_ovrm(m));
                        end if;                        
                        for l in SLICES(4)(0) to SLICES(4)(1) loop
                            if N_REQ = 4 and (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) then
                                index := index + 1;
                                and_vec(index) := comb_1(i) and comb_2(j) and comb_3(k) and comb_4(l) and cc_quad_i(i,j,k,l) and comb_ovrm(m) and not
                                ((deta_ovrm(i,m) or dphi_ovrm(i,m) or dr_ovrm(i,m) or deta_ovrm(j,m) or dphi_ovrm(j,m) or dr_ovrm(j,m) or
                                deta_ovrm(k,m) or dphi_ovrm(k,m) or dr_ovrm(k,m) or deta_ovrm(l,m) or dphi_ovrm(l,m) or dr_ovrm(l,m)) and comb_ovrm(m));
                            end if;
                        end loop;
                    end loop;
                end loop;
            end loop;
        end loop;
        for i in 1 to index loop
            tmp := tmp or and_vec(i);
        end loop;
        cond_and_or(0) <= tmp;
    end process and_or_p;

-- Condition output register (default setting: no register)
    out_reg_i : entity work.reg_mux
        generic map(1, OUT_REG_COND)  
        port map(clk, cond_and_or, cond_o_v);
    
    cond_o <= cond_o_v(0);
    
end architecture rtl;



