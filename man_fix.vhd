--adds implicit mantissa bit
--and also adds round and guard bits needed later

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity man_fix is 
	port(inManA,inManB: in std_logic_vector(22 downto 0);
	     outManA,outManB: out std_logic_vector(25 downto 0)
	    );
end man_fix;
architecture man_fix_arch of man_fix is
begin
	outManA <= '1' & inManA & "00";
	outManB <= '1' & inManB & "00";
end man_fix_arch;