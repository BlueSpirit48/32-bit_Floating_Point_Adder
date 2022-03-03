--testbench for the normalization and rounding block

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_norm_round_block is
--empty
end tb_norm_round_block;

architecture tbench of tb_norm_round_block is

	constant T: TIME := 100 ps; --clock period

	component norm_round_block is
    		port(exp_max: in std_logic_vector(7 downto 0);    --larger of the two exponent
		     sum_man: in std_logic_vector(25 downto 0);   --sum of the two mantissas
		     cout: in std_logic;                          --possible carry out from the addition of the two mantissas
		     exp_out: out std_logic_vector(7 downto 0);   --final exponent
		     man_out: out std_logic_vector(22 downto 0);  --final mantissa
		     rovf,inf,unf: out std_logic                  --possible flags for [Rovf: overflow from Rounding, Inf: overflow from Exp increment, Undf: underflow from Exp decrement]
	);
	end component;

signal exp_max: std_logic_vector(7 downto 0);    
signal sum_man: std_logic_vector(25 downto 0);   
signal cout: std_logic;                          
signal exp_out: std_logic_vector(7 downto 0);   
signal man_out: std_logic_vector(22 downto 0);  
signal rovf,inf,unf: std_logic;

begin

	U1: norm_round_block port map (exp_max => exp_max, sum_man => sum_man, cout => cout,
				       exp_out => exp_out, man_out => man_out, rovf => rovf, inf => inf, unf => unf);

	tb: process
	begin
		--exp_max <= "";
		--sum_man <= "";
		--cout <= '';
		wait for T;
	end process tb;
end tbench;
