#RoundBlock_Phase3
vsim -gui work.RoundBlock
#inputs
add wave inMan
#outputs
add wave outMan 
add wave Rovf
#mid_Signals
add wave mid_Man
add wave mid_RMan
add wave LGR
#----------------Test----------------------------#
force inMan 10000000100001111101011101
run 100
force inMan 10000000100001111101011110
run 100
force inMan 10000000100001111101011010
run 100
force inMan 10000000100001111101011111
run 100
force inMan 11111111111111111111111110
run 100