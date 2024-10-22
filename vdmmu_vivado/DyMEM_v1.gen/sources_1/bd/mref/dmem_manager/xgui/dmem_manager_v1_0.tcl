# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDR_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AP_WINDOW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BENES_PORTS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BRAM_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BUFFER_RD" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BUFFER_TRANS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BUFFER_WR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MEM_CTRL" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MEM_PORTS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MEM_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OFFSET" -parent ${Page_0}
  ipgui::add_param $IPINST -name "REQ_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TEST_EN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TRANSLATORS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TRANS_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "UNIT_BYTES" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDR_W { PARAM_VALUE.ADDR_W } {
	# Procedure called to update ADDR_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_W { PARAM_VALUE.ADDR_W } {
	# Procedure called to validate ADDR_W
	return true
}

proc update_PARAM_VALUE.AP_WINDOW { PARAM_VALUE.AP_WINDOW } {
	# Procedure called to update AP_WINDOW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AP_WINDOW { PARAM_VALUE.AP_WINDOW } {
	# Procedure called to validate AP_WINDOW
	return true
}

proc update_PARAM_VALUE.BENES_PORTS { PARAM_VALUE.BENES_PORTS } {
	# Procedure called to update BENES_PORTS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BENES_PORTS { PARAM_VALUE.BENES_PORTS } {
	# Procedure called to validate BENES_PORTS
	return true
}

proc update_PARAM_VALUE.BRAM_SIZE { PARAM_VALUE.BRAM_SIZE } {
	# Procedure called to update BRAM_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BRAM_SIZE { PARAM_VALUE.BRAM_SIZE } {
	# Procedure called to validate BRAM_SIZE
	return true
}

proc update_PARAM_VALUE.BUFFER_RD { PARAM_VALUE.BUFFER_RD } {
	# Procedure called to update BUFFER_RD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BUFFER_RD { PARAM_VALUE.BUFFER_RD } {
	# Procedure called to validate BUFFER_RD
	return true
}

proc update_PARAM_VALUE.BUFFER_TRANS { PARAM_VALUE.BUFFER_TRANS } {
	# Procedure called to update BUFFER_TRANS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BUFFER_TRANS { PARAM_VALUE.BUFFER_TRANS } {
	# Procedure called to validate BUFFER_TRANS
	return true
}

proc update_PARAM_VALUE.BUFFER_WR { PARAM_VALUE.BUFFER_WR } {
	# Procedure called to update BUFFER_WR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BUFFER_WR { PARAM_VALUE.BUFFER_WR } {
	# Procedure called to validate BUFFER_WR
	return true
}

proc update_PARAM_VALUE.DATA_W { PARAM_VALUE.DATA_W } {
	# Procedure called to update DATA_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_W { PARAM_VALUE.DATA_W } {
	# Procedure called to validate DATA_W
	return true
}

proc update_PARAM_VALUE.MEM_CTRL { PARAM_VALUE.MEM_CTRL } {
	# Procedure called to update MEM_CTRL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_CTRL { PARAM_VALUE.MEM_CTRL } {
	# Procedure called to validate MEM_CTRL
	return true
}

proc update_PARAM_VALUE.MEM_PORTS { PARAM_VALUE.MEM_PORTS } {
	# Procedure called to update MEM_PORTS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_PORTS { PARAM_VALUE.MEM_PORTS } {
	# Procedure called to validate MEM_PORTS
	return true
}

proc update_PARAM_VALUE.MEM_W { PARAM_VALUE.MEM_W } {
	# Procedure called to update MEM_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_W { PARAM_VALUE.MEM_W } {
	# Procedure called to validate MEM_W
	return true
}

proc update_PARAM_VALUE.OFFSET { PARAM_VALUE.OFFSET } {
	# Procedure called to update OFFSET when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OFFSET { PARAM_VALUE.OFFSET } {
	# Procedure called to validate OFFSET
	return true
}

proc update_PARAM_VALUE.REQ_W { PARAM_VALUE.REQ_W } {
	# Procedure called to update REQ_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REQ_W { PARAM_VALUE.REQ_W } {
	# Procedure called to validate REQ_W
	return true
}

proc update_PARAM_VALUE.TEST_EN { PARAM_VALUE.TEST_EN } {
	# Procedure called to update TEST_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TEST_EN { PARAM_VALUE.TEST_EN } {
	# Procedure called to validate TEST_EN
	return true
}

proc update_PARAM_VALUE.TRANSLATORS { PARAM_VALUE.TRANSLATORS } {
	# Procedure called to update TRANSLATORS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRANSLATORS { PARAM_VALUE.TRANSLATORS } {
	# Procedure called to validate TRANSLATORS
	return true
}

