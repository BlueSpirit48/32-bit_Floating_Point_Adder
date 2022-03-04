#Adder Block_Phase2
vsim -gui work.Adder_Block
#inputs
add wave AMan
add wave BMan 
add wave SA
add wave SB
add wave CMP
add wave NShiftBits
#outputs
add wave Sout
add wave SumMan
add wave  Cout
#mid_Signals
add wave mid_MuxOut0
add wave mid_MuxOut1
add wave mid_ShMuxOut0
add wave mid_FullCMP
#----------------Test----------------------------#
#0 10001000 11111011011010101110000100
force AMan 01111101101101010111000010
#0 10001001 11111010011000001100000100
force BMan 11111010011000001100000100
force SA 0
force SB 0
force CMP 0
force NShiftBits 00001
run 100