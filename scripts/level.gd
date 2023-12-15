extends Node2D;
@onready var level_vars = get_node("/root/LevelVariables");

func _initialize() -> void:
	var difficulty : level_enum.DIFFICULTY = level_enum.get_level_difficulty(level_vars.current_level)
	$UI/CanvasLayer/LevelLabel.text = "Level: %d" % level_vars.current_level;
	$UI/CanvasLayer/DifficultyLabel.text = "Difficulty: %s" % level_enum.get_difficulty_name(difficulty);
	
func _ready() -> void:
	_initialize();


func _on_restart_level_button_pressed() -> void:
	get_tree().reload_current_scene();


func _on_next_level_button_pressed() -> void:
	level_vars.current_level += 1;
	get_tree().reload_current_scene();
	
	
