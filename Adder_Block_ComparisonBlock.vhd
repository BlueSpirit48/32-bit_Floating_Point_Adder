--Determine the largest of two floating point nunbers 
--If CMP(Exponent Comparisson) input is 0 B is bigger, if CMP is 1 A>=B 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_compare_block is
    generic(n: integer:= 26);
    port( 
        AMan,BMan: in std_logic_vector(n-1 downto 0);
        CMP: in std_logic;
        FullCMP: out std_logic_vector(1 downto 0)
    );
end full_compare_block;

architecture full_compare_block_arch of full_compare_block is
    begin
        FullCMP <= "01" when CMP = '0' else
                   "10" when AMan = BMan else
                   "11" when AMan /= BMan else
                   "XX";                   
    
    end full_compare_block_arch;