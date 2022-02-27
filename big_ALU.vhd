--behavioral addition of two mantissas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity big_ALU is
	generic(n : integer:= 26);
        port(AMan,BMan: in std_logic_vector(n-1 downto 0);   --mantissas of A,B
             FullCMP: in std_logic_vector( 1 downto 0);      --compare code of A,B
             SA,SB: in std_logic;                            --signs of A,B
             SumMan: out std_logic_vector(n-1 downto 0);     --sum of A,B
             Cout: out std_logic                             --carry out
             );
end big_ALU;
architecture big_ALU_arch of big_ALU is
--supp signals_extra bit for carry
signal mid_AMan: unsigned(n downto 0);
signal mid_BMan: unsigned(n downto 0);
signal mid_SumMan: unsigned(n downto 0);
begin
	mid_AMan <= unsigned('0'& AMan);
        mid_BMan <= unsigned('0'& BMan);
        process(mid_AMan,mid_BMan,FullCMP,SA,SB)
        begin
        	--same sign_just add them
                if(SA = SB) then
                	mid_SumMan <= mid_AMan + mid_BMan;
                --diff sign_sub Larger from smaller_sign determine from SignOut Block 
                elsif FullCMP = "01" then
                	mid_SumMan <= mid_BMan - mid_AMan;
                ------------ special case A == - B ( Sum = 0)-----------------
                elsif FullCMP(1) = '1' then                 
                	mid_SumMan <= mid_AMan - mid_BMan;   
                end if;
        end process;
        --output logic
        SumMan <= std_logic_vector(mid_SumMan(n-1 downto 0));
        Cout <= std_logic(mid_SumMan(n));
end big_ALU_arch;
