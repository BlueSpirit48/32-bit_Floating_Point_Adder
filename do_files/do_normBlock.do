#do file for norm_rounding_block:
vsim -gui work.norm_round_block(norm_round_block_arch)
add wave sim://*
force exp_max 10001001
force sum_man 01110010011111101111101011
force cout 0
run 100
force exp_max 10000111
force sum_man 10101111010001110000101011
force cout 1
run 100
#rovf
force exp_max 10000111
force sum_man 01111111111111111111111111
force cout 0
run 100
#undf
force exp_max 00000011
force sum_man 00001111101100110111010100
force cout 0
run 100
#inf
force exp_max 11111110
force sum_man 00001111101100110111010100
force cout 1
run 100