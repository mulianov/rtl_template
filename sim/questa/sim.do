coverage save -onexit report.ucdb;
add wave -position insertpoint sim:/$env(top_tb_module)/top_instance/*
vcd file wave_vsim.vcd
vcd add -r $env(top_tb_module)/top_instance/*
run -all
vcover report -details -html report.ucdb
