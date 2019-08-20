-- Description:
-- Object cuts lut comparisons.

-- Version-history:
-- HB 2019-08-20: First design.

library ieee;
use ieee.std_logic_1164.all;

-- used for CONV_INTEGER
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;
use work.lut_pkg.all;

entity lut_basic is
    generic(
        VECTOR_WIDTH : positive;
        MODE : lut_mode := CaloCaloDeta
    );
    port(
        lut_in : in integer;
        lut_o : out integer
    );
end lut_basic;

architecture rtl of lut_basic is

begin

CaloCaloDeta_i: if MODE = CaloCaloDeta generate
    lut_o(VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_DIFF_ETA_LUT(lut_in), VECTOR_WIDTH);
end generate;

CaloMuonDeta_i: if MODE = CaloMuonDeta generate
    lut_o(VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_MU_DIFF_ETA_LUT(lut_in), VECTOR_WIDTH);
end generate;

MuonMuonDeta_i: if MODE = MuonMuonDeta generate
    lut_o(VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_MU_DIFF_ETA_LUT(lut_in), VECTOR_WIDTH);
end generate;

CaloCaloDphi_i: if MODE = CaloCaloDphi generate
    lut_o(VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_DIFF_PHI_LUT(lut_in), VECTOR_WIDTH);
end generate;

CaloMuonDphi_i: if MODE = CaloMuonDphi generate
    lut_o(VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_MU_DIFF_PHI_LUT(lut_in), VECTOR_WIDTH);
end generate;

MuonMuonDphi_i: if MODE = MuonMuonDphi generate
    lut_o(VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_MU_DIFF_PHI_LUT(lut_in), VECTOR_WIDTH);
end generate;

CaloCaloCoshDeta_i: if MODE = CaloCaloCoshDeta generate
    lut_o(VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_COSH_DETA_LUT(lut_in), VECTOR_WIDTH);
end generate;

CaloMuonCoshDeta_i: if MODE = CaloMuonCoshDeta generate
    lut_o(VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_MU_COSH_DETA_LUT(lut_in), VECTOR_WIDTH);
end generate;

MuonMuonCoshDeta_i: if MODE = MuonMuonCoshDeta generate
    lut_o(VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_MU_COSH_DETA_LUT(lut_in), VECTOR_WIDTH);
end generate;

CaloCaloCosDphi_i: if MODE = CaloCaloCosDphi generate
    lut_o(VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_COS_DPHI_LUT(lut_in), VECTOR_WIDTH);
end generate;

CaloMuonCosDphi_i: if MODE = CaloMuonCosDphi generate
    lut_o(VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_MU_COS_DPHI_LUT(lut_in), VECTOR_WIDTH);
end generate;

MuonMuonCosDphi_i: if MODE = MuonMuonCosDphi generate
    lut_o(VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_MU_COS_DPHI_LUT(lut_in), VECTOR_WIDTH);
end generate;

end architecture rtl;
