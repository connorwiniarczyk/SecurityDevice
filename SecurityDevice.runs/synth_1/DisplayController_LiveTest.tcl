# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/winiarcc/ECE/SecurityDevice/SecurityDevice.cache/wt [current_project]
set_property parent.project_path C:/Users/winiarcc/ECE/SecurityDevice/SecurityDevice.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:nexys4:part0:1.1 [current_project]
read_verilog -library xil_defaultlib -sv {
  C:/Users/winiarcc/ECE/SecurityDevice/DesignSources/sevenSegDec.sv
  C:/Users/winiarcc/ECE/SecurityDevice/DesignSources/DisplayController.sv
  C:/Users/winiarcc/ECE/SecurityDevice/DesignSources/UtiltyModules.sv
  C:/Users/winiarcc/ECE/SecurityDevice/LiveTests/DisplayController_LiveTest.sv
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/winiarcc/ECE/SecurityDevice/Constraints/Constraints.xdc
set_property used_in_implementation false [get_files C:/Users/winiarcc/ECE/SecurityDevice/Constraints/Constraints.xdc]


synth_design -top DisplayController_LiveTest -part xc7a100tcsg324-1


write_checkpoint -force -noxdef DisplayController_LiveTest.dcp

catch { report_utilization -file DisplayController_LiveTest_utilization_synth.rpt -pb DisplayController_LiveTest_utilization_synth.pb }
