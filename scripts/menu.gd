extends Control
@onready var level_vars : LevelVariables = $/root/LevelVariables;
var is_sidebar_open : bool = false;

func _ready() -> void:
	_change_sidebar_state(false, false);
	
func _change_sidebar_state(open: bool, animate: bool = true) -> void:
	var tween = get_tree().create_tween();
	tween.set_trans(Tween.TRANS_QUAD);
	var pos : Vector2 = Vector2($Sidebar.position.x, $Sidebar.position.y);
	if open:
		pos.x = $Sidebar.position.x - $Sidebar.size.x;
		is_sidebar_open = true;
	else:
		pos.x = $Sidebar.position.x + $Sidebar.size.x;
		is_sidebar_open = false;
	if animate:
		tween.tween_property($Sidebar, "position", pos, 0.5);
	else:
		$Sidebar.position = pos;
	
func _on_play_pressed() -> void:
	if !is_sidebar_open:
		_change_sidebar_state(true);

func _on_exit_pressed() -> void:
	get_tree().quit();
	
func _play() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn");
	
func _on_beginner_button_pressed() -> void:
	level_vars.initialize(1);
	_play();

func _on_intermediate_button_pressed() -> void:
	level_vars.initialize(11);
	_play();

func _on_hard_button_pressed() -> void:
	level_vars.initialize(21);
	_play();

func _on_expert_button_pressed() -> void:
	level_vars.initialize(31);
	_play();

func _on_custom_button_pressed() -> void:
	level_vars.initialize(41);
	_play();
