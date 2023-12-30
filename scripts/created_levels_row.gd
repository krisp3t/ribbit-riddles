extends MarginContainer
@export var level : int = 41;
@onready var level_vars : LevelSystem = $/root/LevelSystem;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%LevelLabel.text = "Level %d" % level;

func _on_play_button_pressed() -> void:
	level_vars.initialize(level);
	get_tree().reload_current_scene();
