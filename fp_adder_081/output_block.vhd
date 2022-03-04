--prepares the final data to be stored in the output register

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity output_block is
    	port(spec_num: in std_logic_vector(31 downto 0);    --special case number 
             sout: in std_logic;                            --sign out
             exp: in std_logic_vector(7 downto 0);          --exponent after inc/dec stage 
             man:in std_logic_vector(22 downto 0);          --mantissa after rounding stage 
             rovf,inf,unf: in std_logic;                    --round-overflow, infinity, underflow flags
             en: in std_logic;                              --initial special case check
             output: out std_logic_vector(31 downto 0);     --final output value
             unf_flag: out std_logic                        --underflow flag
	);
end output_block;

architecture output_block_arch of output_block is
    
    	--multiplexer component
    	component mux 
		generic(n: integer);
		port(in0,in1: in std_logic_vector(n-1 downto 0);
		     sel: in std_logic;
		     mux_out: out std_logic_vector(n-1 downto 0)
		);
    	end component;
    
	--round overflow component
    	component round_ovf
        	generic(n:integer);
        	port(exp_in: in std_logic_vector(n-1 downto 0);
                     rovf: in std_logic;
                     inf: in std_logic;
                     exp_out: out std_logic_vector( n-1 downto 0)
      		);
    	end component;
    
	--output vector component
    	component vector_out is
        	port(sout:in std_logic;
                     exp_out: in std_logic_vector(7 downto 0);
                     man_out: in std_logic_vector(22 downto 0);
                     fpa_out: out std_logic_vector(31 downto 0)
		);
    	end component;
	
    	--mid signals
    	signal zero_man: std_logic_vector(22 downto 0);  --infinity ready value in the case of overflow in the increment/decrement of exponent stage
    	signal mid_man: std_logic_vector(22 downto 0);        
    	signal mid_exp: std_logic_vector(7 downto 0);
    	signal mid_vector: std_logic_vector(31 downto 0);
	
begin
        --component instatiation
	zero_man <= (others => '0');
        
        mux1: mux generic map(n => 23)
                  port map(in0 => man, in1 => zero_man, sel => inf, 
			   mux_out => mid_man );
        
        round_ovf_case: round_ovf generic map(n => 8)
                                  port map(exp_in => exp, rovf => rovf, inf => inf, exp_out => mid_exp);
        
        vector_block: vector_Out port map(sout => sout, exp_out => mid_exp, man_out => mid_man, fpa_out => mid_vector);

        mux2: mux generic map(n => 32)
                  port map(in0 => mid_vector, in1 => spec_num, sel => en, 
			   mux_out => output);
    
        unf_flag <= unf;
       
end output_block_arch;