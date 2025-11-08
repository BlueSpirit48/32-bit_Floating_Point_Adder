--determines the largest of two mantissas 
--if cmp(Exponent Comparisson) input is 0 then B is bigger, if CMP is 1 then A>=B 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compare is
    	generic(n: integer:= 26);
    	port(manA,manB: in std_logic_vector(n-1 downto 0);    --mantissas of A,B
             cmp: in std_logic;								  --compare bit which says which exponent was larger
             shift: in std_logic_vector(4 downto 0);          
             full_cmp: out std_logic_vector(1 downto 0)       --full compare vector needed for later stages
	);
end compare;

architecture compare_arch of compare is
begin
	full_cmp <= "00" when cmp='0' else
	            "10" when shift /= "00000" else 
		        "01" when manB>manA else 
	            "10" when manA>manB else
		        "11";              
end compare_arch;