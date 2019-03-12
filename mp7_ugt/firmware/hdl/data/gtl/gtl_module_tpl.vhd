-- Description:
-- Global Trigger Logic module.

-- Version-history:
-- HB 2018-11-29: v2.0.0: Version for GTL_v2.x.y.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;
use work.lut_pkg.all;

entity gtl_module is
    port(
        lhc_clk : in std_logic;
        data_in : in gtl_data_record;
        algo_o : out std_logic_vector(NR_ALGOS-1 downto 0));
end gtl_module;

architecture rtl of gtl_module is
    
    signal data_p : data_pipeline_record;
    signal conv : conversions_record;
    signal algo : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');

{{gtl_module_signals}}

begin

    bx_pipeline_i: entity work.bx_pipeline
        port map(
            lhc_clk, data_in, data_p, conv
        );

{{gtl_module_instances}}

-- Pipeline stages for algorithms
    algo_pipeline_i: entity work.delay_pipeline
        generic map(
            DATA_WIDTH => NR_ALGOS,
            STAGES => ALGO_REG_STAGES
        )
        port map(
            lhc_clk, algo, algo_o
        );

end architecture rtl;
