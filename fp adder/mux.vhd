--2 to 1 (n-bit) MUX

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
    generic(n: integer:= 23);
    port(
        in0,in1: in std_logic_vector(n-1 downto 0);   --two possible input to select from
        sel: in std_logic;                            --select signal that chooses which input to pass to output 
        mux_out: out std_logic_vector(n-1 downto 0)   --mux output
    );
end mux;

architecture mux_arch of mux is
begin 
    with sel select
    	mux_out <= in0 when '0',
              	   in1 when '1',
              	   (others => 'X') when others;
end mux_arch;