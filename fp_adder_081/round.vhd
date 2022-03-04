--rounds the shifted left/right sum of the two mantissas and gives the final mantissa output
--Format: MSB (+1), 2 LSB (Guard,Round) bits for rounding, so all other bits is the final mantissa value 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity round is
	generic(n: integer:= 26; m: integer:=23);
    	port(man_in: in std_logic_vector(n-1 downto 0);     --input mantissa
             man_out: out std_logic_vector(m-1 downto 0);   --output mantissa
             rovf: out std_logic                            --when overflow possibly occurs in the rounding process
    	);
end round;

architecture round_arch of round is

	signal mid_man: unsigned(m downto 0);
	signal mid_Rman: unsigned(m downto 0);
	signal LGR: std_logic_vector(2 downto 0);  --this mid signal stores the 3 last bits of input mantissa
                                                   --then uses them for round to nearest, tie to even
begin
        LGR <= man_in(2 downto 0);                                 
        mid_man <= unsigned('0' & man_in(n-2 downto 2));
        mid_Rman <= mid_man when LGR(1 downto 0) < "10" else
                    mid_man + 1 when LGR(1 downto 0) > "10" else
                    mid_man when LGR = "010" else
                    mid_man + 1 when LGR = "110" else
                    "XXXXXXXXXXXXXXXXXXXXXXXX";
        man_out <= std_logic_vector(mid_Rman(m-1 downto 0));
        rovf <= std_logic(mid_Rman(m));  

end round_arch;