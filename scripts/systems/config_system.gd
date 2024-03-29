extends Node2D
class_name Config

var config_path : String = "user://config.cfg";
var config : ConfigFile = ConfigFile.new();
var load_response : Error = config.load(config_path);

func _ready() -> void:
	# If config doesn't exist, create it
	if load_response != 0:
		config.set_value("audio", "bg", 100);
		config.set_value("audio", "sfx", 100);
		config.set_value("tutorial", "level", true);
		config.set_value("tutorial", "editor", true);
		config.save(config_path);

func save_value(section: String, key: String, value: Variant) -> void:
	config.set_value(section, key, value);
	config.save(config_path);

func load_value(section: String, key: String, default : Variant) -> Variant:
	return config.get_value(section, key, default);

