--increases or decreases the exponent to value the final exponent result

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity inc_dec_exp is
	generic(n: integer:=8);
    	port(exp_in: in std_logic_vector( n-1 downto 0);    --the larger of the two exponents
             zero_count: in std_logic_vector( 4 downto 0);  --number of leading zeros in the sum of the two mantissas
             cout: in std_logic;                            --carry out from the addition of the two mantissas
             exp_out: out std_logic_vector( n-1 downto 0);  --output exponent
             unf,inf: out std_logic                         --unf stands for underflow(exp = 0), inf stands for special case exp(=FF meaning infinity);
    	);
end inc_dec_exp;

architecture inc_dec_exp_arch of inc_dec_exp is

	signal mid_exp_in: unsigned(n downto 0);
   	signal mid_exp_out: unsigned(n downto 0);
    	signal mid_int: integer range 0 to 26;

begin

    	mid_exp_in <= unsigned('0' & exp_in);
    	mid_int <= to_integer(unsigned(zero_count));
    
    	process(mid_exp_in,mid_int,cout)
    	begin
        	if (cout = '1') then
			mid_exp_out <= mid_exp_in + 1;
        	elsif(mid_int > 0) then
            		mid_exp_out <= mid_exp_in - mid_int;
        	else
            		mid_exp_out <= mid_exp_in;
		end if;
    	end process;
    
    	unf <= '1' when mid_exp_out(n) = '1' else
               '1' when mid_exp_out(n-1 downto 0) = "00000000" else
               '0';
    	inf <= '1' when mid_exp_out(n-1 downto 0) = "11111111" else
               '0';
        exp_out <= std_logic_vector(mid_exp_out(n-1 downto 0)) when mid_exp_out(n) = '0' else
		           "00000000";

 end inc_dec_exp_arch;