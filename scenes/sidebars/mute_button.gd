extends Button
@onready var config: Config = $ / root / ConfigSystem;
@onready var is_muted: bool = config.load_value("audio", "muted", false);

func _ready() -> void:
	toggle_mute(is_muted);

func toggle_mute(mute: bool) -> void:
	Logger.info("Global mute=%s" % mute);
	is_muted = mute;
	config.save_value("audio", "muted", mute);
	var texture_path: String;
	if mute:
		texture_path = "res://assets/buttons/4x/Asset 11@4x.png";
	else:
		texture_path = "res://assets/buttons/4x/Asset 12@4x.png";
	self["theme_override_styles/normal"].texture = load(texture_path);
	self["theme_override_styles/hover"].texture = load(texture_path);
	self["theme_override_styles/pressed"].texture = load(texture_path);
	self["theme_override_styles/focus"].texture = load(texture_path);
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), mute);

func _on_pressed() -> void:
	toggle_mute(!is_muted);
