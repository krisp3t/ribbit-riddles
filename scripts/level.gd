extends Node2D;
@onready var level_vars : LevelVariables = $/root/LevelVariables;

func _initialize() -> void:
	var info : Dictionary = level_enum.get_level_info(level_vars.current_level);
	$UI/CanvasLayer/LevelContainer/LevelLabel.text = "Level: %d" % level_vars.current_level;
	$UI/CanvasLayer/DifficultyLabel.text = "Difficulty: %s" % info["difficulty_name"];
	$UI/CanvasLayer/ParallaxBackground/Background.texture = level_vars.background;
	$UI/CanvasLayer/DifficultyProgressBar.texture = load(info["difficulty_progress_bar"]);
	if level_vars.current_level == 1:
		$UI/CanvasLayer/PreviousLevelButton.disabled = true;

func _ready() -> void:
	_initialize();

func _on_restart_level_button_pressed() -> void:
	get_tree().reload_current_scene();
	
func save_game() -> void:
	var dict : Dictionary = level_vars["info"]["savegame"];
	dict[level_vars.current_level] = true;
	var json : String = JSON.stringify(dict);
	var file : FileAccess = FileAccess.open(level_vars["info"]["savegame_path"], FileAccess.WRITE);
	file.store_line(json);

func _on_playfield_solved() -> void:
	$UI/CanvasLayer/VBoxContainer/NextLevelButton.disabled = false;
	$UI/CanvasLayer/VBoxContainer/FinishWarning.visible = false;
	$UI/CanvasLayer/LevelContainer/LevelSolved.texture = preload("res://assets/buttons/4x/Asset 25@4x.png");
	save_game();
	
func _on_previous_level_button_pressed() -> void:
	level_vars.initialize(level_vars.current_level - 1);
	get_tree().reload_current_scene();
	
func _on_next_level_button_pressed() -> void:
	level_vars.initialize(level_vars.current_level + 1);
	get_tree().reload_current_scene();
	
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn");



