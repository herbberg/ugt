-- Description:
-- COS LUTs of Differences in phi.

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

entity cos_dphi_lut is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        OBJ : obj_type_array
    );
    port(
        sub_phi : in max_phi_range_array;
        cos_dphi_o : out cosh_cos_vector_array := (others => (others => (others => '0')))
    );
end cos_dphi_lut;

architecture rtl of cos_dphi_lut is

begin

    cos_dphi_p: process(sub_phi)
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
                    cos_dphi_o(i,j)(CALO_CALO_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_COS_DPHI_LUT(sub_phi(i,j)), CALO_CALO_COSH_COS_VECTOR_WIDTH);
                end if;
                calo_muon_i: if (calo_muon) then
                    cos_dphi_o(i,j)(CALO_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_MUON_COS_DPHI_LUT(sub_phi(i,j)), CALO_MUON_COSH_COS_VECTOR_WIDTH);
                end if;
                muon_muon_i: if (muon_muon) then
                    cos_dphi_o(i,j)(MUON_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MUON_MUON_COS_DPHI_LUT(sub_phi(i,j)), MUON_MUON_COSH_COS_VECTOR_WIDTH);
                end if;
            end loop loop_2;
        end loop loop_1;
    end process cos_dphi_p;

end architecture rtl;
