extends Control
@onready var level_vars: LevelSystem = $ / root / LevelSystem;
@onready var config: Config = $ / root / ConfigSystem;

var sidebar_is_open: bool = true;

func _ready() -> void:
	_toggle_sidebar(false, false);
	%SoundtrackPlayer.volume_db = audio_system.get_db(config.load_value("audio", "bg", 100.0));
	%Options.audio_bg_change.connect(_on_options_audio_bg_change);
	
func _on_options_audio_bg_change() -> void:
	Logger.log("Handling audio_bg_change");
	%SoundtrackPlayer.volume_db = audio_system.get_db(config.load_value("audio", "bg", 100.0));

func _toggle_sidebar(will_open: bool, animate: bool = true, node: Control = null) -> void:
	%Difficulty.visible = false;
	%Options.visible = false;
	%Credits.visible = false;
	if node:
		node.visible = true;
		%SidebarLabel.text = node.name;
	var sidebar: Control = %Sidebar;
	var pos: Vector2 = Vector2(sidebar.position.x, sidebar.position.y);
	if will_open and !sidebar_is_open:
		pos.x = sidebar.position.x - sidebar.size.x;
	elif !will_open and sidebar_is_open:
		pos.x = sidebar.position.x + sidebar.size.x;
	if animate:
		var tween: Tween = get_tree().create_tween();
		tween.set_trans(Tween.TRANS_QUAD);
		tween.tween_property(sidebar, "position", pos, 0.5);
	else:
		sidebar.position = pos;
	sidebar_is_open = will_open;

func _on_close_sidebar_button_pressed() -> void:
	_toggle_sidebar(false);
	
func _on_play_pressed() -> void:
	_toggle_sidebar(true, true, %Difficulty);

func _on_options_pressed() -> void:
	_toggle_sidebar(true, true, %Options);
		
func _on_credits_pressed() -> void:
	_toggle_sidebar(true, true, %Credits);
		
func _on_map_editor_pressed() -> void:
	level_vars.initialize(level_vars.MAX_EXPERT + 1);
	get_tree().change_scene_to_file("res://scenes/editor.tscn");
	
func _on_exit_pressed() -> void:
	get_tree().quit();

func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file("res://scenes/tutorial_level.tscn");
