--unit that checks input number's type

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity check_in_type is
	port(exp: in std_logic_vector(7 downto 0);       --exponent of input 
             man: in std_logic_vector(22 downto 0);      --mantissa of input 
	     in_type: out std_logic_vector(2 downto 0)   --type of input
	     ); 
end check_in_type;
architecture check_in_type_arch of check_in_type is
begin
	in_type <= "000" when exp="00000000" and man="00000000000000000000000" else   --zero
		   "001" when exp="00000000" and man/="00000000000000000000000" else  --subnormal
		   "010" when exp<"11111111" and exp>"00000000" else                  --normal
                   "101" when exp="11111111" and man="00000000000000000000000" else   --infinity
		   "100" when exp="11111111" and man/="00000000000000000000000" else  --not a number
		   "100";                                                             --every other type (X,Z,-,...) is considered a NaN
end check_in_type_arch;