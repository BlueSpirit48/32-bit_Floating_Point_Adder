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
		--en <= '';
		--expA <= "";
		--expB <= "";
		--manA_in <= "";
		--manB_in <= "";
		wait for T;
	end process tb;
end tbench;