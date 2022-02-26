-- The Block Increase or Decrease the exponent to value the final exponent result
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Inc_Dec_Exp is
    generic(n: integer:=8);
    port(
        inExp: in std_logic_vector( n-1 downto 0);
        ZeroCount: in std_logic_vector( 4 downto 0);
        Cout: in std_logic;
        outExp: out std_logic_vector( n-1 downto 0);
        unf,inf: out std_logic-- unf stand for underflow(Exp = 0), inf stand for special case Exp(=FF meaning Infinite);
    );
 end Inc_Dec_Exp;

 architecture Inc_Dec_Exp_arch of Inc_Dec_Exp is
    signal mid_inExp: unsigned(n downto 0);
    signal mid_outExp: unsigned(n downto 0);
    signal mid_int: integer range 0 to 26;
begin
    mid_inExp <= unsigned('0'&inExp);
    mid_int <= to_integer(unsigned(ZeroCount));
    
    process(mid_inExp,mid_int,Cout)
    begin
        if (Cout = '1') then
            mid_outExp <= mid_inExp + 1;
        elsif( mid_int > 0 ) then
            mid_outExp <= mid_inExp - mid_int;
        else
            mid_outExp <= mid_inExp;
	end if;
    end process;
    
    unf <= '1' when mid_outExp(n) = '1' else
           '1' when mid_outExp(n-1 downto 0) = "00000000" else
           '0';
    inf <= '1' when mid_outExp(n-1 downto 0) = "11111111" else
           '0';
    outExp <= std_logic_vector(mid_outExp(n-1 downto 0)) when mid_outExp > mid_int else
	      "00000000";

 end Inc_Dec_Exp_arch;
