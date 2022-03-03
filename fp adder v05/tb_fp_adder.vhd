library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fp_adder is
--empty
end tb_fp_adder;

architecture testb of tb_fp_adder  is

constant T: TIME := 10 ns; --clock period

	component fp_adder is
    		port(clk,rst: in std_logic;                            --clock and reset signals
                     start: in std_logic;                              --start signal to initiate operation
                     numA,numB: in std_logic_vector( 31 downto 0);     --the two input numbers 
                     flag: out std_logic;                              --output flag
                     regs_control: out std_logic_vector(1 downto 0);   --register control signal (MSB=inreg_wr, LSB=outreg_wr)
                     sum: out std_logic_vector(31 downto 0)            --output sum
		);
	end component;

signal clk, rst: std_logic;
signal start: std_logic;
signal numA, numB: std_logic_vector(31 downto 0);
signal flag: std_logic;
signal regs_control: std_logic_vector(1 downto 0);
signal sum: std_logic_vector(31 downto 0); 
--signal finished: std_logic;

begin 

    --finished <= '0';

	U1: fp_adder port map (clk, rst, start, numA, numB, flag, regs_control, sum);

	--clock and reset  
	clk_gen: process
	begin
	   --if (finished='0') then
	       clk <= '0';
    	       wait for T/2;
    	       clk <= '1';
    	       wait for T/2;
    	--else
    	       --clk <= '0';
    	--end if;
	end process clk_gen;

	rst <= '1', '0' after T/4;

	--input signals
	test_b: process
	begin
		start <= '1';
		numA <= "01000100011110110110101011100001";  --(1005.67)
		numB <= "01000100111110100110000011000001";  --(2003.02)
		wait for 4*T;
		numA <= "01000010010010000111110111110100";  --(50.123) 
		numB <= "01000011100101100011011101001100";  --(300.432)
		wait for 4*T;
		numA <= "11000010001101000001111010111000";   --(-45.03) 
		numB <= "01000011100101100011011101001100";  --(300.432)
		wait for 4*T;
		--finished <= '1';
		--wait;
		numA <= "10000000000000000000000000000000";  --(-0) 
		numB <= "01000001001000000000000000000000";  --(10)
		wait for 3*T;
	end process test_b;

end testb;


