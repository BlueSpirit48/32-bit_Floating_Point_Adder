--32_bit Registers
--Store two floating point values
--where 31_Sign, 30_23_Exponent, 22_0_Mantissa (IEEE 754 Standard)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity input_register is
	port(clk,rst:in std_logic;
		wr_en:in std_logic;
		opA,opB:in std_logic_vector( 31 downto 0);-- two flaot numbers inputs
        SignA,SignB:out std_logic; 
		ExA,ExB:out std_logic_vector( 7 downto 0);-- exponent_of_A,B
        ManA,ManB:out std_logic_vector( 22 downto 0)--Mantissa_of_A,B
	);
end input_register;

architecture input_register_arch of input_register is
    type reg_array is array(1 to 2) of std_logic_vector( 31 downto 0);-- 2 reg of 32 bit
    signal two_reg: reg_array;
    
    begin
        --registers
        process(clk,rst)
        begin
            if(rst = '1') then
                two_reg <= (others => (others =>'0'));
            elsif(clk'event and clk = '1') then --pos edge clk
                if(wr_en = '1') then
                    two_reg(1) <= opA;
                    two_reg(2) <= opB; 
                end if;
            end if;
        end process;
        --output logic
        SignA <= two_reg(1)(31);
        ExA <= two_reg(1)(30 downto 23);
        ManA <= two_reg(1)( 22 downto 0);
        
        SignB <= two_reg(2)(31);
        ExB <= two_reg(2)(30 downto 23);
        ManB <= two_reg(2)( 22 downto 0);

    end input_register_arch;
