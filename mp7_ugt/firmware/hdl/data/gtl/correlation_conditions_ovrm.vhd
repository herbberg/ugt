-- Description:
-- Correlation conditions with overlap removal.

-- Version-history:
-- HB 2019-09-02: Inserted generic parameter and logic for "2 plus 1" objects and "1 plus 1" objects.
-- HB 2019-08-29: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity correlation_conditions_ovrm is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_3 : positive;
        SLICES : slices_type_array;
        CHARGE_CORR_SEL : boolean := false;
        obj_2plus1 : boolean := true
    );
    port(
        clk : in std_logic;
        in_1 : in std_logic_vector(0 to N_OBJ_1-1);
        in_3 : in std_logic_vector(0 to N_OBJ_3-1);        
        deta : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_1-1) := (others => (others => '1'));
        dphi : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_1-1) := (others => (others => '1'));
        delta_r : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_1-1) := (others => (others => '1'));
        inv_mass : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_1-1) := (others => (others => '1'));
        trans_mass : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_1-1) := (others => (others => '1'));
        tbpt : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_1-1) := (others => (others => '1'));
        charge_corr_double : in muon_cc_double_std_logic_array := (others => (others => '1'));
        deta_ovrm : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_3-1) := (others => (others => '0'));
        dphi_ovrm : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_3-1) := (others => (others => '0'));
        dr_ovrm : in corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_3-1) := (others => (others => '0'));
        cond_o : out std_logic
    );
end correlation_conditions_ovrm;

architecture rtl of correlation_conditions_ovrm is

    constant N_SLICE_1 : positive := SLICES(1)(1) - SLICES(1)(0) + 1;
    constant N_SLICE_2 : positive := SLICES(2)(1) - SLICES(2)(0) + 1;
    constant N_SLICE_3 : positive := SLICES(3)(1) - SLICES(3)(0) + 1;
    signal cc_double_i : corr_cuts_array(0 to N_OBJ_1-1, 0 to N_OBJ_1-1) := (others => (others => '1'));
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
    and_or_p: process(in_1, in_3, deta, dphi, delta_r, inv_mass, trans_mass, tbpt, cc_double_i, dr_ovrm, deta_ovrm, dphi_ovrm)
        variable index : integer := 0;
        type tmp_12_array is array (SLICES(1)(0) to SLICES(1)(1), SLICES(2)(0) to SLICES(2)(1)) of std_logic;
        variable corr_vec : tmp_12_array := (others => (others => '0'));
        type tmp_13_array is array (SLICES(1)(0) to SLICES(1)(1), SLICES(3)(0) to SLICES(3)(1)) of std_logic;
        variable ovrm_13_vec : tmp_13_array := (others => (others => '0'));
        type tmp_23_array is array (SLICES(2)(0) to SLICES(2)(1), SLICES(3)(0) to SLICES(3)(1)) of std_logic;
        variable ovrm_23_vec : tmp_23_array := (others => (others => '0'));
        variable corr_ovrm_index_vec_123 : std_logic_vector((N_SLICE_1*N_SLICE_1*N_SLICE_3) downto 1) := (others => '0');
        variable corr_ovrm_index_vec_13 : std_logic_vector((N_SLICE_1*N_SLICE_3) downto 1) := (others => '0');
        variable tmp : std_logic := '0';
    begin
        index := 0;
        tmp := '0';
        if obj_2plus1 then
            for i in SLICES(1)(0) to SLICES(1)(1) loop
                for j in SLICES(2)(0) to SLICES(2)(1) loop
                    if j/=i then 
                        corr_vec(i,j) := deta(i,j) and dphi(i,j) and delta_r(i,j) and inv_mass(i,j) and trans_mass(i,j) and tbpt(i,j) and cc_double_i(i,j);
                        for k in SLICES(3)(0) to SLICES(3)(1) loop
                            ovrm_13_vec(i,k) := dr_ovrm(i,k) or deta_ovrm(i,k) or dphi_ovrm(i,k);
                            ovrm_23_vec(j,k) := dr_ovrm(j,k) or deta_ovrm(j,k) or dphi_ovrm(j,k);
                            index := index + 1;
                            corr_ovrm_index_vec_123(index) := in_1(i) and in_1(j) and in_3(k) and corr_vec(i,j) and not ((ovrm_13_vec(i,k) or ovrm_23_vec(j,k)) and in_3(k));
                        end loop;
                    end if;
                end loop;
            end loop;
            for i in 1 to index loop
                tmp := tmp or corr_ovrm_index_vec_123(i);
            end loop;
        else
            for i in SLICES(1)(0) to SLICES(1)(1) loop
                for j in SLICES(3)(0) to SLICES(3)(1) loop
                    corr_vec(i,j) := deta(i,j) and dphi(i,j) and delta_r(i,j) and inv_mass(i,j) and trans_mass(i,j) and tbpt(i,j) and cc_double_i(i,j);
                    index := index + 1;
                    corr_ovrm_index_vec_13(index) := in_1(i) and in_3(j) and deta(i,j) and corr_vec(i,j) and not 
                        ((dr_ovrm(i,j) or deta_ovrm(i,j) or dphi_ovrm(i,j)) and in_3(j));
                end loop;
            end loop;
            for i in 1 to index loop
                tmp := tmp or corr_ovrm_index_vec_13(i);
            end loop;        
        end if;        
        cond_and_or(0) <= tmp;
    end process and_or_p;

-- Condition output register (default setting: no register)
    out_reg_i : entity work.reg_mux
        generic map(1, OUT_REG_COND)  
        port map(clk, cond_and_or, cond_o_v);
    
    cond_o <= cond_o_v(0);
    
end architecture rtl;



