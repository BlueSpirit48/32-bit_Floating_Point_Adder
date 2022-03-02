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
	     cmp: in std_logic;                                --exponent compare
	     shift_num: in std_logic_vector(4 downto 0);       --number of shifts needed in mantissa
	     cout: in std_logic;                               --carry out from mantissa addition
	     rovf: in std_logic;                               --overflow in rounding
	     inc_dec_inf: in std_logic;                        --infinity in increament/decreament of exponent
             inc_dec_unf: in std_logic;                        --underflow in increament/decreament of exponent
	     
	     --output control signals
	     spec_case_out: out std_logic;                          
	     cmp_out: out std_logic;                                
	     shift_num_out: out std_logic_vector(4 downto 0);       
	     cout_out: out std_logic;                               
	     rovf_out: out std_logic;                         
	     inc_dec_inf_out: out std_logic;                        
             inc_dec_unf_out: out std_logic;

	     regs_control: out std_logic_vector(1 downto 0)    --inreg_wr & outreg_wr

	     --done: out std_logic;
	    );
end control_unit;

architecture control_unit_arch of control_unit is 

--states declaration
type state is (wait_state, yellow_state, rose_state, red_state, lblue_state, dblue_state);
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
	P2: process(pr_state, spec_case, cmp, shift_num, cout,rovf, inc_dec_inf, inc_dec_unf)   
	begin
		case pr_state is
			when wait_state => 
				regs_control <= "10";
				if(start='1') then  
					nx_state <= yellow_state;
				else
					nx_state <= wait_state;
				end if;
			when yellow_state =>
				regs_control <= "00";   --maybe make it mealy to enable write in reg_out sooner
				spec_case_out <= spec_case;
				if(spec_case='1') then   
					nx_state <= rose_state;
				else
					nx_state <= dblue_state;
				end if;
			when rose_state =>
				regs_control <= "00";
				cmp_out <= cmp;                               
	     			shift_num_out <= shift_num;
				nx_state <= red_state;
			when red_state =>
				regs_control <= "00";
				cout_out <= cout;
				nx_state <= lblue_state;
			when lblue_state => 
				regs_control <= "00";
				rovf_out <= rovf;                         
	     			inc_dec_inf_out <= inc_dec_inf;                     
             			inc_dec_unf_out <= inc_dec_unf;
				nx_state <= dblue_state;
			when dblue_state =>
				regs_control <= "01"; ----????
				--done <= '1';
				nx_state <= wait_state;
		end case;
	end process P2;
	
end control_unit_arch;