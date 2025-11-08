#do file for output_block:
vsim -gui work.output_block(output_block_arch)
add wave sim://*
force spec_num XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
force sout 0
force exp 10001010
force man 01111000000101100011001
force rovf 0
force inf 0
force unf 0
force en 0
run 100
force spec_num XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
force sout 0
force exp 11111111
force man 01011110100011100001010
force rovf 0
force inf 1
force unf 0
force en 0
run 100
force spec_num XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
force sout 1
force exp 00000000
force man 00000101010010011001101
force rovf 0
force inf 0
force unf 1
force en 0
run 100
force spec_num XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
force sout 1
force exp 00000001
force man 00000101010010011001101
force rovf 1
force inf 0
force unf 1
force en 0
run 100
force spec_num 11111111101010101011111111010100
force sout 1
force exp 10111111
force man 00000000010010011001101
force rovf 0
force inf 0
force unf 0
force en 1
run 100