--adds implicit mantissa bit
--and also adds round and guard bits needed later

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity man_fix is 
	generic(n: integer:= 23);
	port(en: in std_logic;                                   --enable signal for unit
	     inManA,inManB: in std_logic_vector(n-1 downto 0);   --input mantissas of A,B
	     outManA,outManB: out std_logic_vector(n+2 downto 0) --output mantissas of A,B
	    );
end man_fix;
architecture man_fix_arch of man_fix is
begin
	process(inManA,inManB)
	begin
		if (en='1') then
			outManA <= '1' & inManA & "00";
			outManB <= '1' & inManB & "00";
		end if;
	end process;
end man_fix_arch;