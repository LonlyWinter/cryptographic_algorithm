set proj_name des
set part_name xc7a200tfbg484-2
set proj_dir ./fpga_des


create_project $proj_name $proj_dir -part $part_name -force
add_files -fileset sources_1 ./1.DES/src
add_files -fileset sources_1 ./1.DES/bin/serial_uart.sv
add_files -fileset constrs_1 ./1.DES/bin/serial_uart.xdc
set_property top serial_uart [current_fileset]


synth_design
opt_design
place_design
route_design
write_bitstream -force ./1.DES/des.bit


open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
get_hw_device
set hw_device [lindex [get_hw_device] 0]
set_property PROGRAM.FILE {./1.DES/des.bit} $hw_device
refresh_hw_device $hw_device
program_hw_device $hw_device
close_hw_manager