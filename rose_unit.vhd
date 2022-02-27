--rose unit, one of the main units in our implementation 
--finds the larger exponent of the two, calculates how many times the mantissa
--of the number with the smaller exp needs to be shifted and adds the extra necessary bits two both mantissas 
--needed for later stages

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rose_unit is
	port(
	     en: in std_logic;
	     expA,expB: in std_logic_vector(7 downto 0);         --exponents of A,B
             manA,manB: in std_logic_vector(22 downto 0);        --mantissas of A,B
	
	     cmp: out std_logic;                                 --bit that indicates which exp is larger
	     expOUT: out std_logic_vector(7 downto 0);           --larger exponent
	     shift: out std_logic_vector(4 downto 0);            --number of shifts to align the exponents
	     outManA,outManB: out std_logic_vector(25 downto 0)  --mantissas with extra necessary bits
	     );
end rose_unit;
architecture rose_unit_arch of rose_unit is

	--small ALU component
	component small_ALU is
	port(expA,expB: in std_logic_vector(7 downto 0);  --exponent of inputs A,B
	     en: in std_logic;                            --enable signal for unit
	     cmp: out std_logic;                          --bit that indicates which exp is larger
             expOUT: out std_logic_vector(7 downto 0);    --larger exponent(which will be used later)
	     shift: out std_logic_vector(4 downto 0));    --number of shifts to align the exponents                                 
	end component;
	--mantissa fix component
	component man_fix is 
	generic(n: integer:= 23);
	port(en: in std_logic;                                     --enable signal for unit
	     inManA,inManB: in std_logic_vector(n-1 downto 0);     --input mantissas of A,B
	     outManA,outManB: out std_logic_vector(n+2 downto 0)); --output mantissas of A,B
	end component;
begin
	--component instatiation
	U1: small_ALU port map(expA => expA, expB => expB, en => en, cmp => cmp, expOUT => expOUT, shift => shift);
	U2: man_fix port map(en => en, inManA => manA, inManB => manB, outManA => outManA, outManB => outManB);
end rose_unit_arch;
