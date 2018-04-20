vlib work
vmap work
vlog -work work \
     $env(XILINX)/verilog/src/glbl.v \
     -f board.f

vsim -voptargs="+acc" +notimingchecks +TESTNAME=sample_smoke_test0 -L work -L secureip \
     -L unisims_ver \
     work.board glbl

do wave.do

run -all

