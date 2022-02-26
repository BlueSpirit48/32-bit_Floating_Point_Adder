-- This Block simple collectes the Exp, Signout and Mantissa and do it a singel 32bit signal 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vectorOut is
    port(
        signout:in std_logic;
        expout: in std_logic_vector( 7 downto 0);
        mantissa: in std_logic_vector( 22 downto 0);
        outFpn: out std_logic_vector( 31 downto 0) -- output is the final value of the addition as a 32bit floating point number 
    );
end vectorOut;

architecture vectorOut_arch of vectorOut is
begin
    outFpn <= signout & expout & mantissa;

end vectorOut_arch;