proc update_PARAM_VALUE.TRANS_W { PARAM_VALUE.TRANS_W } {
	# Procedure called to update TRANS_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRANS_W { PARAM_VALUE.TRANS_W } {
	# Procedure called to validate TRANS_W
	return true
}

proc update_PARAM_VALUE.UNIT_BYTES { PARAM_VALUE.UNIT_BYTES } {
	# Procedure called to update UNIT_BYTES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UNIT_BYTES { PARAM_VALUE.UNIT_BYTES } {
	# Procedure called to validate UNIT_BYTES
	return true
}


proc update_MODELPARAM_VALUE.TEST_EN { MODELPARAM_VALUE.TEST_EN PARAM_VALUE.TEST_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TEST_EN}] ${MODELPARAM_VALUE.TEST_EN}
}

proc update_MODELPARAM_VALUE.BUFFER_WR { MODELPARAM_VALUE.BUFFER_WR PARAM_VALUE.BUFFER_WR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BUFFER_WR}] ${MODELPARAM_VALUE.BUFFER_WR}
}

proc update_MODELPARAM_VALUE.BUFFER_RD { MODELPARAM_VALUE.BUFFER_RD PARAM_VALUE.BUFFER_RD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BUFFER_RD}] ${MODELPARAM_VALUE.BUFFER_RD}
}

proc update_MODELPARAM_VALUE.BUFFER_TRANS { MODELPARAM_VALUE.BUFFER_TRANS PARAM_VALUE.BUFFER_TRANS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BUFFER_TRANS}] ${MODELPARAM_VALUE.BUFFER_TRANS}
}

proc update_MODELPARAM_VALUE.MEM_PORTS { MODELPARAM_VALUE.MEM_PORTS PARAM_VALUE.MEM_PORTS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_PORTS}] ${MODELPARAM_VALUE.MEM_PORTS}
}

proc update_MODELPARAM_VALUE.BENES_PORTS { MODELPARAM_VALUE.BENES_PORTS PARAM_VALUE.BENES_PORTS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BENES_PORTS}] ${MODELPARAM_VALUE.BENES_PORTS}
}

proc update_MODELPARAM_VALUE.AP_WINDOW { MODELPARAM_VALUE.AP_WINDOW PARAM_VALUE.AP_WINDOW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AP_WINDOW}] ${MODELPARAM_VALUE.AP_WINDOW}
}

proc update_MODELPARAM_VALUE.TRANSLATORS { MODELPARAM_VALUE.TRANSLATORS PARAM_VALUE.TRANSLATORS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRANSLATORS}] ${MODELPARAM_VALUE.TRANSLATORS}
}

proc update_MODELPARAM_VALUE.DATA_W { MODELPARAM_VALUE.DATA_W PARAM_VALUE.DATA_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_W}] ${MODELPARAM_VALUE.DATA_W}
}

proc update_MODELPARAM_VALUE.OFFSET { MODELPARAM_VALUE.OFFSET PARAM_VALUE.OFFSET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OFFSET}] ${MODELPARAM_VALUE.OFFSET}
}

proc update_MODELPARAM_VALUE.MEM_W { MODELPARAM_VALUE.MEM_W PARAM_VALUE.MEM_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_W}] ${MODELPARAM_VALUE.MEM_W}
}

proc update_MODELPARAM_VALUE.ADDR_W { MODELPARAM_VALUE.ADDR_W PARAM_VALUE.ADDR_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_W}] ${MODELPARAM_VALUE.ADDR_W}
}

proc update_MODELPARAM_VALUE.MEM_CTRL { MODELPARAM_VALUE.MEM_CTRL PARAM_VALUE.MEM_CTRL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_CTRL}] ${MODELPARAM_VALUE.MEM_CTRL}
}

proc update_MODELPARAM_VALUE.TRANS_W { MODELPARAM_VALUE.TRANS_W PARAM_VALUE.TRANS_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRANS_W}] ${MODELPARAM_VALUE.TRANS_W}
}

proc update_MODELPARAM_VALUE.UNIT_BYTES { MODELPARAM_VALUE.UNIT_BYTES PARAM_VALUE.UNIT_BYTES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UNIT_BYTES}] ${MODELPARAM_VALUE.UNIT_BYTES}
}

proc update_MODELPARAM_VALUE.REQ_W { MODELPARAM_VALUE.REQ_W PARAM_VALUE.REQ_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REQ_W}] ${MODELPARAM_VALUE.REQ_W}
}

proc update_MODELPARAM_VALUE.BRAM_SIZE { MODELPARAM_VALUE.BRAM_SIZE PARAM_VALUE.BRAM_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BRAM_SIZE}] ${MODELPARAM_VALUE.BRAM_SIZE}
}

