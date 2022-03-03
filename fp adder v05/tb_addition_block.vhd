--testbench for the addition block

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_addition_block is
--empty
end tb_addition_block;

architecture tbench of tb_addition_block is

	constant T: TIME := 100 ps; --clock period

	component addition_block is
    		port(manA,manB : in std_logic_vector(25 downto 0);   --the two mantissas to be added
	             sA,sB: in std_logic;                            --signs of numbers A,B
                     cmp: in std_logic;                              --bit that indicates which number had the larger exponent 
                     shift: in std_logic_vector( 4 downto 0);        --number of shifts needed in the mantissa with the smaller exponent
                     sout: out std_logic;                            --sign of the larger number
                     sum_man: out std_logic_vector( 25 downto 0);    --the output sum of the two mantissas
                     cout: out std_logic                             --possible carry out
		);
	end component;

signal manA,manB: std_logic_vector(25 downto 0);
signal sA,sB: std_logic;
signal cmp: std_logic;                               
signal shift: std_logic_vector( 4 downto 0);        
signal sout: std_logic;                            
signal sum_man: std_logic_vector( 25 downto 0);    
signal cout: std_logic;

begin 
	
	U1: addition_block port map (manA => manA, manB => manB, sA => sA, sB => sB, cmp => cmp, shift => shift, 
                                     sout => sout, sum_man => sum_man, cout => cout);

	tb: process
	begin
		--manA  <= "";
		--manB  <= "";
		--sA    <= '':
		--sB    <= '';
		--cmp   <= '';                           
		--shift <= "";
		wait for T;
	end process tb;
end tbench;