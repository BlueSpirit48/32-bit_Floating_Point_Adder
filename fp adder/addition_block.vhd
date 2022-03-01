--this block performs the addition of the two mantissas 
--and calculates the sign of the final output

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addition_block is
    port(
        manA,manB : in std_logic_vector(25 downto 0);   --the two mantissas to be added
	sA,sB: in std_logic;                            --signs of numbers A,B
        cmp: in std_logic;                              --bit that indicates which number had the larger exponent 
        shift: in std_logic_vector( 4 downto 0);        --number of shifts needed in the mantissa with the smaller exponent
        sout: out std_logic;                            --sign of the larger number
        sum_man: out std_logic_vector( 25 downto 0);    --the output sum of the two mantissas
        cout: out std_logic                             --possible carry out
    );
end addition_block;

architecture addition_block_arch of addition_block is 

    --multiplexer component
    component mux 
    generic(n: integer);
    port(
        in0,in1: in std_logic_vector( n-1 downto 0);
        sel: in std_logic;
        mux_out: out std_logic_vector( n-1 downto 0)
    );
    end component;
    
    --shift the mantissa of the number with the smaller exp component
    component shift_R is
        generic(n: integer; m: integer);
        port(
            man_in: in std_logic_vector(n-1 downto 0);
            shift: in std_logic_vector(m-1 downto 0);
            man_out: out std_logic_vector(n-1 downto 0)
        );
    end component;
 
    --full comparison of the two numbers component
    component compare is
        generic(n: integer);
        port( 
            manA,manB: in std_logic_vector(n-1 downto 0);
            cmp: in std_logic;
            full_cmp: out std_logic_vector(1 downto 0)
        );
    end component;
    
    --signout component
    component signout is
        port(
            sA,sB: in std_logic;
            full_cmp: in std_logic_vector(1 downto 0);
            sout: out std_logic
        );
    end component;

    --big_ALU component
    component big_ALU is
        generic(n : integer);
        port(manA,manB: in std_logic_vector(n-1 downto 0);
             full_cmp: in std_logic_vector( 1 downto 0);
             sA,sB: in std_logic;
             sum_man: out std_logic_vector(n-1 downto 0);
             cout: out std_logic
        );
    end component;
	
    --supp signals/wires
    signal mid_mux_out0: std_logic_vector( 25 downto 0);
    signal mid_mux_out1: std_logic_vector( 25 downto 0);
    signal mid_shifted_man: std_logic_vector( 25 downto 0);
    signal mid_full_cmp : std_logic_vector( 1 downto 0);

    begin
		
        --component instatiation
        mux1: mux generic map (n => 26)
                            port map (in0 => manA, in1 => manB, sel => cmp, 
                                      mux_out => mid_mux_out0);
        mux2: mux generic map (n => 26)
                            port map (in0 => manB, in1 => manA, sel => cmp, 
                                      mux_out => mid_mux_out1);
							
        shiftR: shift_R generic map (n => 26, m => 5)
                            port map(man_in => mid_mux_out0, shift => shift, man_out => mid_shifted_man);
								
        fullcmp: compare generic map (n=> 26)
                         port map (manA => manA, manB => manB, cmp => cmp, full_cmp => mid_full_cmp);
									
        sign_out: signout port map (sA => sA, sB => sB, full_cmp => mid_full_cmp, sout => sout);
		
        adder: big_ALU generic map (n => 26)
                       port map (manA => mid_shifted_man, manB => mid_mux_out1, full_cmp => mid_full_cmp, sA =>sA, sB => sB, sum_man => sum_man, cout => cout);
        
end addition_block_arch;
 
 