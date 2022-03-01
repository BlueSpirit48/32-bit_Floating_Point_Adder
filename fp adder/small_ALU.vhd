--unit that calculates the larger exponent
--and the amount that the mantissa should be shifted 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity small_ALU is
	port(expA,expB: in std_logic_vector(7 downto 0);  --exponent of inputs A,B
	     en: in std_logic;                            --enable signal for unit
	     cmp: out std_logic;                          --bit that indicates which exp is larger
         exp_out: out std_logic_vector(7 downto 0);    --larger exponent(which will be used later)
	     shift: out std_logic_vector(4 downto 0)      --number of shifts to align the exponents                                 
	     );
end small_ALU;
architecture small_ALU_arch of small_ALU is
	signal c: std_logic;
begin
	process(en,expA,expB)
	variable dif: signed(7 downto 0);
	begin
		if(en='1') then
			if(unsigned(expA) > unsigned(expB)) then ----------------------B needs shifting
				c <= '1';
				exp_out <= expA;
				dif := signed(expA) - signed(expB);
				if (unsigned(dif)<="11010") then
					shift <= std_logic_vector(dif(4 downto 0));
				elsif (unsigned(dif)>"11010") then
					shift <= "11010"; --the result becomes subnormal 
				else
					shift <= "XXXXX";
				end if;
			elsif(unsigned(expA) < unsigned(expB)) then -------------------A needs shifting
				c <= '0';
				exp_out <= expB;
				dif := signed(expB) - signed(expA);
				if (unsigned(dif)<="11010") then
					shift <= std_logic_vector(dif(4 downto 0));
				elsif (unsigned(dif)>"11010") then
					shift <= "11010"; --the result becomes subnormal 
				else
					shift <= "XXXXX";
				end if;
			elsif(unsigned(expA) = unsigned(expB)) then -------------------no shifting needed
				c <= '1';
				exp_out <= expA;
				shift <= "00000";
			end if;
		end if;
	end process;

	cmp <= c;

end small_ALU_arch;