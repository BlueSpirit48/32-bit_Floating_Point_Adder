--The ring of power
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FPAdder is
    port(
        numA,numB: in std_logic_vector( 31 downto 0);
        flag: out std_logic;
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
    --=============mid signals =====================--
    signal sc_bit : std_logic;
    signal not_sc_bit: std_logic;
    signal spec_num: std_logic_vector( 31 downto 0);
    signal cmp: std_logic;                       
    signal expOUT: std_logic_vector(7 downto 0);           
    signal shift: std_logic_vector(4 downto 0);            
    signal outManA,outManB: std_logic_vector(25 downto 0);
    signal Sout: std_logic;
    signal SumMan: std_logic_vector( 25 downto 0);
    signal Cout: std_logic;
    signal outExp: std_logic_vector( 7 downto 0);
    signal outMan: std_logic_vector( 22 downto 0);
    signal Rovf,Inf,Undf: std_logic;
    begin
    
    yellow: yellow_unit port map(sA => numA(31), sB => numB(31), expA => numA(30 downto 23), expB => numB( 30 downto 23),
                                 manA => numA(22 downto 0), manB => numB(22 downto 0), en => sc_bit, spec_num => spec_num);

    pink: rose_unit port map( en => sc_bit, expA => numA(30 downto 23), expB => numB( 30 downto 23),
                              manA => numA(22 downto 0), manB => numB(22 downto 0), cmp => cmp,
                              expOUT => expOUT, shift => shift, outManA => outManA, outManB => outManB);
    
    red: Adder_Block port map( AMan => outManA, BMan => outManB, SA => numA(31) , SB => numB(31), 
                               CMP => cmp, NShiftBits => shift, Sout => Sout, SumMan => SumMan, Cout => Cout);
    
    lightblue: Norm_Block port map( maxExp => expOUT, SumMan => SumMan, Cout => Cout,
                                    outExp => outExp, outMan => outMan, Rovf => Rovf, Inf => Inf, Undf => Undf );
    not_sc_bit <= not sc_bit;
    darkblue: output_block port map( Spvector => spec_num, Signout => Sout, inExp => outExp, inMan => outMan,
                                     Rovf => Rovf, Inf => Inf , Undf => Undf, en => not_sc_bit,
                                     outRes => sum, outUndf => flag);


end FPAdder_arch;
