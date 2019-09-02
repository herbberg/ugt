-- Description:
-- Correlation conditions with overlap removal.

-- Version-history:
-- HB 2019-08-29: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity correlation_conditions_ovrm is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        N_OBJ_3 : positive;
        SLICES : slices_type_array;
        CHARGE_CORR_SEL : boolean := false
    );
    port(
        clk : in std_logic;
        in_1 : in std_logic_vector(0 to N_OBJ_1-1);
        in_2 : in std_logic_vector(0 to N_OBJ_2-1);        
        in_3 : in std_logic_vector(0 to N_OBJ_3-1);        
        deta : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => '1'));
        dphi : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => '1'));
        delta_r : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => '1'));
        inv_mass : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => '1'));
        trans_mass : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => '1'));
        tbpt : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => '1'));
        charge_corr_double : in muon_cc_double_std_logic_array := (others => (others => '1'));
        deta_ovrm_13 : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_3-1) := (others => (others => '0'));
        deta_ovrm_23 : in corr_cuts_array(0 to N_OBJ_2-1, 0 to N_OBJ_3-1) := (others => (others => '0'));
        dphi_ovrm_13 : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_3-1) := (others => (others => '0'));
        dphi_ovrm_23 : in corr_cuts_array(0 to N_OBJ_2-1, 0 to N_OBJ_3-1) := (others => (others => '0'));
        dr_ovrm_13 : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_3-1) := (others => (others => '0'));
        dr_ovrm_23 : in corr_cuts_array(0 to N_OBJ_2-1, 0 to N_OBJ_3-1) := (others => (others => '0'));
        cond_o : out std_logic
    );
end correlation_conditions_ovrm;

architecture rtl of correlation_conditions_ovrm is

    constant N_SLICE_1 : positive := SLICES(1)(1) - SLICES(1)(0) + 1;
    constant N_SLICE_2 : positive := SLICES(2)(1) - SLICES(2)(0) + 1;
    constant N_SLICE_3 : positive := SLICES(3)(1) - SLICES(3)(0) + 1;
    signal cc_double_i : corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => '1'));
    signal cond_and_or, cond_o_v : std_logic_vector(0 to 0);

begin

-- Creating internal charge correlations for muon objects
    cc_i: if CHARGE_CORR_SEL generate
        l1: for i in 0 to N_MUON_OBJECTS-1 generate
            l2: for j in 0 to N_MUON_OBJECTS-1 generate
                cc_double_i(i,j) <= charge_corr_double(i,j);
             end generate;    
        end generate;    
    end generate;    

-- AND-OR matrix
    and_or_p: process(in_1, in_2, deta, dphi, delta_r, inv_mass, trans_mass, tbpt, cc_double_i)
        variable index : integer := 0;
        type vec_array is array (SLICES(1)(0) to SLICES(1)(1), SLICES(2)(0) to SLICES(2)(1), SLICES(3)(0) to SLICES(3)(1)) of std_logic;
        type tmp_array is array (SLICES(1)(0) to SLICES(1)(1), SLICES(2)(0) to SLICES(2)(1)) of std_logic;
        variable corr_vec, ovrm_vec : vec_array := (others => (others => (others => '0')));
        variable corr_vec_tmp, ovrm_vec_tmp, corr_ovrm_tmp : tmp_array := (others => (others => '0'));
        variable corr_ovrm_index_vec : std_logic_vector((N_SLICE_1*N_SLICE_2) downto 1) := (others => '0');
        variable tmp : std_logic := '0';
    begin
        index := 0;
        tmp := '0';
        for i in SLICES(1)(0) to SLICES(1)(1) loop
            for j in SLICES(2)(0) to SLICES(2)(1) loop
                if j/=i then 
                    for k in SLICES(3)(0) to SLICES(3)(1) loop
                        corr_vec(i,j,k) := in_1(i) and in_2(j) and in_3(k) and deta(i,j) and dphi(i,j) and delta_r(i,j) and 
                            inv_mass(i,j) and trans_mass(i,j) and tbpt(i,j) and cc_double_i(i,j);
                        corr_vec_tmp(i,j) := corr_vec_tmp(i,j) or corr_vec(i,j,k);
                        ovrm_vec(i,j,k) := (dr_ovrm_13(i,k) or dr_ovrm_23(j,k) or deta_ovrm_13(i,k) or deta_ovrm_23(j,k) or 
                            dphi_ovrm_13(i,k) or dphi_ovrm_23(j,k)) and in_3(k);
                        ovrm_vec_tmp(i,j) := ovrm_vec_tmp(i,j) or ovrm_vec(i,j,k);
                    end loop;
                    index := index + 1;
                    corr_ovrm_tmp(i,j) := corr_vec_tmp(i,j) and not ovrm_vec_tmp(i,j);
                    corr_ovrm_index_vec(index) := corr_ovrm_tmp(i,j);
               end if;
            end loop;
        end loop;
        for i in 1 to index loop
            tmp := tmp or corr_ovrm_index_vec(i);
        end loop;
        cond_and_or(0) <= tmp;
    end process and_or_p;

-- Condition output register (default setting: no register)
    out_reg_i : entity work.reg_mux
        generic map(1, OUT_REG_COND)  
        port map(clk, cond_and_or, cond_o_v);
    
    cond_o <= cond_o_v(0);
    
end architecture rtl;



