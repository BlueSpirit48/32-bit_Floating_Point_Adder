#do file for addition_block:
vsim -gui work.addition_block(addition_block_arch)
add wave sim://*
force manA  11111011011010101110000100
force manB  11111010011000001100000100
force sA  0
force sB 0
force cmp 0                           
force shift 00001
run 100
force manA  11001000011111011111010000
force manB  10010110001101110100110000
force sA  0
force sB  0		
force cmp 0                           
force shift 00011
run 100;
force manA  10010110001101110100110000
force manB  10110100000111101011100000
force sA 0
force sB 1
force cmp 1                           
force shift 00011
run 100
force manA  10010110001111110100110000
force manB  11110100010111101011100000
force sA    1
force sB    1
force cmp   1                           
force shift 01011
run 100
force manA  10010110001111110100110000
force manB  11110100010111101011100000
force sA    1
force sB    0
force cmp   1                           
force shift 01011
run 100
