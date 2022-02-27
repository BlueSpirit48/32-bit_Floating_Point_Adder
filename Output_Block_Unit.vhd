--Prepare the finale data to stored in outReg
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity output_block is
    port(
        Spvector: in std_logic_vector( 31 downto 0);
        Signout: in std_logic;
        inExp: in std_logic_vector( 7 downto 0); 
        inMan:in std_logic_vector( 22 downto 0);
        Rovf,Inf,Undf: in std_logic;
        en: in std_logic;
        outRes: out std_logic_vector( 31 downto 0); 
        outUndf: out std_logic
    );
end output_block;

architecture output_block_arch of output_block is
    
    component nInputBit_MUX 
    generic(n: integer);
    port(
        in0,in1: in std_logic_vector( n-1 downto 0);
        sel: in std_logic;
        outMux: out std_logic_vector( n-1 downto 0)
    );
    end component;
    
    component rovfCase
        generic(n:integer);
        port(
            inExp: in std_logic_vector(n-1 downto 0);
            Rovf: in std_logic;
            inf: in std_logic;
            outExp:  out std_logic_vector( n-1 downto 0)
        );
    end component;
    
    component vectorOut is
        port(
            signout:in std_logic;
            expout: in std_logic_vector( 7 downto 0);
            mantissa: in std_logic_vector( 22 downto 0);
            outFpn: out std_logic_vector( 31 downto 0) 
        );
    end component;
    ----------------------------mid signals----------------
    signal zeroMan: std_logic_vector( 22 downto 0);
    signal mid_Man: std_logic_vector( 22 downto 0);
    signal mid_Exp: std_logic_vector( 7 downto 0);
    signal mid_vector: std_logic_vector( 31 downto 0);
    --signal mid_Spvector: std_logic_vector( 31 downto 0);
    begin
        zeroMan <= (others => '0');
        
        mux1: nInputBit_MUX generic map(n => 23)
                            port map(in0 => inMan, in1 => zeroMan, sel => Inf, outMux => mid_Man );
        
        round_ovf_case_block: rovfCase generic map( n => 8)
                                       port map( inExp => inExp, Rovf => Rovf, inf => Inf, outExp => mid_Exp);
        
        vector_block1: vectorOut port map( signout => Signout, expout => mid_Exp, mantissa => mid_Man, outFpn => mid_vector );

        mux2: nInputBit_MUX generic map(n => 32)
                            port map(in0 => mid_vector, in1 => Spvector, sel => en, outMux => outRes );
    
        outUndf <= Undf;
    
        
end output_block_arch;