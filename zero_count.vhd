--counts the leading zeros of the sum
--of the two mantissas in order to speed up
--the normalization phase

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity zero_count is
	generic(n: integer:= 26);
	port(
             InMan: in std_logic_vector(n-1 downto 0);     --input mantissa
             ZeroCount: out std_logic_vector(4 downto 0)   --number of zeros between 32 to 0 
	    );
end zero_count;
architecture zero_count_arch of zero_count is
begin
	process(InMan)
	variable count: integer range 0 to 32;
	begin
		count:=0;
		for i in InMan'range loop
			case InMan(i) is
				when '0' => count:=count+1;
				when others => exit;
			end case;
		end loop;
	ZeroCount <= std_logic_vector(to_unsigned(count,ZeroCount'length));
	end process;
end zero_count_arch;
