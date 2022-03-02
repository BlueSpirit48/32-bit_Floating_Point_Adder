--32-bit floating point adder block

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder is
    	port(clk,rst: in std_logic;                            --clock and reset signals
             start: in std_logic;                              --start signal to initiate operation
        
             numA,numB: in std_logic_vector(31 downto 0);     --the two input numbers 
             flag: out std_logic;                              --output flag
             regs_control: out std_logic_vector(1 downto 0);   --register control signal (MSB=inreg_wr, LSB=outreg_wr)
             sum: out std_logic_vector(31 downto 0)            --output sum
   	 );
end fp_adder;

architecture fp_adder_arch of fp_adder is

	--input register component
	component input_register is
		port(clk,rst: in std_logic;                          --register clock and reset signals
	             wr_en: in std_logic;                            --register write and read enables
	             numA,numB: in std_logic_vector( 31 downto 0);   --the two float numbers
                     sA,sB: out std_logic;                           --sign of each number
	             expA,expB: out std_logic_vector( 7 downto 0);   --exponent of A,B
                     manA,manB: out std_logic_vector( 22 downto 0)   --mantissa of A,B
		);
	end component;
	
	--special case component
	component special_case_block is
		port(sA,sB: in std_logic;                           --sign of A,B
		     expA,expB: in std_logic_vector(7 downto 0);    --exponent of A,B
	             manA,manB: in std_logic_vector(22 downto 0);   --mantissa of A,B
	             en: out std_logic;                             --bit that says whether is special case or not
	             spec_num: out std_logic_vector(31 downto 0)    --special case output number value
		);
	end component;
	
	--exponent comparison component
    	component exp_compare_block is
		port(en: in std_logic;
	             expA,expB: in std_logic_vector(7 downto 0);           --exponents of A,B
                     manA_in,manB_in: in std_logic_vector(22 downto 0);    --mantissas of A,B
	             cmp: out std_logic;                                   --bit that indicates which exp is larger
	             exp_out: out std_logic_vector(7 downto 0);            --larger exponent
	             shift: out std_logic_vector(4 downto 0);              --number of shifts to align the exponents
	             manA_out,manB_out: out std_logic_vector(25 downto 0)  --mantissas with extra necessary bits
		);
	end component;
    
	--mantissas addition component
    	component addition_block is
		port(manA,manB : in std_logic_vector(25 downto 0);   --the two mantissas to be added
	             sA,sB: in std_logic;                            --signs of numbers A,B
            	     cmp: in std_logic;                              --bit that indicates which number had the larger exponent 
                     shift: in std_logic_vector( 4 downto 0);        --number of shifts needed in the mantissa with the smaller exponent
                     sout: out std_logic;                            --sign of the larger number
                     sum_man: out std_logic_vector( 25 downto 0);    --the output sum of the two mantissas
                     cout: out std_logic                             --possible carry out
		);
	end component;

	--normalization and rounding block 
	component norm_round_block is
		port(exp_max: in std_logic_vector(7 downto 0);    --larger of the two exponent
		     sum_man: in std_logic_vector(25 downto 0);   --sum of the two mantissas
		     cout: in std_logic;                          --possible carry out from the addition of the two mantissas
		     exp_out: out std_logic_vector(7 downto 0);   --final exponent
		     man_out: out std_logic_vector(22 downto 0);  --final mantissa
		     rovf,inf,unf: out std_logic                  --possible flags for [Rovf: overflow from Rounding, Inf: overflow from Exp increment, Undf: underflow from Exp decrement]
		);
	end component;
    
	--output block component
	component output_block is
		port(spec_num: in std_logic_vector(31 downto 0);    --special case number 
		     sout: in std_logic;                            --sign out
		     exp: in std_logic_vector(7 downto 0);          --exponent after inc/dec stage 
		     man:in std_logic_vector(22 downto 0);          --mantissa after rounding stage 
		     rovf,inf,unf: in std_logic;                    --round-overflow, infinity, underflow flags
		     en: in std_logic;                              --initial special case check
		     output: out std_logic_vector(31 downto 0);     --final output value
	             unf_flag: out std_logic                        --underflow flag
		);
	end component;

	--control unit component
    	component control_unit is
		port(clk,rst: in std_logic;
	             start: in std_logic;
	             spec_case: in std_logic;                          --initial input special case check
	             cmp: in std_logic;                                --exponent compare
	             shift_num: in std_logic_vector(4 downto 0);       --number of shifts needed in mantissa
	             cout: in std_logic;                               --carry out from mantissa addition
	             rovf: in std_logic;                               --overflow in rounding
	             inc_dec_inf: in std_logic;                        --infinity in increament/decreament of exponent
                     inc_dec_unf: in std_logic;                        --underflow in increament/decreament of exponent
	             spec_case_out: out std_logic;                          
	             cmp_out: out std_logic;                                
	             shift_num_out: out std_logic_vector(4 downto 0);       
	             cout_out: out std_logic;                               
	             rovf_out: out std_logic;                         
	             inc_dec_inf_out: out std_logic;                        
                     inc_dec_unf_out: out std_logic;
	             regs_control: out std_logic_vector(1 downto 0)    --control signals for input and output registers (inreg_wr & outreg_wr)
		);
	end component; 
	
	component output_register is
		port(clk,rst: in std_logic;
		     wr_en: in std_logic;
		     sum_in: in std_logic_vector(31 downto 0);         --the sum of the fp adder
		     unf_flag_in: in std_logic;                        --underflow flag in the case where the exponent after the inc/dec stage becomes zero
		     sum_out: out std_logic_vector(31 downto 0);
		     unf_flag_out: out std_logic
		);
	end component;

    
        --input register mid signals
	signal mid_sA, mid_sB: std_logic;
	signal mid_expA, mid_expB: std_logic_vector(7 downto 0);
	signal mid_manA, mid_manB: std_logic_vector(22 downto 0);
	
	--special case block mid signals
        signal spec_case_out: std_logic;                        
        signal spec_case_in: std_logic;
        signal not_spec_case_out: std_logic;
        signal spec_num: std_logic_vector(31 downto 0);

	--exponent compare block mid signals
        signal cmp_in, cmp_out: std_logic;                       
        signal exp_out: std_logic_vector(7 downto 0);           
        signal shift_in, shift_out: std_logic_vector(4 downto 0); 
        signal manA_out,manB_out: std_logic_vector(25 downto 0);

	--addition block mid signals
        signal sout: std_logic;
        signal sum_man: std_logic_vector(25 downto 0);
        signal cout_in, cout_out: std_logic;

	--normalization and rounding block mid signals
        signal out_exp: std_logic_vector(7 downto 0);
        signal man_out: std_logic_vector(22 downto 0);
        signal rovf_out,inf_out,unf_out: std_logic;
        signal rovf_in,inf_in,unf_in: std_logic;

	
        signal mid_regs_control: std_logic_vector(1 downto 0);
	
	--output register mid signals
        signal mid_sum_in: std_logic_vector(31 downto 0);
        signal mid_unf_flag_out: std_logic;
