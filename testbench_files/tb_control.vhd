--testbench for the control unit block

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_control_unit is
--empty
end tb_control_unit;

architecture tbench of tb_control_unit is
    
    constant T: TIME := 10 ns; --clock period
    
    component control_unit
		port(clk,rst: in std_logic;
	             start: in std_logic;
	             spec_case: in std_logic;                          --initial input special case check
	             rovf: in std_logic;                               --overflow in rounding
	             inc_dec_inf: in std_logic;                        --infinity in increament/decreament of exponent
                     inc_dec_unf: in std_logic;                        --underflow in increament/decreament of exponent
	             spec_case_out: out std_logic;                                                        
	             rovf_out: out std_logic;                         
	             inc_dec_inf_out: out std_logic;                        
                      inc_dec_unf_out: out std_logic;
	             regs_control: out std_logic_vector(1 downto 0); --control signals for input and output registers (inreg_wr & outreg_wr)
		         done: out std_logic
		);
	end component; 

        signal clk,rst: std_logic;
	signal start: std_logic;
	signal spec_case: std_logic;                          --initial input special case check
	signal rovf: std_logic;                               --overflow in rounding
	signal inc_dec_inf: std_logic;                        --infinity in increament/decreament of exponent
        signal inc_dec_unf: std_logic;
        signal spec_case_out: std_logic;                                                        
	signal rovf_out: std_logic;                         
	signal inc_dec_inf_out: std_logic;                        
        signal inc_dec_unf_out: std_logic;
	signal regs_control: std_logic_vector(1 downto 0); --control signals for input and output registers (inreg_wr & outreg_wr)
	signal done: std_logic;

    begin
        UUT: control_unit port map(clk => clk, rst => rst, start => start,
                                    spec_case => spec_case,                              
                                    rovf => rovf, inc_dec_inf => inc_dec_inf, inc_dec_unf => inc_dec_unf, 
                                    spec_case_out => spec_case_out, rovf_out => rovf_out, inc_dec_inf_out => inc_dec_inf_out, inc_dec_unf_out => inc_dec_unf_out,
                                    regs_control => regs_control,done => done);
        --clock and reset  
	clk_gen: process
	begin
	    clk <= '0';
    	    wait for T/2;
    	    clk <= '1';
    	    wait for T/2;
	end process clk_gen;

	rst <= '1', '0' after T/4;

	--input signals
	test_b: process
	begin
     	start <= '1' ;
     	spec_case <= '1';                         
     	rovf <= '0';                               
     	inc_dec_inf <= '0';                        
     	inc_dec_unf <= '0';
     	wait for 3*T;
     	spec_case <= '0';
    	wait for 3*T;
    	start <= '0';
    	wait for 2*T;
    	spec_case <= '1';
    	start <='1';
    	wait for 4*T;
    end process;

end tbench;