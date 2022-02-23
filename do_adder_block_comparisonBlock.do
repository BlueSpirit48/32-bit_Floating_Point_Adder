#full Comparison Block
vsim -gui work.full_compare_block

add wave AMan
add wave BMan
add wave CMP
add wave FullCMP

force -freeze AMan 10000000100001111101011100
force -freeze BMan 10000000100001111101011100
force -freeze CMP 1
run 100
force -freeze BMan 11000000100001111101011100
force -freeze CMP 0
run 100
force -freeze CMP 1
run 100
force -freeze AMan 11100000100001111101011100
run 100