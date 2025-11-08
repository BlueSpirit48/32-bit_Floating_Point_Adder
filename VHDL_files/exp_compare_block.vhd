--finds the larger exponent of the two, calculates how many times the mantissa
--of the number with the smaller exp needs to be shifted and adds the extra necessary bits two both mantissas 
--needed for later stages

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exp_compare_block is
	port(en: in std_logic;
	     expA,expB: in std_logic_vector(7 downto 0);           --exponents of A,B
             manA_in,manB_in: in std_logic_vector(22 downto 0);    --mantissas of A,B
	
	     cmp: out std_logic;                                   --bit that indicates which exp is larger
	     exp_out: out std_logic_vector(7 downto 0);            --larger exponent
	     shift: out std_logic_vector(4 downto 0);              --number of shifts to align the exponents
	     manA_out,manB_out: out std_logic_vector(25 downto 0)  --mantissas with extra necessary bits
	);
end exp_compare_block;

architecture exp_compare_block_arch of exp_compare_block is

	--small ALU component
	component small_ALU is
		port(expA,expB: in std_logic_vector(7 downto 0);  --exponent of inputs A,B
	     	     en: in std_logic;                            --enable signal for unit
	             cmp: out std_logic;                          --bit that indicates which exp is larger
                     exp_out: out std_logic_vector(7 downto 0);   --larger exponent(which will be used later)
	             shift: out std_logic_vector(4 downto 0));    --number of shifts to align the exponents                                 
	end component;
	
	--mantissa fix component
	component man_fix is 
		generic(n: integer:= 23);
		port(en: in std_logic;                                        --enable signal for unit
	             manA_in,manB_in: in std_logic_vector(n-1 downto 0);      --input mantissas of A,B
	             manA_out,manB_out: out std_logic_vector(n+2 downto 0));  --output mantissas of A,B
	end component;
	
begin

	--component instatiation
	U1: small_ALU port map(expA => expA, expB => expB, en => en, cmp => cmp, exp_out => exp_out, shift => shift);
	U2: man_fix port map(en => en, manA_in => manA_in, manB_in => manB_in, manA_out => manA_out, manB_out => manB_out);
	
end exp_compare_block_arch;

