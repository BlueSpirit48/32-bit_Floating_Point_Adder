#Floating Point Adder
vsim -gui work.fpadder
add wave -position insertpoint  \
sim:/fpadder/clk \
sim:/fpadder/rst \
sim:/fpadder/start \
sim:/fpadder/numA \
sim:/fpadder/numB \
sim:/fpadder/flag \
sim:/fpadder/regs_control \
sim:/fpadder/sum \
sim:/fpadder/sc_bit_out \
sim:/fpadder/sc_bit_in \
sim:/fpadder/not_sc_bit \
sim:/fpadder/spec_num \
sim:/fpadder/cmp_out \
sim:/fpadder/cmp_in \
sim:/fpadder/expOUT \
sim:/fpadder/shift_out \
sim:/fpadder/shift_in \
sim:/fpadder/outManA \
sim:/fpadder/outManB \
sim:/fpadder/Sout \
sim:/fpadder/SumMan \
sim:/fpadder/cout_out \
sim:/fpadder/cout_in \
sim:/fpadder/outExp \
sim:/fpadder/outMan \
sim:/fpadder/Rovf_out \
sim:/fpadder/Inf_out \
sim:/fpadder/Undf_out \
sim:/fpadder/Rovf_in \
sim:/fpadder/Inf_in \
sim:/fpadder/Undf_in
force -freeze sim:/fpadder/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/fpadder/rst 1 0
force -freeze sim:/fpadder/start 1 0
force -freeze sim:/fpadder/numA 01000100011110110110101011100001 0
force -freeze sim:/fpadder/numB 01000100111110100110000011000001 0
run 100
force -freeze sim:/fpadder/rst 0 0

