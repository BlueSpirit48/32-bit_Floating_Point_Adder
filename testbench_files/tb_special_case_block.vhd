--testbench for the special case block

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_special_case_block is
--empty
end tb_special_case_block;

architecture tbench of tb_special_case_block is

	constant T: TIME := 100 ps; --clock period

	component special_case_block is
		port(sA,sB: in std_logic;                           --sign of A,B
	             expA,expB: in std_logic_vector(7 downto 0);    --exponent of A,B
	             manA,manB: in std_logic_vector(22 downto 0);   --mantissa of A,B
	             en: out std_logic;                             --bit that says whether is special case or not
	             spec_num: out std_logic_vector(31 downto 0)    --special case output number value
		);
	end component;

signal sA,sB: std_logic;                          
signal expA,expB: std_logic_vector(7 downto 0); 
signal manA,manB: std_logic_vector(22 downto 0);
signal en: std_logic;                            
signal spec_num: std_logic_vector(31 downto 0);

begin

	U1: special_case_block port map (sA => sA, sB => sB, expA => expA, expB => expB, manA => manA, manB => manB, 
                                         en => en, spec_num => spec_num);

	tb: process
	begin
		--number A: 1005.67
		--nmuber B: 2003.0236
		sA   <= '0';
		sB   <= '0';
		expA <= "10001000";
		expB <= "10001001";
		manA <= "11110110110101011100001";
		manB <= "11110100110000011000001";
		wait for T;
		--number A: 1.345
		--number B: -1.345
		sA   <= '0';
		sB   <= '1';
		expA <= "01111111";
		expB <= "01111111";
		manA <= "01011000010100011110110";
		manB <= "01011000010100011110110";
		wait for T;
		--number A: 0
		--number B: -10
		sA   <= '0';
		sB   <= '1';
		expA <= "00000000";
		expB <= "10000010";
		manA <= "00000000000000000000000";
		manB <= "01000000000000000000000";
		wait for T;
		--number A: NaN
		--number B: 5
		sA   <= '1';
		sB   <= '0';
		expA <= "11111111";
		expB <= "10000001";
		manA <= "01101000001111010111000";
		manB <= "01000000000000000000000";
		wait for T;
		--number A: -infinity
		--number B: 5
		sA   <= '1';
		sB   <= '0';
		expA <= "11111111";
		expB <= "10000001";
		manA <= "00000000000000000000000";
		manB <= "01000000000000000000000";
		wait for T;
	end process tb;
end tbench;
