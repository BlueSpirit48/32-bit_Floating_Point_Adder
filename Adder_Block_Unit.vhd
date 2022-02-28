--This block do the addition of the two floating point numbers mantissas 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder_Block is
    port(
        AMan,BMan : in std_logic_vector(25 downto 0);
	SA,SB: in std_logic;
        CMP: in std_logic;
        NShiftBits: in std_logic_vector( 4 downto 0);
        Sout: out std_logic;
        SumMan: out std_logic_vector( 25 downto 0);
        Cout: out std_logic
    );
end Adder_Block;

architecture Adder_Block_arch of Adder_Block is 

    component nInputBit_MUX 
    generic(n: integer);
    port(
        in0,in1: in std_logic_vector( n-1 downto 0);
        sel: in std_logic;
        outMux: out std_logic_vector( n-1 downto 0)
    );
    end component;
    
    component nbit_Shift_Right is
        generic(n: integer; m: integer);
        port(
            inShift: in std_logic_vector(n-1 downto 0);
            shiftBit: in std_logic_vector(m-1 downto 0);
            outShift: out std_logic_vector(n-1 downto 0)
        );
    end component;

    component full_compare_block is
        generic(n: integer);
        port( 
            AMan,BMan: in std_logic_vector(n-1 downto 0);
            CMP: in std_logic;
            FullCMP: out std_logic_vector(1 downto 0)
        );
    end component;
    
    component signout_block is
        port(
            SA,SB: in std_logic;
            FullCMP: in std_logic_vector(1 downto 0);
            Sout: out std_logic
        );
    end component;

    component nBitAdder is
        generic(n : integer);
        port( AMan,BMan: in std_logic_vector(n-1 downto 0);
              FullCMP: in std_logic_vector( 1 downto 0);
              SA,SB: in std_logic;
              SumMan: out std_logic_vector(n-1 downto 0);
              Cout: out std_logic
        );
    end component;
    --supp signals/wires
    signal mid_MuxOut0: std_logic_vector( 25 downto 0);
    signal mid_MuxOut1: std_logic_vector( 25 downto 0);
    signal mid_ShMuxOut0: std_logic_vector( 25 downto 0);
    signal mid_FullCMP : std_logic_vector( 1 downto 0);

    begin
        mux1: nInputBit_MUX generic map( n => 26)
                            port map( in0 => AMan, in1 => BMan, sel => CMP, outMUX => mid_MuxOut0);
        mux2: nInputBit_MUX generic map( n => 26)
                            port map( in0 => BMan, in1 => AMan, sel => CMP, outMUX => mid_MuxOut1);
        shiftR: nbit_Shift_Right generic map(n => 26, m => 5)
                                port map( inShift => mid_MuxOut0, shiftBit => NShiftBits, outShift => mid_ShMuxOut0);
        fullcmp: full_compare_block generic map( n=> 26)
                                    port map(AMan => AMan, BMan => BMan, CMP =>CMP, FullCMP => mid_FullCMP);
        signout: signout_block port map( SA => SA, SB => SB, FullCMP => mid_FullCMP, Sout => Sout);
        adder: nBitAdder generic map( n => 26)
                         port map(AMan => mid_ShMuxOut0, BMan => mid_MuxOut1, FullCMP => mid_FullCMP, SA =>SA, SB => SB, SumMAn => SumMan, Cout => Cout);
        


 end Adder_Block_arch;
 