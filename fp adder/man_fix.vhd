--adds implicit mantissa bit
--and also adds round and guard bits needed in later stages

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity man_fix is 
	generic(n: integer:= 23);
	port(en: in std_logic;                                   --enable signal for unit
	     manA_in,manB_in: in std_logic_vector(n-1 downto 0);   --input mantissas of A,B
	     manA_out,manB_out: out std_logic_vector(n+2 downto 0) --output mantissas of A,B
	    );
end man_fix;
architecture man_fix_arch of man_fix is
begin
	process(en,manA_in,manB_in)
	begin
		if (en='1') then
			manA_out <= '1' & manA_in & "00";
			manB_out <= '1' & manB_in & "00";
		end if;
	end process;
end man_fix_arch;