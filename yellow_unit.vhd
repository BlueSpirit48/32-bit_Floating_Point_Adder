--yellow unit, one of the main units 
--in our implementation 
--detects special cases in the inputs of our circuit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity yellow_unit is
	port(sA,sB: in std_logic;                           --sign of A,B
	     expA,expB: in std_logic_vector(7 downto 0);    --exponent of A,B
	     manA,manB: in std_logic_vector(22 downto 0);   --mantissa of A,B
	     
	     en: out std_logic;                             --bit that says whether is special case or not
	     spec_num: out std_logic_vector(31 downto 0)   --special case output number value
	     );
end yellow_unit;
architecture yellow_unit_arch of yellow_unit is

	--check input type component
	component check_in_type is
		port(exp: in std_logic_vector(7 downto 0);         --exponent of input 
                     man: in std_logic_vector(22 downto 0);        --mantissa of input 
	             in_type: out std_logic_vector(2 downto 0));   --type of input
	end component;

	--special case between the inputs component
	component ab_case is
		port(sA,sB: in std_logic;                           --sign of inputs A,B
	     	     expA,expB: in std_logic_vector(7 downto 0);    --exponent of inputs A,B
	             manA,manB: in std_logic_vector(22 downto 0);   --mantissa of inputs A,B
	             typeA,typeB: in std_logic_vector(2 downto 0);  --types of inputs A,B
	             en: out std_logic;                             --enable for later use(small ALU)
	             spec_num: out std_logic_vector(31 downto 0));  --special case output number value
	end component;
	
	--signals declaration
	signal typeA,typeB: std_logic_vector(2 downto 0);
begin
	--component instatiation
	U1: check_in_type port map(exp => expA, man => manA, in_type => typeA);  --finds the input type of number A
	U2: check_in_type port map(exp => expB, man => manB, in_type => typeB);  --finds the input type of number B
	--determines whether there is a special case initialy to 
	U3: ab_case port map(sA => sA, sB => sB, expA => expA, expB => expB, 
                             manA => manA, manB => manB, typeA => typeA, typeB => typeB, 
                             en => en, spec_num => spec_num);
end yellow_unit_arch;
