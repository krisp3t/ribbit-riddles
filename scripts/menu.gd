extends Control
@onready var level_vars : LevelVariables = $/root/LevelVariables;

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn");

func _on_exit_pressed() -> void:
	get_tree().quit();
	
func _on_beginner_button_pressed() -> void:
	level_vars.initialize(1);
	_on_play_pressed();

func _on_intermediate_button_pressed() -> void:
	level_vars.initialize(11);
	_on_play_pressed();

func _on_hard_button_pressed() -> void:
	level_vars.initialize(21);
	_on_play_pressed();

func _on_expert_button_pressed() -> void:
	level_vars.initialize(31);
	_on_play_pressed();

func _on_custom_button_pressed() -> void:
	level_vars.initialize(41);
	_on_play_pressed();
