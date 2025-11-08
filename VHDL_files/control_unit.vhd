--controls the entire operation
--via control signals taken from stage units and driven to later stage ones
--and enable signals of input and output regs

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
	port(--clock and reset input signals
	     clk,rst: in std_logic;

	     --signal to start the operations
	     start: in std_logic;
	     
	     --control input signals
	     spec_case: in std_logic;                          --initial input special case check
	     rovf: in std_logic;                               --overflow in rounding
	     inc_dec_inf: in std_logic;                        --infinity in increament/decreament of exponent
         inc_dec_unf: in std_logic;                        --underflow in increament/decreament of exponent
	     
	     --output control signals
	     spec_case_out: out std_logic;                                                         
	     rovf_out: out std_logic;                         
	     inc_dec_inf_out: out std_logic;                        
         inc_dec_unf_out: out std_logic;

	     regs_control: out std_logic_vector(1 downto 0);    --inreg_wr & outreg_wr
         done: out std_logic
	    );
end control_unit;

architecture control_unit_arch of control_unit is 

--states declaration
type state is (wait_state, special_state, mid_state, output_state);
signal pr_state, nx_state: state;

begin
	
	--clock and reset process
	P1: process(clk,rst)
	begin
		if(rst='1') then
			pr_state <= wait_state;
		elsif(clk'event and clk='1') then
			pr_state <= nx_state;
		end if;
	end process P1;

	--next state and output process
	P2: process(start, pr_state, spec_case)   
	begin
		case pr_state is
			when wait_state => 
				if(start='1') then  
					nx_state <= special_state;
				else
					nx_state <= wait_state;
				end if;
			when special_state => 
				
				if(spec_case='1') then   
					nx_state <= mid_state;
				else
					nx_state <= output_state;
				end if;
			when mid_state =>
				nx_state <= output_state;
			when output_state =>
				--done <= '1';
				nx_state <= wait_state;
		end case;
	end process P2;
--output logic--
	regs_control <= "00" when pr_state = special_state else
			        "00" when pr_state = mid_state else
      			    "01" when pr_state = output_state else
			        "10";
	spec_case_out <= spec_case when pr_state = mid_state else
	                 spec_case when pr_state = output_state else
	                 'X';
	rovf_out <= rovf when pr_state = output_state else
	            'X';                         
	inc_dec_inf_out <= inc_dec_inf when pr_state = output_state else
	                   'X';                     
    inc_dec_unf_out <= inc_dec_unf when pr_state = output_state else
                        'X';
    done <= '1' when pr_state = output_state else
            '0'; 
	
	
end control_unit_arch;