--this block simply collectes the exponent, the sign and the mantissa after all the operations 
--and concatenates them into a single 32-bit signal
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vector_out is
    port(
        sout:in std_logic;
        exp_out: in std_logic_vector(7 downto 0);    --final exponent after all the operations
        man_out: in std_logic_vector(22 downto 0);   --final mantissa after all the operations
        fpa_out: out std_logic_vector(31 downto 0)   --output is the final value of the addition as a 32bit floating point number 
    );
end vector_out;

architecture vector_out_arch of vector_out is
begin
    
	fpa_out <= sout & exp_out & man_out;
	
end vector_out_arch;