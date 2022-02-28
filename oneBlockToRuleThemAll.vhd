--The ring of power
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FPAdder is
    port(
        clk,rst: in std_logic;
        start: in std_logic;
        
        numA,numB: in std_logic_vector( 31 downto 0);
        flag: out std_logic;
        regs_control: out std_logic_vector(3 downto 0);
        sum: out std_logic_vector( 31 downto 0)

    );

end FPAdder;

architecture FPAdder_arch of FPAdder is
    component yellow_unit 
        port(sA,sB: in std_logic;                           --sign of A,B
             expA,expB: in std_logic_vector(7 downto 0);    --exponent of A,B
             manA,manB: in std_logic_vector(22 downto 0);   --mantissa of A,B
             
             en: out std_logic;                             --bit that says whether is special case or not
             spec_num: out std_logic_vector(31 downto 0)   --special case output number value
             );
    end component;
    
    component rose_unit
    port(
	     en: in std_logic;
	     expA,expB: in std_logic_vector(7 downto 0);         --exponents of A,B
             manA,manB: in std_logic_vector(22 downto 0);        --mantissas of A,B
	
	     cmp: out std_logic;                                 --bit that indicates which exp is larger
	     expOUT: out std_logic_vector(7 downto 0);           --larger exponent
	     shift: out std_logic_vector(4 downto 0);            --number of shifts to align the exponents
	     outManA,outManB: out std_logic_vector(25 downto 0)  --mantissas with extra necessary bits
	     );
    end component;

    component Adder_Block 
        port(
            AMan,BMan : in std_logic_vector(25 downto 0);
        SA,SB: in std_logic;
            CMP: in std_logic;
            NShiftBits: in std_logic_vector( 4 downto 0);
            Sout: out std_logic;
            SumMan: out std_logic_vector( 25 downto 0);
            Cout: out std_logic
        );
    end component;

    component Norm_Block is
        port(
        maxExp: in std_logic_vector( 7 downto 0);
        SumMan: in std_logic_vector( 25 downto 0);
        Cout: in std_logic;
        outExp: out std_logic_vector( 7 downto 0);
        outMan: out std_logic_vector( 22 downto 0);
        Rovf,Inf,Undf: out std_logic -- Rovf: overflow from Rounding, Inf: overflow from Exp increment, Undf: underflow from Exp decrement
        );
    end component;
    
    component output_block
        port(
            Spvector: in std_logic_vector( 31 downto 0);
            Signout: in std_logic;
            inExp: in std_logic_vector( 7 downto 0); 
            inMan:in std_logic_vector( 22 downto 0);
            Rovf,Inf,Undf: in std_logic;
            en: in std_logic;
            outRes: out std_logic_vector( 31 downto 0); 
            outUndf: out std_logic
        );
    end component;

    component control_unit 
        port(
            clk,rst: in std_logic;
            start: in std_logic;
            spec_case: in std_logic;                         
            cmp: in std_logic;                                
            shift_num: in std_logic_vector(4 downto 0);       
            cout: in std_logic;                               
            round_ovf: in std_logic;                         
            inc_dec_inf: in std_logic;                        
            inc_dec_unf: in std_logic;                        
            spec_case_out: out std_logic;                          
            cmp_out: out std_logic;                                
            shift_num_out: out std_logic_vector(4 downto 0);       
            cout_out: out std_logic;                               
            round_ovf_out: out std_logic;                         
            inc_dec_inf_out: out std_logic;                        
            inc_dec_unf_out: out std_logic;
            regs_control: out std_logic_vector(3 downto 0)    
        );
   end component; 

    
    --=============mid signals =====================--
    signal sc_bit_out : std_logic;
    signal sc_bit_in : std_logic;
    signal not_sc_bit: std_logic;
    signal spec_num: std_logic_vector( 31 downto 0);
    signal cmp_out: std_logic;
    signal cmp_in: std_logic;                       
    signal expOUT: std_logic_vector(7 downto 0);           
    signal shift_out: std_logic_vector(4 downto 0);
    signal shift_in: std_logic_vector(4 downto 0);            
    signal outManA,outManB: std_logic_vector(25 downto 0);
    signal Sout: std_logic;
    signal SumMan: std_logic_vector( 25 downto 0);
    signal cout_out: std_logic;
    signal cout_in: std_logic;
    signal outExp: std_logic_vector( 7 downto 0);
    signal outMan: std_logic_vector( 22 downto 0);
    signal Rovf_out,Inf_out,Undf_out: std_logic;
    signal Rovf_in,Inf_in,Undf_in: std_logic;
    begin
    
    control: control_unit port map( clk => clk, rst => rst, start => start, spec_case => sc_bit_in, cmp => cmp_in, shift_num => shift_in,
                                   cout => cout_in,  round_ovf => Rovf_in, inc_dec_inf => Inf_in, inc_dec_unf => Undf_in,
                                   spec_case_out => sc_bit_out, cmp_out => cmp_out, shift_num_out => shift_out,
                                   cout_out => cout_out,  round_ovf_out => Rovf_out, inc_dec_inf_out => Inf_out, 
                                   inc_dec_unf_out => Undf_out,regs_control => regs_control);
    
    yellow: yellow_unit port map(sA => numA(31), sB => numB(31), expA => numA(30 downto 23), expB => numB( 30 downto 23),
                                 manA => numA(22 downto 0), manB => numB(22 downto 0), en => sc_bit_in, spec_num => spec_num);

    pink: rose_unit port map( en => sc_bit_out, expA => numA(30 downto 23), expB => numB( 30 downto 23),
                              manA => numA(22 downto 0), manB => numB(22 downto 0), cmp => cmp_in,
                              expOUT => expOUT, shift => shift_in, outManA => outManA, outManB => outManB);
    
    red: Adder_Block port map( AMan => outManA, BMan => outManB, SA => numA(31) , SB => numB(31), 
                               CMP => cmp_out, NShiftBits => shift_out, Sout => Sout, SumMan => SumMan, Cout => cout_in);
    
    lightblue: Norm_Block port map( maxExp => expOUT, SumMan => SumMan, Cout => cout_out,
                                    outExp => outExp, outMan => outMan, Rovf => Rovf_in, Inf => Inf_in, Undf => Undf_in );
    not_sc_bit <= not sc_bit_out;
    darkblue: output_block port map( Spvector => spec_num, Signout => Sout, inExp => outExp, inMan => outMan,
                                     Rovf => Rovf_out, Inf => Inf_out , Undf => Undf_out, en => not_sc_bit,
                                     outRes => sum, outUndf => flag);


end FPAdder_arch;
