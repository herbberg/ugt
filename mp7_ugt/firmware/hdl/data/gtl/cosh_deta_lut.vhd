-- Description:
-- COSH LUTs of Differences in eta.

-- Version-history:
-- HB 2019-08-20: Changed type of outputs.
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

entity cosh_deta_lut is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        OBJ : obj_type_array
    );
    port(
        sub_eta : in max_eta_range_array;
        cosh_deta_o : out corr_cuts_std_logic_array := (others => (others => (others => '0')))
    );
end cosh_deta_lut;

architecture rtl of cosh_deta_lut is

    signal cosh_deta_i : cosh_cos_vector_array := (others => (others => (others => '0')));
    signal mode : lut_mode;    

begin

--     cosh_deta_p: process(sub_eta)
--         variable calo_calo, calo_muon, muon_muon : boolean := false;    
--     begin
--         if_1: if OBJ(1) = eg_t or OBJ(1) = jet_t or OBJ(1) = tau_t then
--             if_2: if OBJ(2) = eg_t or OBJ(2) = jet_t or OBJ(2) = tau_t then
--                 calo_calo := true;
--             end if;
--         end if;
--         if_3: if OBJ(1) = eg_t or OBJ(1) = jet_t or OBJ(1) = tau_t then
--             if_4: if OBJ(2) = muon_t then
--                 calo_muon := true;
--             end if;
--         end if;
--         if_5: if OBJ(1) = muon_t then
--             if_6: if OBJ(2) = muon_t then
--                 muon_muon := true;
--             end if;
--         end if;
--         loop_1: for i in 0 to N_OBJ_1-1 loop
--             loop_2: for j in 0 to N_OBJ_2-1 loop
--                 calo_calo_i: if (calo_calo) then
--                     cosh_deta_i(i,j)(CALO_CALO_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_COSH_DETA_LUT(sub_eta(i,j)), CALO_CALO_COSH_COS_VECTOR_WIDTH);
--                 end if;
--                 calo_muon_i: if (calo_muon) then
--                     cosh_deta_i(i,j)(CALO_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_MUON_COSH_DETA_LUT(sub_eta(i,j)), CALO_MUON_COSH_COS_VECTOR_WIDTH);
--                 end if;
--                 muon_muon_i: if (muon_muon) then
--                     cosh_deta_i(i,j)(MUON_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_MU_COSH_DETA_LUT(sub_eta(i,j)), MUON_MUON_COSH_COS_VECTOR_WIDTH);
--                 end if;
--             end loop loop_2;
--         end loop loop_1;
--     end process cosh_deta_p;
-- 
    calocalo_1: if OBJ(1) = eg_t or OBJ(1) = jet_t or OBJ(1) = tau_t generate
        calocalo_2: if OBJ(2) = eg_t or OBJ(2) = jet_t or OBJ(2) = tau_t generate
            mode <= CaloCaloCoshDeta;
        end generate calocalo_2;
    end generate calocalo_1;
    calomuon_1: if OBJ(1) = eg_t or OBJ(1) = jet_t or OBJ(1) = tau_t generate
        calomuon_2: if OBJ(2) = muon_t generate
            mode <= CaloMuonCoshDeta;
        end generate calomuon_2;
    end generate calomuon_1;
    muonmuon_1: if OBJ(1) = muon_t generate
        muonmuon_2: if OBJ(2) = muon_t generate
            mode <= MuonMuonCoshDeta;
        end generate muonmuon_2;
    end generate muonmuon_1;
    loop_1: for i in 0 to N_OBJ_1-1 generate
        loop_2: for j in 0 to N_OBJ_2-1 generate
            lut_i : entity work.lut_basic
                generic map(mode)  
                port map(sub_eta(i,j), cosh_deta_i(i,j));
        end generate loop_2;
    end generate loop_1;

    l_3: for i in 0 to N_OBJ_1-1 generate
        l_4: for j in 0 to N_OBJ_2-1 generate
            l_5: for k in 0 to MAX_COSH_COS_WIDTH-1 generate
                cosh_deta_o(i,j,k) <= cosh_deta_i(i,j)(k);
            end generate l_5;
        end generate l_4;
    end generate l_3;

end architecture rtl;
