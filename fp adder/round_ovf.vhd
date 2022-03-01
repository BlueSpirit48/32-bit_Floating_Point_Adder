--normalazes the output of rounding if needed 
--inc the exponent(if we have overflow in rounding)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity round_ovf is
    generic(n:integer:= 8);
    port(
        exp_in: in std_logic_vector(n-1 downto 0);     --exponent after possible increament or decreament in the normalization stage
        rovf: in std_logic;                            --possible overflow in the rounding process
        inf: in std_logic;                             --possible infinity in increament or decreament of the exponent in the normalization stage
        exp_out:  out std_logic_vector( n-1 downto 0)  --output exponent
    );
end round_ovf;

architecture round_ovf_arch of round_ovf is
    signal mid_exp_out: unsigned(n-1 downto 0);
    signal sel: std_logic;
begin
    
    mid_exp_out <= unsigned(exp_in) + 1;

    sel <= '0' when inf = '1' else
           '1' when rovf= '1' else
           '0';------------------------------------------------------------!!??
    
    with sel  select
		exp_out <= std_logic_vector(mid_exp_out) when '1',
                   exp_in when '0',
                  "XXXXXXXX" when others; 

end round_ovf_arch; 
