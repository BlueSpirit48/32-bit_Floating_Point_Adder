#do file for the exponent compare block:
vsim -gui work.exp_compare_block(exp_compare_block_arch)
add wave sim:/exp_compare_block/*
force -freeze sim:/exp_compare_block/en 1 0
force -freeze sim:/exp_compare_block/expA 10001000 0
force -freeze sim:/exp_compare_block/manA_in 11110110110101011100001 0
force -freeze sim:/exp_compare_block/expB 10001001 0
force -freeze sim:/exp_compare_block/manB_in 11110100110000011000001 0
run 100 ps
force -freeze sim:/exp_compare_block/en 1 0
force -freeze sim:/exp_compare_block/expA 01111111 0
force -freeze sim:/exp_compare_block/manA_in 01011000010100011110110 0
force -freeze sim:/exp_compare_block/expB 01111111 0
force -freeze sim:/exp_compare_block/manB_in 01011000010100011110110 0
run 100 ps
force -freeze sim:/exp_compare_block/en 1 0
force -freeze sim:/exp_compare_block/expA 10000100 0
force -freeze sim:/exp_compare_block/manA_in 10010000111110111110100 0
force -freeze sim:/exp_compare_block/expB 10000111 0
force -freeze sim:/exp_compare_block/manB_in 00101100011011101001100 0
run 100 ps
force -freeze sim:/exp_compare_block/en 1 0
force -freeze sim:/exp_compare_block/expA 10000100 0
force -freeze sim:/exp_compare_block/manA_in 01101000001111010111000 0
force -freeze sim:/exp_compare_block/expB 10001000 0
force -freeze sim:/exp_compare_block/manB_in 11110100000011110101110 0
run 100 ps
force -freeze sim:/exp_compare_block/en 1 0
force -freeze sim:/exp_compare_block/expA 10011111 0
force -freeze sim:/exp_compare_block/manA_in 01101000001100010111000 0
force -freeze sim:/exp_compare_block/expB 10001000 0
force -freeze sim:/exp_compare_block/manB_in 11110101110011110101110 0
run 100 ps
force -freeze sim:/exp_compare_block/en 0 0
force -freeze sim:/exp_compare_block/expA 10001000 0
force -freeze sim:/exp_compare_block/manA_in 11110110110101011100001 0
force -freeze sim:/exp_compare_block/expB 10001001 0
force -freeze sim:/exp_compare_block/manB_in 11110100110000011000001 0
run 100 ps

