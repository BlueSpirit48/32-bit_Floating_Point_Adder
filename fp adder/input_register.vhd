--two 32-bit registers
--store two single precission floating point numbers
--where 31:sign, 30-23:exponent, 22-0:mantissa (IEEE 754 Standard)
--synchronous write
--synchronous read

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity input_register is
	port(clk,rst: in std_logic;                          --register clock and reset signals
	     wr_en,rd_en: in std_logic;                      --register write and read enables
	     numA,numB: in std_logic_vector( 31 downto 0);   --the two float numbers
             sA,sB: out std_logic;                           --sign of each number
	     expA,expB: out std_logic_vector( 7 downto 0);   --exponent of A,B
             manA,manB: out std_logic_vector( 22 downto 0)   --mantissa of A,B
	     );
end input_register;

architecture input_register_arch of input_register is
	type reg_array is array(1 to 2) of std_logic_vector( 31 downto 0); --2 regs of 32 bit
	signal two_reg: reg_array;
begin
        --registers
	process(clk,rst)
        begin
        	if(rst = '1') then
                	two_reg <= (others => (others =>'0'));
                elsif(clk'event and clk = '1') then 
                	if(wr_en = '1') then                      --synchronous write
                		two_reg(1) <= numA;
                    		two_reg(2) <= numB; 
                        end if;
			if(rd_en = '1') then                      --asynchronous read
				--output logic
        			sA <= two_reg(1)(31);
        			expA <= two_reg(1)(30 downto 23);
        			manA <= two_reg(1)(22 downto 0);
        
        			sB <= two_reg(2)(31);
        			expB <= two_reg(2)(30 downto 23);
        			manB <= two_reg(2)(22 downto 0);
			end if;
                end if;
        end process;

end input_register_arch;
