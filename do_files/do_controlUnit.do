#control unit test
vsim -gui work.control_unit(control_unit_arch)
add wave sim://*
force clk 0 0, 1 {50 ps} -r 100
force rst 1 
force start 1 
force spec_case 1                         
force rovf 0                               
force inc_dec_inf 0                        
force inc_dec_unf 0
run 25 
force rst 0
run 75
run 300
force spec_case 0
run 300
force start 0
run 200 
force spec_case 1
force start 1
run 400