--unit that checks for special cases of inputs and determines output
--for said special cases

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity special_case is
	port(sA,sB: in std_logic;                           --sign of inputs A,B
	     expA,expB: in std_logic_vector(7 downto 0);    --exponent of inputs A,B
	     manA,manB: in std_logic_vector(22 downto 0);   --mantissa of inputs A,B
	     typeA,typeB: in std_logic_vector(2 downto 0);  --types of inputs A,B
          
	     en: out std_logic;                             --enable for later use(small ALU)
	     spec_num: out std_logic_vector(31 downto 0));  --special case output number value
end special_case;

architecture special_case_arch of special_case is

	--signal sO: std_logic;                               --sign of output in special case
	--signal expO: std_logic_vector(7 downto 0);          --exponent of output in special case
	--signal manO: std_logic_vector(22 downto 0);         --mantissa of output in special case

begin
	process(typeA,typeB,sA,sB,expA,expB,manA,manB)
	variable sO: std_logic;
	variable expO: std_logic_vector(7 downto 0);
	variable manO: std_logic_vector(22 downto 0);
	variable enable: std_logic;
	begin
		--both A and B are normals--
		if ((typeA and typeB)="010") then  --normal case, normal operation
				enable := '1';
				sO := 'X';
				expO := "XXXXXXXX";
				manO := "XXXXXXXXXXXXXXXXXXXXXXX";
		else
			enable := '0';
			--one is subnormal--
			if (typeA="001") then
				sO := sB;
				expO := expB;
				manO := manB;
			elsif (typeB="001") then
				sO := sA;
				expO := expA;
				manO := manA;
			
			--both are subnormals--
			--if ((typeA and typeB)="001") then	
			--	sO <= '0';
			--	expO <= "00000000";
			--	manO <= "00000000000000000000000";
			--end if;
			
			--one is zero--
			elsif (typeA="000") then	
				sO := sB;
				expO := expB;
				manO := manB;
			elsif (typeB="000") then	
				sO := sA;
				expO := expA;
				manO := manA;

			--both are zero--
			--if ((typeA and typeB)="000") then	
			--	sO <= sA;
			--	expO <= expA;
			--	manO <= manA;
			--end if;
			
			--one is NaN--
			elsif (typeA="100") then	
				sO :=sA;
				expO := expA;
				manO := manA;
			elsif (typeB="100") then	
				sO := sB;
				expO := expB;
				manO := manB;
	
			--one is infinity--
			elsif (typeA="101" and typeB(2)='0') then	
				sO := sA;
				expO := expA;
				manO := manA;
			elsif (typeA(2)='0' and typeB="101") then 	
				sO := sB;
				expO := expB;
				manO := manB;
	
			--both are infity 
			elsif ((typeA and typeB)="101") then
				if(sA/=sB) then --different signs
					sO := '0';
					expO := "11111111";
					manO := "00000000000000000000001";
				else --same signs
					sO := sA;
					expO := expA;
					manO := manA;
				end if;
			else 
				sO := 'X';
				expO := "XXXXXXXX";
				manO := "XXXXXXXXXXXXXXXXXXXXXXX";	
			end if;	
		end if;
		spec_num <= sO & expO & manO;
		en <= enable;
	end process;
	
	
	
end special_case_arch;