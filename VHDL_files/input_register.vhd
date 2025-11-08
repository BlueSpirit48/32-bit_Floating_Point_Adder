--two 32-bit registers
--store two single precission floating point numbers
--where 31:sign, 30-23:exponent, 22-0:mantissa (IEEE 754 Standard)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity input_register is
	port(clk,rst: in std_logic;                          --register clock and reset signals
	     wr_en: in std_logic;                            --register write enable
	     numA,numB: in std_logic_vector( 31 downto 0);   --the two float numbers
             sA,sB: out std_logic;                           --sign of each number
	     expA,expB: out std_logic_vector( 7 downto 0);   --exponent of A,B
             manA,manB: out std_logic_vector( 22 downto 0)   --mantissa of A,B
	     );
end input_register;

architecture input_register_arch of input_register is
	--type reg_array is array(1 to 2) of std_logic_vector( 31 downto 0); --2 regs of 32 bit
	--signal two_reg: reg_array;
	signal reg1,reg2: std_logic_vector ( 31 downto 0);
begin
        --registers
	process(clk,rst)
        begin
        	if(rst = '1') then
                    reg1 <= (others =>'0');
                    reg2 <= (others => '0');
                elsif(clk'event and clk = '1') then 
                	if(wr_en = '1') then                     
                		    reg1 <= numA;
                    		reg2 <= numB; 
                        end if;
                end if;
        end process;

	--output logic
        sA <= reg1(31);
        expA <= reg1(30 downto 23);
        manA <= reg1(22 downto 0);
        
        sB <= reg2(31);
        expB <= reg2(30 downto 23);
        manB <= reg2(22 downto 0);	
	
end input_register_arch;
