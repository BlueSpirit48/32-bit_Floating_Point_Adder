--behavioral addition of the two mantissas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity big_ALU is
    generic(n : integer:= 26);
    port( manA,manB: in std_logic_vector(n-1 downto 0);  --mantissas of A,B
          full_cmp: in std_logic_vector( 1 downto 0);    --full full compare vector
          sA,sB: in std_logic;                           --signs of A,B
          sum_man: out std_logic_vector(n-1 downto 0);   --sum of the two mantissas
          cout: out std_logic                            --carry out
    );
end big_ALU;

architecture big_ALU_arch of big_ALU is
    --supp signals_extra bit for carry
    signal mid_manA: unsigned(n downto 0);
    signal mid_manB: unsigned(n downto 0);
    signal mid_sum_man: unsigned(n downto 0);
 begin
    mid_manA <= unsigned('0'& manA);
    mid_manB <= unsigned('0'& manB);
    process(mid_manA,mid_manB,full_cmp,sA,sB)
    begin
		--same sign_just add them
        if(sA = sB) then
			mid_sum_man <= mid_manA + mid_manB;
        --diff sign & manB > manA 
        elsif full_cmp = "01" then
            mid_sum_man <= mid_manB - mid_manA;
        --diff sign & manA >= manB
        elsif full_cmp(1) = '1' then
            mid_sum_man <= mid_manA - mid_manB;
        end if;
	end process;
	
    --output logic
    sum_man <= std_logic_vector(mid_sum_man(n-1 downto 0));
    cout <= std_logic(mid_sum_man(n));

end big_ALU_arch;