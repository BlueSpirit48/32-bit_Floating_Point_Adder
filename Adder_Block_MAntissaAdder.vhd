--Behavioral addition of two mantissas
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nBitAdder is
    generic(n : integer:= 26);
    port( AMan,BMan: in std_logic_vector(n-1 downto 0);
          FullCMP: in std_logic_vector( 1 downto 0);
          SA,SB: in std_logic;
          SumMan: out std_logic_vector(n-1 downto 0);
          Cout: out std_logic
    );
end nBitAdder;

architecture nBitAdder_arch of nBitAdder is
    --supp signals_extra bit for carry
    signal mid_AMan: unsigned(n downto 0);
    signal mid_BMan: unsigned(n downto 0);
    signal mid_SumMan: unsigned(n downto 0);
    begin
        mid_AMan <= unsigned('0'&AMan);
        mid_BMan <= unsigned('0'&BMan);
        process(mid_AMan,mid_BMan,FullCMP,SA,SB)
        begin
            --same sign_just add them
            if(SA = SB) then
            mid_SumMan <= mid_AMan + mid_BMan;
            elsif FullCMP = "01" then
            --diff sign_sub Larger from smaller_sign determine from SignOut Block 
            mid_SumMan <= mid_BMan - mid_AMan;
            elsif FullCMP(1) = '1' then
            mid_SumMan <= mid_AMan - mid_BMan;
            end if;
        end process;
        --output logic
        SumMan <= std_logic_vector(mid_SumMan(n-1 downto 0));
        Cout <= std_logic(mid_SumMan(n));

    end nBitAdder_arch;
    