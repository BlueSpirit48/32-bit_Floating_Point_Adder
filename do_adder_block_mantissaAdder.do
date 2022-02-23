#Adder Block
vsim -gui work.nBitAdder

add wave AMan
add wave BMan
add wave FullCMP
add wave SA
add wave SB
add wave SumMan
add wave Cout

force -freeze AMan 01000000100001111101011100
force -freeze BMan 10000000100001111101011100
force -freeze FullCMP 10
force -freeze SA 0
force -freeze SB 0
run 100
force -freeze FullCMP 01
run 100
force -freeze SA 1
force -freeze FullCMP 10
force -freeze AMan 10000000100001111101011100
run 100
force -freeze FullCMP 11
force -freeze AMan 10110000100001111101011100
run 100
force -freeze SA 0
force -freeze SB 1
run 100
#no possible case bcs of shift block 
force -freeze FullCMP 01
run 100
