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
force AMan 10000000100001111101011100
force BMan 10011000100001111101011100
force SA 1
force SB 0
force CMP 1
force NShiftBits 00001
run 100