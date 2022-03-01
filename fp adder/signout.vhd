--determines the output sign of addition
--its always the sign of larger number 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signout is
    port(
        sA,sB: in std_logic;                         --signs of A,B
        full_cmp: in std_logic_vector(1 downto 0);   --full compare vector
        sout: out std_logic                          --signout of the addition
    );
end signout;

architecture signout_arch of signout is
    begin
        sout <= '0' when full_cmp = "10" else
                sA when full_cmp = "11" else
                sB when full_cmp = "01" else
                'X';
end signout_arch;