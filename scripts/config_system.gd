extends Node2D
class_name Config

const CONFIG_PATH: String = "user://config.cfg";
var config: ConfigFile = ConfigFile.new();
var load_response: Error = config.load(CONFIG_PATH);

func _ready() -> void:
	# If config doesn't exist, create it
	if load_response != 0:
		Logger.warn("%s doesn't exist, creating default" % CONFIG_PATH);
		config.set_value("audio", "bg", 100);
		config.set_value("audio", "sfx", 100);
		config.set_value("tutorial", "level", true);
		config.set_value("tutorial", "editor", true);
		config.set_value("audio", "muted", false);
		config.save(CONFIG_PATH);
	else:
		Logger.info(CONFIG_PATH + " successfully loaded!\n" + config.encode_to_text());

func save_value(section: String, key: String, value: Variant) -> void:
	Logger.info("Setting %s=%s" % [key, value]);
	config.set_value(section, key, value);
	config.save(CONFIG_PATH);

func load_value(section: String, key: String, default: Variant) -> Variant:
	return config.get_value(section, key, default);
