--Normalization Block, Normalaze the result of the addition 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Norm_Block is
    port(
    maxExp: in std_logic_vector( 7 downto 0);
    SumMan: in std_logic_vector( 25 downto 0);
    Cout: in std_logic;
    outExp: out std_logic_vector( 7 downto 0);
    outMan: out std_logic_vector( 22 downto 0);
    Rovf,Inf,Undf: out std_logic -- Rovf: overflow from Rounding, Inf: overflow from Exp increment, Undf: underflow from Exp decrement
    );

end Norm_Block;

architecture Norm_Block_arch of Norm_Block is
    
    component zero_count 
    generic(n: integer);
    port(
        InMan: in std_logic_vector(n-1 downto 0);    
        ZeroCount: out std_logic_vector(4 downto 0)   
        );
    end component;

    component  nbit_ShiftLR 
        generic(n: integer; m:integer);
        port(
             inMan: in std_logic_vector( n-1 downto 0);
             ZeroCount: in std_logic_vector( m-1 downto 0);
             Cout: in std_logic;
             outMan: out std_logic_vector(n-1 downto 0)
        );
    end component;

    component Inc_Dec_Exp 
    generic(n: integer:=8);
    port(
        inExp: in std_logic_vector( n-1 downto 0);
        ZeroCount: in std_logic_vector( 4 downto 0);
        Cout: in std_logic;
        outExp: out std_logic_vector( n-1 downto 0);
        unf,inf: out std_logic
    );
    end component;

    component RoundBlock 
        generic(n: integer:= 26; m: integer:=23);
        port(
            inMan: in std_logic_vector(n-1 downto 0);
            outMan: out std_logic_vector(m-1 downto 0);
            Rovf: out std_logic
        );
    end component;
    
    --mid signals
    signal ZeroCount: std_logic_vector( 4 downto 0); -- LeadingZeroCounter
    signal mid_outMan: std_logic_vector( 25 downto 0);-- Normalized Mantissa
    begin
    leadingZeroCount: zero_count generic map( n => 26)
                                 port map(InMan => SumMan, ZeroCount => ZeroCount);
    shiftLR:  nbit_ShiftLR generic map( n => 26, m => 5)
                           port map( inMan => SumMan, ZeroCount => ZeroCount, Cout => Cout, outMan => mid_outMan);
    expIncDec: Inc_Dec_Exp generic map( n => 8)
                           port map(inExp => maxExp, ZeroCount=>ZeroCount, Cout => Cout,  outExp => outExp, unf => Undf, inf => Inf);
    rounding: RoundBlock generic map( n => 26, m => 23)
                         port map(inMan => mid_outMan, outMan => outMan, Rovf => Rovf);


end Norm_Block_arch;