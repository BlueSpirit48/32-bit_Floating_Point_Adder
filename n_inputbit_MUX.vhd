--n_inputbit MUX2
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nInputBit_MUX is
    generic(n: integer:= 23);
    port(
        in0,in1: in std_logic_vector( n-1 downto 0);
        sel: in std_logic;
        outMux: out std_logic_vector( n-1 downto 0)
    );
end nInputBit_MUX;

architecture nInputBit_MUX_arch of nInputBit_MUX is
signal nvin: std_logic_vector( n-1 downto 0);
begin 
    nvin <= (others => '0');
    with sel select
    	outMux <= in0 when '0',
              	  in1 when '1',
              	  nvin when others;

end nInputBit_MUX_arch;