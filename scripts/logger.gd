class_name Logger;

static func info(msg: String) -> void:
	if !OS.is_debug_build():
		return;
	var fun_name = get_stack()[1]["function"];
	var file = get_stack()[1]["source"];
	var line = get_stack()[1]["line"];
	print_rich("[color=green][%s:%s (%s)] INFO: %s[/color]" % [file, line, fun_name, msg]);
