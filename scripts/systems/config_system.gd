extends Node2D
class_name Config

var config_path : String = "user://config.cfg";
var config : ConfigFile = ConfigFile.new();
var load_response : Error = config.load(config_path);

func _ready() -> void:
	if load_response != 0:
		config.set_value("audio", "bg", 100);
		config.set_value("audio", "sfx", 100);
		config.save(config_path);
	print_debug(load_response);

func save_value(section: String, key: String, value: Variant) -> void:
	config.set_value(section, key, value);
	config.save(config_path);

func load_value(section: String, key: String) -> Variant:
	return config.get_value(section, key);

