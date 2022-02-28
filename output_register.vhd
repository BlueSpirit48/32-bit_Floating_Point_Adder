--register that stores the sum output of the fp adder and its flags
--synchronous write
--asynchronous read

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity output_register is
	port(clk,rst: in std_logic;
	     wr_en: in std_logic;
	     rd_en: in std_logic;
	     sum_in: in std_logic_vector(31 downto 0);        --the sum of the fp adder
             --flags_in: in std_logic;
	     sum_out: out std_logic_vector(31 downto 0)
             --flags_out: out std_logic;
	     );
end output_register;

architecture output_register_arch of output_register is
	signal reg: std_logic_vector(31 downto 0);
begin
	process(clk,rst)
        begin
        	if(rst = '1') then
                	reg <= (others =>'0');
                elsif(clk'event and clk = '1') then                         --synchronous write
                	if(wr_en = '1') then
                		reg <= sum_in;
		        else
				reg <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
                        end if;
                end if;
        end process;
	
	sum_out <= reg when (rd_en='1') else                                --asynchronous read
		   "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

end output_register_arch;
