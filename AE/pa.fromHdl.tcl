
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name AE -dir "D:/GitHub/AE-XILLYBUS/AE/planAhead_run_1" -part xc6slx45tcsg324-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property verify_dir { {D:/GitHub/AE-XILLYBUS/AE/src} } $srcset
set_property target_constrs_file "D:/GitHub/AE-XILLYBUS/AE/src/xilinx_pcie_1_lane_ep_xc6slx45t-csg324-3.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {ipcore_dir/pcie/source/pcie_bram_s6.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/pcie/source/pcie_brams_s6.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/pcie/source/gtpa1_dual_wrapper_tile.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/pcie/source/pcie_bram_top_s6.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/pcie/source/gtpa1_dual_wrapper.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/pcie/source/pcie.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {src/xillybus_core.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {src/xillybus.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/s6_fifo.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/s6_clock.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {src/ae_top.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/s6_clock/example_design/s6_clock_exdes.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top ae_inst $srcset
add_files [list {D:/GitHub/AE-XILLYBUS/AE/src/xilinx_pcie_1_lane_ep_xc6slx45t-csg324-3.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/s6_fifo.ncf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx45tcsg324-3
