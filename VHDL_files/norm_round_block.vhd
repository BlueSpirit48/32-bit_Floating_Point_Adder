--normalization and rounding block
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity norm_round_block is
    	port(exp_max: in std_logic_vector(7 downto 0);    --larger of the two exponent
	     sum_man: in std_logic_vector(25 downto 0);   --sum of the two mantissas
	     cout: in std_logic;                          --possible carry out from the addition of the two mantissas
	     exp_out: out std_logic_vector(7 downto 0);   --final exponent
	     man_out: out std_logic_vector(22 downto 0);  --final mantissa
	     rovf,inf,unf: out std_logic                  --possible flags for [Rovf: overflow from Rounding, Inf: overflow from Exp increment, Undf: underflow from Exp decrement]
	);
end norm_round_block;

architecture norm_round_block_arch of norm_round_block is
    
	--leading zero counter component
    	component zero_count 
    		generic(n: integer);
    		port(man_in: in std_logic_vector(n-1 downto 0);    
                     zeros: out std_logic_vector(4 downto 0)   
        	);
    	end component;

	--left or right shift component
    	component  shift_LR 
		generic(n: integer; m:integer);
		port(man_in: in std_logic_vector( n-1 downto 0);
                     zero_count: in std_logic_vector( m-1 downto 0);
                     cout: in std_logic;
                     man_out: out std_logic_vector(n-1 downto 0)
        	);
    	end component;

	--exponent increment or decrement 
    	component inc_dec_exp 
    		generic(n: integer:=8);
    		port(exp_in: in std_logic_vector( n-1 downto 0);
                     zero_count: in std_logic_vector( 4 downto 0);
                     cout: in std_logic;
                     exp_out: out std_logic_vector( n-1 downto 0);
                     unf,inf: out std_logic
    		);
    	end component;

	--rounding component
    	component round 
        	generic(n: integer:= 26; m: integer:=23);
        	port(man_in: in std_logic_vector(n-1 downto 0);
                     man_out: out std_logic_vector(m-1 downto 0);
                     rovf: out std_logic
        	);
    	end component;
    
    	--mid signals
    	signal mid_zero_count: std_logic_vector(4 downto 0);  
    	signal mid_shifted_man: std_logic_vector(25 downto 0);     
	
begin
	
	--component instatiation
    	LeadingZeroCount: zero_count generic map(n => 26)
                                     port map(man_in => sum_man, zeros => mid_zero_count);
								 
    	shiftLR: shift_LR generic map(n => 26, m => 5)
                          port map(man_in => sum_man, zero_count => mid_zero_count, cout => cout, man_out => mid_shifted_man);
						   
    	expIncDec: inc_dec_exp generic map(n => 8)
                               port map(exp_in => exp_max, zero_count => mid_zero_count, cout => cout, 
					exp_out => exp_out, unf => unf, inf => inf);
						   
    	rounding: round generic map(n => 26, m => 23)
                        port map (man_in => mid_shifted_man, man_out => man_out, rovf => rovf);

end norm_round_block_arch;