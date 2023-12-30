extends ScrollContainer
@onready var level_vars : LevelSystem = $/root/LevelSystem;
var row_scene : PackedScene = load("res://scenes/created_levels_row.tscn");

func _ready() -> void:
	var created_levels : Dictionary = read_JSON.get_dict(level_enum.CUSTOM_LEVELS_PATH);
	var keys : Array = [];
	for key in created_levels:
		keys.push_back(key);
	keys.sort();
	for key in keys:
		var row : Control = row_scene.instantiate();
		row.level = key;
		$VBoxContainer.add_child(row);
