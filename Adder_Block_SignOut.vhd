--Determine the output sign of addition
--Is always the sign of larger number 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signout_block is
    port(
        SA,SB: in std_logic;
        FullCMP: in std_logic_vector(1 downto 0);
        Sout: out std_logic
    );
end signout_block;

architecture signout_block_arch of signout_block is
    begin
        Sout <= '0' when FullCMP = "10" else
                 SA when FullCMP = "11" else
                 SB when FullCMP = "01" else
                 'X';
    end signout_block_arch;