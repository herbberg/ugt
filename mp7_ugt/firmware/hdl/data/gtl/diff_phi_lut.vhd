--- Description:
-- Differences in phi LUTs.

-- Version-history:
-- HB 2019-06-27: Changed type of inputs.
-- HB 2019-01-11: First design.

library ieee;
use ieee.std_logic_1164.all;

-- used for CONV_STD_LOGIC_VECTOR
use ieee.std_logic_arith.all;
-- used for CONV_INTEGER
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;
use work.lut_pkg.all;

entity diff_phi_lut is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        OBJ : obj_type_array
    );
    port(
--         sub_phi : in dim2_max_phi_range_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1);
        sub_phi : in max_phi_range_array;
        diff_phi_o : out deta_dphi_vector_array := (others => (others => (others => '0')))
    );
end diff_phi_lut;

architecture rtl of diff_phi_lut is

begin

    diff_phi_p: process(sub_phi)
        variable calo_calo, calo_muon, muon_muon : boolean := false;    
    begin
        if_1: if OBJ(1) = eg_t or OBJ(1) = jet_t or OBJ(1) = tau_t then
            if_2: if OBJ(2) = eg_t or OBJ(2) = jet_t or OBJ(2) = tau_t or OBJ(2) = etm_t or OBJ(2) = htm_t or OBJ(2) = etmhf_t or OBJ(2) = htmhf_t then
                calo_calo := true;
            end if;
        end if;
        if_3: if OBJ(1) = eg_t or OBJ(1) = jet_t or OBJ(1) = tau_t then
            if_4: if OBJ(2) = muon_t then
                calo_muon := true;
            end if;
        end if;
        if_5: if OBJ(1) = muon_t then
            if_6: if OBJ(2) = etm_t or OBJ(2) = htm_t or OBJ(2) = etmhf_t or OBJ(2) = htmhf_t then
                calo_muon := true;
            end if;
        end if;
        if_7: if OBJ(1) = muon_t then
            if_8: if OBJ(2) = muon_t then
                muon_muon := true;
            end if;
        end if;
        loop_1: for i in 0 to N_OBJ_1-1 loop
            loop_2: for j in 0 to N_OBJ_2-1 loop
                calo_calo_i: if (calo_calo) then
                    diff_phi_o(i,j) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_DIFF_PHI_LUT(sub_phi(i,j)), DETA_DPHI_VECTOR_WIDTH);
                end if;
                calo_muon_i: if (calo_muon) then
                    diff_phi_o(i,j) <= CONV_STD_LOGIC_VECTOR(CALO_MU_DIFF_PHI_LUT(sub_phi(i,j)), DETA_DPHI_VECTOR_WIDTH);
                end if;
                muon_muon_i: if (muon_muon) then
                    diff_phi_o(i,j) <= CONV_STD_LOGIC_VECTOR(MU_MU_DIFF_PHI_LUT(sub_phi(i,j)), DETA_DPHI_VECTOR_WIDTH);
                end if;
            end loop loop_2;
        end loop loop_1;
    end process diff_phi_p;

end architecture rtl;
