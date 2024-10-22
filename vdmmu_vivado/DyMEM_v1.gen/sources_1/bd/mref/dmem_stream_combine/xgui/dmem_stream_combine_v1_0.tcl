# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDR_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AP_WINDOW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BENES_PORTS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BUS_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MEM_PORTS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MEM_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OFFSET" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TRANSLATORS" -parent ${Page_0}


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

proc update_PARAM_VALUE.BUS_W { PARAM_VALUE.BUS_W } {
	# Procedure called to update BUS_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BUS_W { PARAM_VALUE.BUS_W } {
	# Procedure called to validate BUS_W
	return true
}

proc update_PARAM_VALUE.DATA_W { PARAM_VALUE.DATA_W } {
	# Procedure called to update DATA_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_W { PARAM_VALUE.DATA_W } {
	# Procedure called to validate DATA_W
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

proc update_PARAM_VALUE.TRANSLATORS { PARAM_VALUE.TRANSLATORS } {
	# Procedure called to update TRANSLATORS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRANSLATORS { PARAM_VALUE.TRANSLATORS } {
	# Procedure called to validate TRANSLATORS
	return true
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

proc update_MODELPARAM_VALUE.BUS_W { MODELPARAM_VALUE.BUS_W PARAM_VALUE.BUS_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BUS_W}] ${MODELPARAM_VALUE.BUS_W}
}

proc update_MODELPARAM_VALUE.ADDR_W { MODELPARAM_VALUE.ADDR_W PARAM_VALUE.ADDR_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_W}] ${MODELPARAM_VALUE.ADDR_W}
}

