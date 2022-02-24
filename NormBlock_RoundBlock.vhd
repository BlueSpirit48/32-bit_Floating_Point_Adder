--Rounding and give the final mantissa output
--Format MSB (+1), 2 LSB (Guard,Round) bits for rounding, so all others bit is the final mantissa value 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RoundBlock is
    generic(n: integer:= 26; m: integer:=23);
    port(
        inMan: in std_logic_vector(n-1 downto 0);
        outMan: out std_logic_vector(m-1 downto 0);
        Rovf: out std_logic-- 1 when overflow occurs
    );

end RoundBlock;

architecture RoundBlock_arch of RoundBlock is
    signal mid_Man: unsigned(m downto 0);
    signal mid_RMan: unsigned(m downto 0);
    signal LGR: std_logic_vector(2 downto 0);-- this mid signals stores the 3 last bits of input Mantissa
                                             -- Then it use them for Round to nearest, ties to even
    begin
        LGR <= inMan(2 downto 0);
        mid_Man <= unsigned('0' & inMan(n-2 downto 2));
        mid_RMan <= mid_Man when LGR( 1 downto 0) < "10" else
                    mid_Man + 1 when LGR(1 downto 0) > "10" else
                    mid_Man when LGR = "010" else
                    mid_Man + 1 when LGR = "110" else
                    "XXXXXXXXXXXXXXXXXXXXXXXX";
        outMan <= std_logic_vector(mid_RMan(m-1 downto 0));
        Rovf <= std_logic(mid_RMan(m));  

end RoundBlock_arch; 
