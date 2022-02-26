--Normalize the sum, with shifting appropriate the mantissa
--Shifts Right with carryout = "1"
--Shfits Left as many positions as the ZeroCount input
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nbit_ShiftLR is
    generic(n: integer:= 26; m:integer:=5);
    port(
         inMan: in std_logic_vector( n-1 downto 0);
         ZeroCount: in std_logic_vector( m-1 downto 0);
         Cout: in std_logic;
         outMan: out std_logic_vector(n-1 downto 0)
    );

end nbit_ShiftLR;

architecture nbit_ShiftLR_arch of nbit_ShiftLR is
--mid supp signals
signal bit_inShift: bit_vector(n downto 0);
signal int_shiftBit: integer range 0 to 26;
signal bit_outShift: bit_vector(n downto 0);

begin
    int_shiftBit <= to_integer(unsigned(ZeroCount));
    bit_inShift <= to_bitvector(Cout&inMan);
    bit_outShift <= bit_inShift srl 1 when Cout = '1' else -- we dont need bit in position 26-is the carry out bit 
                    bit_inShift sll int_shiftBit;
    outMan <= to_stdlogicvector(bit_outShift(n-1 downto 0));

end nbit_ShiftLR_arch;