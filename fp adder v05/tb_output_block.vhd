--testbench for output block;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_output_block is
--empty
end tb_output_block;

architecture tbench of tb_output_block is

	constant T: TIME := 100 ps; --clock period

	component output_block is
    		port(spec_num: in std_logic_vector(31 downto 0);    --special case number 
        	     sout: in std_logic;                            --sign out
        	     exp: in std_logic_vector(7 downto 0);          --exponent after inc/dec stage 
        	     man:in std_logic_vector(22 downto 0);          --mantissa after rounding stage 
        	     rovf,inf,unf: in std_logic;                    --round-overflow, infinity, underflow flags
       		     en: in std_logic;                              --initial special case check
         	     output: out std_logic_vector(31 downto 0);     --final output value
        	     unf_flag: out std_logic                        --underflow flag
		);
	end component;

signal spec_num: std_logic_vector(31 downto 0);   
signal sout: std_logic;                           
signal exp: std_logic_vector(7 downto 0);           
signal man: std_logic_vector(22 downto 0);           
signal rovf,inf,unf: std_logic;                    
signal en: std_logic;                              
signal output: std_logic_vector(31 downto 0);     
signal unf_flag: std_logic;

begin
	
	U1: output_block port map (spec_num => spec_num, sout => sout, exp => exp, man => man, rovf => rovf, inf => inf, unf => unf, en => en,
				   output => output, unf_flag => unf_flag);

	tb: process
	begin
		--spec_num <= "";
		--sout <= '';
		--exp <= "";
		--man <= "";
		--rovf <= '';
		--inf <= '';
		--unf <= '';
		--en <= '';
		wait for T;
	end process tb;

end tbench;
