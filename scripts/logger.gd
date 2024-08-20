class_name Logger;

static func _log(msg: String, type: String, color: String) -> void:
	if !OS.is_debug_build():
		return;
	var fun_name = get_stack()[2]["function"];
	var file = get_stack()[2]["source"];
	var line = get_stack()[2]["line"];
	print_rich("[color=%s][%s:%s (%s)] %s: %s[/color]" % [color, file, line, fun_name, type, msg]);

static func log(msg: String) -> void:
	_log(msg, "LOG", "white");
	
static func info(msg: String) -> void:
	_log(msg, "INFO", "green");
	
static func warn(msg: String) -> void:
	_log(msg, "WARN", "yellow");

static func err(msg: String) -> void:
	_log(msg, "ERROR", "red");
	push_error(msg);
