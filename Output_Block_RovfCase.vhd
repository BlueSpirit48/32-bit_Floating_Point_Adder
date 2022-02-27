--Normalaze the output of rounduing if needed-- inc the exponent( if we have overflow in rounding)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rovfCase is
    generic(n:integer:= 8);
    port(
        inExp: in std_logic_vector(n-1 downto 0);
        Rovf: in std_logic;
        inf: in std_logic;
        outExp:  out std_logic_vector( n-1 downto 0)
    );
end rovfCase;

architecture rovfCase_arch of rovfCase is
    signal mid_outExp: unsigned( n-1 downto 0);
    signal sel: std_logic;
    begin
    
    mid_outEXp <= unsigned(inExp) + 1;

    sel<= '0' when inf = '1' else
          '1' when Rovf= '1' else
          '0';
    
    with sel  select
    outExp <= std_logic_vector(mid_outExp) when '1',
               inExp when '0',
               "XXXXXXXX" when others; 


end rovfCase_arch; 