begin
	
	not_spec_case_out <= not spec_case_out;
	
	--component instatiation
	in_register: input_register port map(clk => clk, rst => rst, wr_en => mid_regs_control(1), 
					     numA => numA, numB => numB, 
					     sA => mid_sA, sB => mid_sB,                        
					     expA => mid_expA, expB => mid_expB, 
					     manA => mid_manA,manB => mid_manB);
	
	control: control_unit port map(clk => clk, rst => rst, start => start,
				       spec_case => spec_case_in, cmp => cmp_in, shift_num => shift_in, cout => cout_in,                              
				       rovf => rovf_in, inc_dec_inf => inf_in, inc_dec_unf => unf_in,                        
				       spec_case_out => spec_case_out, cmp_out => cmp_out, shift_num_out => shift_out,     
				       cout_out => cout_out, rovf_out => rovf_out, inc_dec_inf_out => inf_out, inc_dec_unf_out => unf_out,
				       regs_control => mid_regs_control);
    
	special_case: special_case_block port map(sA => mid_sA, sB => mid_sB,
			                          expA => mid_expA, expB => mid_expB, 
	                                          manA => mid_manA, manB => mid_manB,
	                                          en => spec_case_in,                            
	                                          spec_num => spec_num);         

	exponent_comparison: exp_compare_block port map(en => spec_case_out, expA => mid_expA, expB => mid_expB,
						        manA_in => mid_manA, manB_in => mid_manB,
						        cmp => cmp_in, exp_out => exp_out, shift => shift_in,
						        manA_out => manA_out, manB_out => manB_out);

    	add_block: addition_block port map (manA => manA_out, manB => manB_out, sA => mid_sA, sB => mid_sB, cmp => cmp_out, shift => shift_out, 
					    sout => sout, sum_man => sum_man, cout => cout_in);
										
    	normalize_rounding: norm_round_block port map(exp_max => exp_out, sum_man => sum_man, cout => cout_out,                          
						      exp_out => out_exp, man_out => man_out, rovf => rovf_in, inf => inf_in, unf => unf_in);
																			
    	final_output: output_block port map(spec_num => spec_num, sout => sout, exp => out_exp, man => man_out, rovf => rovf_out,inf => inf_out,
					    unf => unf_out, en => not_spec_case_out,
					    output => mid_sum_in, unf_flag => mid_unf_flag_out);
	
     	out_register: output_register port map(clk => clk, rst => rst, wr_en => mid_regs_control(0),
					       sum_in => mid_sum_in, unf_flag_in => mid_unf_flag_out,
				               sum_out => sum, unf_flag_out => flag);
	regs_control <= mid_regs_control;

end fp_adder_arch;


