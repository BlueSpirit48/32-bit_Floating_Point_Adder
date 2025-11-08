#do file for the special case block:
vsim -gui work.special_case_block(special_case_block_arch)
add wave sim:/special_case_block/*
force -freeze sim:/special_case_block/sA 0 0
force -freeze sim:/special_case_block/expA 10001000 0
force -freeze sim:/special_case_block/manA 11110110110101011100001 0
force -freeze sim:/special_case_block/sB 0 0
force -freeze sim:/special_case_block/expB 10001001 0
force -freeze sim:/special_case_block/manB 11110100110000011000001 0
run 100 ps
force -freeze sim:/special_case_block/sA 0 0
force -freeze sim:/special_case_block/expA 01111111 0
force -freeze sim:/special_case_block/manA 01011000010100011110110 0
force -freeze sim:/special_case_block/sB 1 0
force -freeze sim:/special_case_block/expB 01111111 0
force -freeze sim:/special_case_block/manB 01011000010100011110110 0
run 100 ps
force -freeze sim:/special_case_block/sA 0 0
force -freeze sim:/special_case_block/expA 00000000 0
force -freeze sim:/special_case_block/manA 00000000000000000000000 0
force -freeze sim:/special_case_block/sB 1 0
force -freeze sim:/special_case_block/expB 10000010 0
force -freeze sim:/special_case_block/manB 01000000000000000000000 0
run 100 ps
force -freeze sim:/special_case_block/sA 1 0
force -freeze sim:/special_case_block/expA 11111111 0
force -freeze sim:/special_case_block/manA 01101000001111010111000 0
force -freeze sim:/special_case_block/sB 0 0
force -freeze sim:/special_case_block/expB 10000001 0
force -freeze sim:/special_case_block/manB 01000000000000000000000 0
run 100 ps
force -freeze sim:/special_case_block/sA 1 0
force -freeze sim:/special_case_block/expA 11111111 0
force -freeze sim:/special_case_block/manA 00000000000000000000000 0
force -freeze sim:/special_case_block/sB 0 0
force -freeze sim:/special_case_block/expB 10000001 0
force -freeze sim:/special_case_block/manB 01000000000000000000000 0
run 100 ps
