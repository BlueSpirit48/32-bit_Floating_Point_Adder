--normalize the sum, by shifting appropriately the mantissa
--shifts right with carryout = "1"
--shfits left as many positions as the zero_count input

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_LR is
    	generic(n: integer:= 26; m:integer:=5);
    	port(man_in: in std_logic_vector(n-1 downto 0);        --the sum of the two mantissas
             zero_count: in std_logic_vector(m-1 downto 0);    --number of leading zeros in the sum of the two mantissas
             cout: in std_logic;                               --possible carry out of the mantissas sum
             man_out: out std_logic_vector(n-1 downto 0)       --output mantissa after possible needed shift
    	);
end shift_LR;

architecture shift_LR_arch of shift_LR is
	--mid supp signals
	signal to_shift: bit_vector(n downto 0);               --vector that will be shifted
	signal int_zero_count: integer range 0 to 26;          --integer number of zero count
	signal shifted: bit_vector(n downto 0);                --shifted vector
begin

    	int_zero_count <= to_integer(unsigned(zero_count));
    	to_shift <= to_bitvector(cout & man_in);
    	shifted <= to_shift srl 1 when cout = '1' else --we dont need bit in position 26-is the carry out bit 
              	   to_shift sll int_zero_count;
    	man_out <= to_stdlogicvector(shifted(n-1 downto 0));

end shift_LR_arch;