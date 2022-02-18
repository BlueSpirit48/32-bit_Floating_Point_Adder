# input_register do_file
vsim -gui work.input_register

add wave clk
add wave rst
add wave wr_en
add wave opA
add wave opB
add wave SignA
add wave ExA
add wave ManA
add wave SignB
add wave ExB
add wave ManB

force -freeze clk 0 0, 1 {50} -r 100
force -freeze rst 1
force -freeze wr_en 1
force -freeze opA 10000111110100000000000000000000  
force -freeze opB 01100111110100000000000000000000
run 100
force -freeze rst 0
run 100
force -freeze opA 00000111110100000000000000000000
force -freeze wr_en 0
run 100
force -freeze wr_en 1
run 100
