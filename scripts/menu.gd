extends Control
@onready var level_vars : LevelSystem = $/root/LevelSystem;
@onready var config : Config = $/root/ConfigSystem;

var is_sidebar_open : bool = false;

func _ready() -> void:
	_change_sidebar_state(false, false);
	_close_all_sidebars();
	%SoundtrackPlayer.volume_db = audio_system.get_db(config.load_value("audio", "bg", 100.0));
	
func _on_options_audio_bg_change() -> void:
	%SoundtrackPlayer.volume_db = audio_system.get_db(config.load_value("audio", "bg", 100.0));

func _change_sidebar_state(open: bool, animate: bool = true) -> void:
	var sidebar_node : Control = $Sidebar;
	var pos : Vector2 = Vector2(sidebar_node.position.x, sidebar_node.position.y);
	if open:
		pos.x = sidebar_node.position.x - sidebar_node.size.x;
	else:
		pos.x = sidebar_node.position.x + sidebar_node.size.x;
	if animate:
		var tween : Tween = get_tree().create_tween();
		tween.set_trans(Tween.TRANS_QUAD);
		tween.tween_property(sidebar_node, "position", pos, 0.5);
	else:
		sidebar_node.position = pos;
	is_sidebar_open = open;
	
func _close_all_sidebars() -> void:
	%DifficultySelector.visible = false;
	%Options.visible = false;
	%Credits.visible = false;
	
func _on_play_pressed() -> void:
	_close_all_sidebars();
	%DifficultySelector.visible = true;
	%SidebarLabel.text = "Difficulty";
	if !is_sidebar_open:
		_change_sidebar_state(true);

func _on_close_sidebar_button_pressed() -> void:
	_change_sidebar_state(false);
	
func _on_options_pressed() -> void:
	_close_all_sidebars();
	%Options.visible = true;
	%SidebarLabel.text = "Options";
	if !is_sidebar_open:
		_change_sidebar_state(true);
		
func _on_map_editor_pressed() -> void:
	level_vars.initialize(level_enum.MAX_EXPERT + 1);
	get_tree().change_scene_to_file("res://scenes/editor.tscn");
	
func _on_credits_pressed() -> void:
	_close_all_sidebars();
	%Credits.visible = true;
	%SidebarLabel.text = "Credits";
	if !is_sidebar_open:
		_change_sidebar_state(true);
	
func _on_exit_pressed() -> void:
	get_tree().quit();

func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file("res://scenes/tutorial_level.tscn");
