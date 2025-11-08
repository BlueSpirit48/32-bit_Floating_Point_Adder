--shifts right the mantissa of the number with the smaller exponent
--to align them for addition

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_R is
    	generic(n: integer := 26; m: integer:=5);
    	port(man_in: in std_logic_vector(n-1 downto 0);      --input mantissa that possibly needs to be shifted
             shift: in std_logic_vector(m-1 downto 0);       --amount that the mantissa of the number with the smaller exponent needs to be shifted (based on their diff)
             man_out: out std_logic_vector(n-1 downto 0)     --shifted output mantissa
    	);
end shift_R;

architecture shift_R_arch of shift_R is
        --mid supp signals
    	signal bit_man_in: bit_vector(n-1 downto 0);
    	signal int_shift: integer range 0 to 26;     
begin
        bit_man_in <= to_bitvector(man_in);
        int_shift <= to_integer(unsigned(shift));
        man_out <= to_stdlogicvector(bit_man_in srl int_shift);
end shift_R_arch;