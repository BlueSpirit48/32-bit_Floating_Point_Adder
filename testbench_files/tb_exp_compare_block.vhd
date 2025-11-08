-- testbench for exponent compare block

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_exp_compare_block is
--empty
end tb_exp_compare_block;

architecture tbench of tb_exp_compare_block is
		
	constant T: TIME := 100 ps; --clock period

	component exp_compare_block is
		port(en: in std_logic;
		     expA,expB: in std_logic_vector(7 downto 0);           --exponents of A,B
        	     manA_in,manB_in: in std_logic_vector(22 downto 0);    --mantissas of A,B
		     cmp: out std_logic;                                   --bit that indicates which exp is larger
		     exp_out: out std_logic_vector(7 downto 0);            --larger exponent
		     shift: out std_logic_vector(4 downto 0);              --number of shifts to align the exponents
		     manA_out,manB_out: out std_logic_vector(25 downto 0)  --mantissas with extra necessary bits
	);
	end component;

signal en: std_logic;
signal expA,expB: std_logic_vector(7 downto 0);           
signal manA_in,manB_in: std_logic_vector(22 downto 0);   
signal cmp: std_logic;                                   
signal exp_out: std_logic_vector(7 downto 0);            
signal shift:  std_logic_vector(4 downto 0);              
signal manA_out,manB_out: std_logic_vector(25 downto 0);

begin
	
	U1: exp_compare_block port map (en => en, expA => expA, expB => expB, manA_in => manA_in, manB_in => manB_in, 
					cmp => cmp, exp_out => exp_out, shift => shift, manA_out => manA_out, manB_out => manB_out);

	tb: process
	begin
		--number A: 1005.67
		--nmuber B: 2003.0236
		en <= '1';
		expA <= "10001000";
		expB <= "10001001";
		manA_in <= "11110110110101011100001";
		manB_in <= "11110100110000011000001";
		wait for T;
		--number A: 1.345
		--number B: -1.345
		en <= '1';
		expA <= "01111111";
		expB <= "01111111";
		manA_in <= "01011000010100011110110";
		manB_in <= "01011000010100011110110";
		wait for T;
		--number A: 50.123
		--number B: 300.432
		en <= '1';
		expA <= "10000100";
		expB <= "10000111";
		manA_in <= "10010000111110111110100";
		manB_in <= "00101100011011101001100";
		wait for T;
		--number A: 45.03
		--number B: 1000.12
		en <= '1';
		expA <= "10000100";
		expB <= "10001000";
		manA_in <= "01101000001111010111000";
		manB_in <= "11110100000011110101110";
		wait for T;
		--number A: 6.0430377E9
		--number B: 1003.62
		en <= '1';
		expA <= "10011111";
		expB <= "10001000";
		manA_in <= "01101000001100010111000";
		manB_in <= "11110101110011110101110";
		wait for T;
		--number A: 1005.67
		--number B: 2003.0236
		en <= '0';
		expA <= "10001000";
		expB <= "10001001";
		manA_in <= "11110110110101011100001";
		manB_in <= "11110100110000011000001";
		wait;
	end process tb;
end tbench;
