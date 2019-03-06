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
        data : in gtl_data_record;
        algo_o : out std_logic_vector(NR_ALGOS-1 downto 0));
end gtl_module;

architecture rtl of gtl_module is
    
    signal muon, eg, jet, tau : array_obj_bx_record; 
    signal ett, etm, htt, htm, ettem, etmhf, htmhf : array_obj_bx_record; 
    signal towercount : array_obj_bx_record;
    signal mbt1hfp, mbt1hfm, mbt0hfp, mbt0hfm : array_obj_bx_record; 
    signal asymet, asymht, asymethf, asymhthf : array_obj_bx_record; 
    signal centrality : centrality_array;
    signal ext_cond : ext_cond_array;

    signal algo : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');

-- Output signals - conversions
    signal eg_pt_vector : bx_eg_pt_vector_array;
    signal eg_cos_phi : bx_eg_integer_array;
    signal eg_sin_phi : bx_eg_integer_array;
    signal eg_cos_phi_conv_muon : bx_eg_integer_array;
    signal eg_sin_phi_conv_muon : bx_eg_integer_array;
    signal eg_eta_conv_muon : bx_eg_integer_array;
    signal eg_phi_conv_muon : bx_eg_integer_array;
    signal eg_eta : bx_eg_integer_array;
    signal eg_phi : bx_eg_integer_array;

    signal jet_pt_vector : bx_jet_pt_vector_array;
    signal jet_cos_phi : bx_jet_integer_array;
    signal jet_sin_phi : bx_jet_integer_array;
    signal jet_cos_phi_conv_muon : bx_jet_integer_array;
    signal jet_sin_phi_conv_muon : bx_jet_integer_array;
    signal jet_eta_conv_muon : bx_jet_integer_array;
    signal jet_phi_conv_muon : bx_jet_integer_array;
    signal jet_eta : bx_jet_integer_array;
    signal jet_phi : bx_jet_integer_array;

    signal tau_pt_vector : bx_tau_pt_vector_array;
    signal tau_cos_phi : bx_tau_integer_array;
    signal tau_sin_phi : bx_tau_integer_array;
    signal tau_cos_phi_conv_muon : bx_tau_integer_array;
    signal tau_sin_phi_conv_muon : bx_tau_integer_array;
    signal tau_eta_conv_muon : bx_tau_integer_array;
    signal tau_phi_conv_muon : bx_tau_integer_array;
    signal tau_eta : bx_tau_integer_array;
    signal tau_phi : bx_tau_integer_array;

    signal muon_pt_vector : bx_muon_pt_vector_array;
    signal muon_cos_phi : bx_muon_integer_array;
    signal muon_sin_phi : bx_muon_integer_array;
    signal muon_eta : bx_muon_integer_array;
    signal muon_phi : bx_muon_integer_array;

{{gtl_module_signals}}

begin

-- Additional delay for centrality and ext_cond (no comparators register) and 
-- conversions for eg, jet, tau and muon in "bx_pipeline"

    bx_pipeline_i: entity work.bx_pipeline
        port map(
            lhc_clk,
            data,
            muon, eg, jet, tau, 
            ett, etm, htt, htm, ettem, etmhf, htmhf, 
            towercount,
            mbt1hfp, mbt1hfm, mbt0hfp, mbt0hfm, 
            asymet, asymht, asymethf, asymhthf, 
            centrality,
            ext_cond,
            eg_pt_vector, eg_cos_phi, eg_sin_phi, eg_cos_phi_conv_muon, eg_sin_phi_conv_muon,
            eg_eta_conv_muon, eg_phi_conv_muon, eg_eta, eg_phi,
            jet_pt_vector, jet_cos_phi, jet_sin_phi, jet_cos_phi_conv_muon, jet_sin_phi_conv_muon,
            jet_eta_conv_muon, jet_phi_conv_muon, jet_eta, jet_phi,
            tau_pt_vector, tau_cos_phi, tau_sin_phi, tau_cos_phi_conv_muon, tau_sin_phi_conv_muon,
            tau_eta_conv_muon, tau_phi_conv_muon, tau_eta, tau_phi,
            muon_pt_vector, muon_cos_phi, muon_sin_phi, muon_eta, muon_phi
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
