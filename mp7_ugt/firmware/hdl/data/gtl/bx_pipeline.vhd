-- Description:
-- Pipeline for +/-2 bx data.

-- Version-history: 
-- HB 2019-03-07: used records for pipeline and conversion data..
-- HB 2019-02-25: included conversions for eg, jet, tau and muon.
-- HB 2019-01-23: included additional delay for centrality and ext_cond (no comparators and conditions)

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity bx_pipeline is
    port(
        clk : in std_logic;
        data_in : in gtl_data_record;
        data_pipe_o : out data_pipeline_record;
        conv_o : out conversions_record
    );
end bx_pipeline;

architecture rtl of bx_pipeline is

    type array_gtl_data_record is array (0 to BX_PIPELINE_STAGES-1) of gtl_data_record;       
    signal data_tmp : array_gtl_data_record;
    signal data_pipe_internal : data_pipeline_record;

begin

-- BX pipeline
    process(clk, data_in)
    begin
        data_tmp(0) <= data_in;
        for i in 0 to (BX_PIPELINE_STAGES-1)-1 loop
            if (clk'event and clk = '1') then
                data_tmp(i+1) <= data_tmp(i);
            end if;
        end loop;
    end process;
    
-- BX pipeline

    bx_l: for i in 0 to BX_PIPELINE_STAGES-1 generate
        muon_l: for j in 0 to N_MUON_OBJECTS-1 generate
            data_pipe_internal.muon(i).pt(j)(data_tmp(i).muon(j).pt'length-1 downto 0) <= data_tmp(i).muon(j).pt;
            data_pipe_internal.muon(i).eta(j)(data_tmp(i).muon(j).eta'length-1 downto 0) <= data_tmp(i).muon(j).eta;
            data_pipe_internal.muon(i).phi(j)(data_tmp(i).muon(j).phi'length-1 downto 0) <= data_tmp(i).muon(j).phi;
            data_pipe_internal.muon(i).iso(j)(data_tmp(i).muon(j).iso'length-1 downto 0) <= data_tmp(i).muon(j).iso;
            data_pipe_internal.muon(i).qual(j)(data_tmp(i).muon(j).qual'length-1 downto 0) <= data_tmp(i).muon(j).qual;
            data_pipe_internal.muon(i).charge(j)(data_tmp(i).muon(j).charge'length-1 downto 0) <= data_tmp(i).muon(j).charge;
        end generate muon_l;
        eg_l: for j in 0 to N_EG_OBJECTS-1 generate            
            data_pipe_internal.eg(i).pt(j)(data_tmp(i).eg(j).pt'length-1 downto 0) <= data_tmp(i).eg(j).pt;
            data_pipe_internal.eg(i).eta(j)(data_tmp(i).eg(j).eta'length-1 downto 0) <= data_tmp(i).eg(j).eta;
            data_pipe_internal.eg(i).phi(j)(data_tmp(i).eg(j).phi'length-1 downto 0) <= data_tmp(i).eg(j).phi;
            data_pipe_internal.eg(i).iso(j)(data_tmp(i).eg(j).iso'length-1 downto 0) <= data_tmp(i).eg(j).iso;
        end generate eg_l;
        jet_l: for j in 0 to N_JET_OBJECTS-1 generate
            data_pipe_internal.jet(i).pt(j)(data_tmp(i).jet(j).pt'length-1 downto 0) <= data_tmp(i).jet(j).pt;
            data_pipe_internal.jet(i).eta(j)(data_tmp(i).jet(j).eta'length-1 downto 0) <= data_tmp(i).jet(j).eta;
            data_pipe_internal.jet(i).phi(j)(data_tmp(i).jet(j).phi'length-1 downto 0) <= data_tmp(i).jet(j).phi;
        end generate jet_l;
        tau_l: for j in 0 to N_TAU_OBJECTS-1 generate
            data_pipe_internal.tau(i).pt(j)(data_tmp(i).tau(j).pt'length-1 downto 0) <= data_tmp(i).tau(j).pt;
            data_pipe_internal.tau(i).eta(j)(data_tmp(i).tau(j).eta'length-1 downto 0) <= data_tmp(i).tau(j).eta;
            data_pipe_internal.tau(i).phi(j)(data_tmp(i).tau(j).phi'length-1 downto 0) <= data_tmp(i).tau(j).phi;
            data_pipe_internal.tau(i).iso(j)(data_tmp(i).tau(j).iso'length-1 downto 0) <= data_tmp(i).tau(j).iso;
        end generate tau_l;
        
-- Output bx pipeline object parameters (esums, towercount, minimum bias, asymetry)

        data_pipe_o.ett(i).pt(0)(data_tmp(i).ett.pt'length-1 downto 0) <= data_tmp(i).ett.pt;
        
        data_pipe_o.ettem(i).pt(0)(data_tmp(i).ettem.pt'length-1 downto 0) <= data_tmp(i).ettem.pt;
        
        data_pipe_o.etm(i).pt(0)(data_tmp(i).etm.pt'length-1 downto 0) <= data_tmp(i).etm.pt;
        data_pipe_o.etm(i).phi(0)(data_tmp(i).etm.phi'length-1 downto 0) <= data_tmp(i).etm.phi;
        
        data_pipe_o.htt(i).pt(0)(data_tmp(i).htt.pt'length-1 downto 0) <= data_tmp(i).htt.pt;
        
        data_pipe_o.htm(i).pt(0)(data_tmp(i).htm.pt'length-1 downto 0) <= data_tmp(i).htm.pt;
        data_pipe_o.htm(i).phi(0)(data_tmp(i).htm.phi'length-1 downto 0) <= data_tmp(i).htm.phi;
        
        data_pipe_o.etmhf(i).pt(0)(data_tmp(i).etmhf.pt'length-1 downto 0) <= data_tmp(i).etmhf.pt;
        data_pipe_o.etmhf(i).phi(0)(data_tmp(i).etmhf.phi'length-1 downto 0) <= data_tmp(i).etmhf.phi;
        
        data_pipe_o.htmhf(i).pt(0)(data_tmp(i).htmhf.pt'length-1 downto 0) <= data_tmp(i).htmhf.pt;
        data_pipe_o.htmhf(i).phi(0)(data_tmp(i).htmhf.phi'length-1 downto 0) <= data_tmp(i).htmhf.phi;
        
        data_pipe_o.towercount(i).count(0)(data_tmp(i).towercount.count'length-1 downto 0) <= data_tmp(i).towercount.count;
        
        data_pipe_o.mbt1hfp(i).count(0)(data_tmp(i).mbt1hfp.count'length-1 downto 0) <= data_tmp(i).mbt1hfp.count;
        data_pipe_o.mbt1hfm(i).count(0)(data_tmp(i).mbt1hfm.count'length-1 downto 0) <= data_tmp(i).mbt1hfm.count;
        data_pipe_o.mbt0hfp(i).count(0)(data_tmp(i).mbt0hfp.count'length-1 downto 0) <= data_tmp(i).mbt0hfp.count;
        data_pipe_o.mbt0hfm(i).count(0)(data_tmp(i).mbt0hfm.count'length-1 downto 0) <= data_tmp(i).mbt0hfm.count;
        
        data_pipe_o.asymet(i).count(0)(data_tmp(i).asymet.count'length-1 downto 0) <= data_tmp(i).asymet.count;
        data_pipe_o.asymht(i).count(0)(data_tmp(i).asymht.count'length-1 downto 0) <= data_tmp(i).asymht.count;
        data_pipe_o.asymethf(i).count(0)(data_tmp(i).asymethf.count'length-1 downto 0) <= data_tmp(i).asymethf.count;
        data_pipe_o.asymhthf(i).count(0)(data_tmp(i).asymhthf.count'length-1 downto 0) <= data_tmp(i).asymhthf.count;
        
-- Additional delay for centrality and ext_cond (no comparators and conditions)

        centrality_pipe_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => NR_CENTRALITY_BITS,
                STAGES => CENTRALITY_STAGES
            )
            port map(
                clk, data_tmp(i).centrality, data_pipe_o.centrality(i)
            );
            
        ext_cond_pipe_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => EXTERNAL_CONDITIONS_DATA_WIDTH,
                STAGES => EXT_COND_STAGES
            )
            port map(
                clk, data_tmp(i).external_conditions, data_pipe_o.ext_cond(i)
            );
            
-- Conversions for muon, eg, jet and tau parameters

        eg_conversions_i: entity work.conversions
            generic map(
                N_EG_OBJECTS, eg_t
            )
            port map(
                pt => data_pipe_internal.eg(i).pt, eta => data_pipe_internal.eg(i).eta, phi => data_pipe_internal.eg(i).phi,
                pt_vector => conv_o.eg_pt_vector(i), cos_phi => conv_o.eg_cos_phi(i), sin_phi => conv_o.eg_sin_phi(i),
                conv_mu_cos_phi => conv_o.eg_cos_phi_conv_muon(i), conv_mu_sin_phi => conv_o.eg_sin_phi_conv_muon(i),
                conv_2_muon_eta_integer => conv_o.eg_eta_conv_muon(i), conv_2_muon_phi_integer => conv_o.eg_phi_conv_muon(i),
                eta_integer => conv_o.eg_eta(i), phi_integer => conv_o.eg_phi(i) 
            );

        jet_conversions_i: entity work.conversions
            generic map(
                N_JET_OBJECTS, jet_t
            )
            port map(
                pt => data_pipe_internal.jet(i).pt, eta => data_pipe_internal.jet(i).eta, phi => data_pipe_internal.jet(i).phi,
                pt_vector => conv_o.jet_pt_vector(i), cos_phi => conv_o.jet_cos_phi(i), sin_phi => conv_o.jet_sin_phi(i),
                conv_mu_cos_phi => conv_o.jet_cos_phi_conv_muon(i), conv_mu_sin_phi => conv_o.jet_sin_phi_conv_muon(i),
                conv_2_muon_eta_integer => conv_o.jet_eta_conv_muon(i), conv_2_muon_phi_integer => conv_o.jet_phi_conv_muon(i),
                eta_integer => conv_o.jet_eta(i), phi_integer => conv_o.jet_phi(i) 
            );
            
        tau_conversions_i: entity work.conversions
            generic map(
                N_TAU_OBJECTS, tau_t
            )
            port map(
                pt => data_pipe_internal.tau(i).pt, eta => data_pipe_internal.tau(i).eta, phi => data_pipe_internal.tau(i).phi,
                pt_vector => conv_o.tau_pt_vector(i), cos_phi => conv_o.tau_cos_phi(i), sin_phi => conv_o.tau_sin_phi(i),
                conv_mu_cos_phi => conv_o.tau_cos_phi_conv_muon(i), conv_mu_sin_phi => conv_o.tau_sin_phi_conv_muon(i),
                conv_2_muon_eta_integer => conv_o.tau_eta_conv_muon(i), conv_2_muon_phi_integer => conv_o.tau_phi_conv_muon(i),
                eta_integer => conv_o.tau_eta(i), phi_integer => conv_o.tau_phi(i) 
            );
            
        muon_conversions_i: entity work.conversions
            generic map(
                N_MUON_OBJECTS, muon_t
            )
            port map(
                pt => data_pipe_internal.muon(i).pt, eta => data_pipe_internal.muon(i).eta, phi => data_pipe_internal.muon(i).phi,
                pt_vector => conv_o.muon_pt_vector(i), cos_phi => conv_o.muon_cos_phi(i), sin_phi => conv_o.muon_sin_phi(i),
                eta_integer => conv_o.muon_eta(i), phi_integer => conv_o.muon_phi(i) 
            );
            
    end generate bx_l;
    
-- Output bx pipeline object parameters (muon, eg, jet and tau)

    data_pipe_o.muon <= data_pipe_internal.muon;
    data_pipe_o.eg <= data_pipe_internal.eg;
    data_pipe_o.jet <= data_pipe_internal.jet;
    data_pipe_o.tau <= data_pipe_internal.tau;

end architecture rtl;
