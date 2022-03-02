--counts the leading zeros of the sum
--of the two mantissas in order to speed up
--the normalization phase

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity zero_count is
	generic(n: integer:= 26);
	port(man_in: in std_logic_vector(n-1 downto 0);     --input mantissa
             zeros: out std_logic_vector(4 downto 0)        --number of leading zeros in the sum of the two mantissas (between 32 to 0) 
	);
end zero_count;
architecture zero_count_arch of zero_count is
begin
	process(man_in)
	variable count: integer range 0 to 32;
	begin
		count:=0;
		for i in man_in'range loop
			case man_in(i) is
				when '0' => count:=count+1;
				when others => exit;
			end case;
		end loop;
	zeros <= std_logic_vector(to_unsigned(count,zeros'length));
	end process;
end zero_count_arch;