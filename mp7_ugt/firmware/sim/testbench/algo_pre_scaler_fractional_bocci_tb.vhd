
-- Description:
-- Testbench for prescalers (FDL) with fractional prescale values

-- Version history:
-- HB 2019-05-31: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.math_pkg.all;
-- use work.algo_pre_scaler_fractional_tb_pkg.all;

entity algo_pre_scaler_fractional_TB is
end algo_pre_scaler_fractional_TB;

architecture beh of algo_pre_scaler_fractional_TB is

    constant SIM : boolean := true;
    
    constant PRESCALE_FACTOR_FRACTION_DIGITS : integer := 2;
    constant PRESCALE_FACTOR_WIDTH : integer := 32;
    constant PRESCALE_FACTOR_DENOMINATOR_WIDTH : integer := 8; -- max. value = 99 with PRESCALE_FACTOR_FRACTION_DIGITS = 2 
    constant PRESCALE_FACTOR_NUMORATOR_WIDTH : integer := PRESCALE_FACTOR_WIDTH - PRESCALE_FACTOR_DENOMINATOR_WIDTH; -- value = 24
    
    constant PRESCALE_FACTOR_INIT : std_logic_vector(31 downto 0) := X"00000101"; -- value = 1/1 = 1
    constant PRESCALER_INCR : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR((10**PRESCALE_FACTOR_FRACTION_DIGITS), 32);

--     constant PRESCALE_FACTOR_VALUE_VEC : std_logic_vector(31 downto 0) := X"00000383"; -- value = 7/3 
--     constant PRESCALE_FACTOR_VALUE_VEC : std_logic_vector(31 downto 0) := X"00000203"; -- value = 4/3 
    constant PRESCALE_FACTOR_VALUE_VEC : std_logic_vector(31 downto 0) := X"0000D363"; -- value = 211/99 
--     constant PRESCALE_FACTOR_VALUE_VEC : std_logic_vector(31 downto 0) := X"00006401"; -- value = 100/1 
        
    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;
    signal sres_counter, request_update_factor_pulse, update_factor_pulse : std_logic := '0';
    signal algo : std_logic := '1';
    signal algo_o : std_logic;
    signal prescale_factor : std_logic_vector(PRESCALE_FACTOR_WIDTH-1 downto 0) := (others => '0');
    signal index_sim : integer;
    signal algo_cnt_sim : natural;
    signal prescaled_algo_cnt_sim : natural;
    
--*********************************Main Body of Code**********************************
begin
    
    -- Clock
    process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;

--     -- Algo
--     process
--     begin
--         algo  <=  '1';
--         wait for LHC_CLK_PERIOD;
--         algo  <=  '0';
--         wait for 10*LHC_CLK_PERIOD;
--     end process;

    process
    begin
	wait for LHC_CLK_PERIOD; 
    prescale_factor <= PRESCALE_FACTOR_VALUE_VEC;
	wait for 5*LHC_CLK_PERIOD;
	request_update_factor_pulse <= '1';
	wait for LHC_CLK_PERIOD;
	request_update_factor_pulse <= '0';
	wait for 5*LHC_CLK_PERIOD;
	update_factor_pulse <= '1';
	wait for LHC_CLK_PERIOD;
	update_factor_pulse <= '0';
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

    dut: entity work.algo_pre_scaler
        generic map(PRESCALE_FACTOR_WIDTH, PRESCALE_FACTOR_INIT, SIM)
        port map(
        clk => lhc_clk,
        sres_counter => sres_counter,
        algo_i => algo,
        request_update_factor_pulse => request_update_factor_pulse,
        update_factor_pulse => update_factor_pulse,
        prescale_factor => prescale_factor,
        prescaled_algo_o => open,
        index_sim => open,
        prescaled_algo_cnt_sim => prescaled_algo_cnt_sim,
        algo_cnt_sim => algo_cnt_sim
        );

end beh;

