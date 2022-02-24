--Counts the zero of SumMantissa so he can shift fast and normalize it 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nIn_ZeroCount is
    generic(n: integer:= 26);
    port(
        InMan: in std_logic_vector( n-1 downto 0);
        ZeroCount: out std_logic_vector( 4 downto 0)--Output for bit length between 32 to 0 bits 
    );
end nIn_ZeroCount;

architecture nIn_ZeroCount_arch of nIn_ZeroCount is
type type_1Dx1D is array (0 to n-1) of std_logic_vector(n-1 downto 0);
type type2 is array (0 to n-1) of std_logic_vector(n downto 0);

signal add: type_1Dx1D;
signal conc: type_1Dx1D;

signal mid: std_logic_vector( n downto 0);
signal res: std_logic_vector( n-1 downto 0);

begin
    -- turn all bits after the first 1 to 1
	mid(n) <= '0';
	gen1:
	for i in 0 to n-1 generate
        	res((n-1) - i) <= mid((n) - i) or InMan((n-1) - i);
                mid((n-1) - i) <= '0' when res((n-1) - i) = '0' else
                                  '1';
        end generate gen1;
    -- turn all bits of above vector into vectors in order to add them
	gen2:
	for i in 0 to n-1 generate
		conc(i) <= (0 => not res(i), others => '0');
	end generate gen2;
    -- add all the above vector to calculate the number of continuous ones starting from the MSB
	add(0) <= conc(0);
	gen3:
	for i in 1 to n-1 generate   
		add(i) <= std_logic_vector(unsigned(conc(i))+unsigned(add(i-1)));
	end generate gen3;
    ----Result in 5 bit format------
    ZeroCount <= add(n-1)(4 downto 0);

end nIn_ZeroCount_arch;
