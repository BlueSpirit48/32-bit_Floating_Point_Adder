--nBitInput
--mBitShift
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nbit_Shift_Right is
    generic(n: integer := 26; m: integer:=5);
    port(
        inShift: in std_logic_vector(n-1 downto 0);
        shiftBit: in std_logic_vector(m-1 downto 0);
        outShift: out std_logic_vector(n-1 downto 0)
    );
end nbit_Shift_Right;

architecture nbit_Shift_Right_arch of nbit_Shift_Right is
    --mid supp signals
    signal bit_inShift: bit_vector(n-1 downto 0);
    signal int_shiftBit: integer;     
    begin
        bit_inShift <= to_bitvector(inShift);
        int_shiftBit <= to_integer(unsigned(shiftBit));
        outShift <= to_stdlogicvector(bit_inShift srl int_shiftBit);
    end nbit_Shift_Right_arch; 