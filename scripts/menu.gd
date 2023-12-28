extends Control
@onready var level_vars : LevelVariables = $/root/LevelVariables;
var is_sidebar_open : bool = false;
var is_options_open : bool = false;

func _ready() -> void:
	_change_sidebar_state($Sidebar, false, func(): is_sidebar_open = false, false);
	_change_sidebar_state($Options, false, func(): is_options_open = false, false);
	$Sidebar/DifficultyContainer/Intermediate/IntermediateButton.disabled = _get_max_completed_level(level_enum.DIFFICULTY.EASY) != level_enum.MAX_EASY;
	$Sidebar/DifficultyContainer/Hard/HardButton.disabled = _get_max_completed_level(level_enum.DIFFICULTY.INTERMEDIATE) != level_enum.MAX_INTERMEDIATE;
	$Sidebar/DifficultyContainer/Expert/ExpertButton.disabled = _get_max_completed_level(level_enum.DIFFICULTY.HARD) != level_enum.MAX_HARD;
	# TODO: disable if custom empty
	
func _change_sidebar_state(sidebar_node: Control, open: bool, callback: Callable, animate: bool = true) -> void:
	var tween = get_tree().create_tween();
	tween.set_trans(Tween.TRANS_QUAD);
	var pos : Vector2 = Vector2(sidebar_node.position.x, sidebar_node.position.y);
	if open:
		pos.x = sidebar_node.position.x - sidebar_node.size.x;
	else:
		pos.x = sidebar_node.position.x + sidebar_node.size.x;
	if animate:
		tween.tween_property(sidebar_node, "position", pos, 0.5);
	else:
		sidebar_node.position = pos;
	callback.call();
	
func _on_play_pressed() -> void:
	if is_options_open:
		_on_close_options_button_pressed();
	if !is_sidebar_open:
		_change_sidebar_state($Sidebar, true, func(): is_sidebar_open = true);

func _on_close_sidebar_button_pressed() -> void:
	_change_sidebar_state($Sidebar, false, func(): is_sidebar_open = false);
	
func _on_options_pressed() -> void:
	if is_sidebar_open:
		_on_close_sidebar_button_pressed();
	if !is_options_open:
		_change_sidebar_state($Options, true, func(): is_options_open = true);

func _on_close_options_button_pressed() -> void:
	_change_sidebar_state($Options, false, func(): is_options_open = false);
	

func _on_exit_pressed() -> void:
	get_tree().quit();
	
func _play() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn");
	
func _get_max_completed_level(difficulty: level_enum.DIFFICULTY) -> int:
	var savegame : Dictionary = {};
	var default_min : int;
	var default_max : int;
	match difficulty:
		level_enum.DIFFICULTY.EASY:
			savegame = level_enum.load_savegame(level_enum.EASY_SAVEGAME);
			default_min = 1;
			default_max = level_enum.MAX_EASY;
		level_enum.DIFFICULTY.INTERMEDIATE:
			savegame = level_enum.load_savegame(level_enum.INTERMEDIATE_SAVEGAME);
			default_min = level_enum.MAX_EASY + 1;
			default_max = level_enum.MAX_INTERMEDIATE;
		level_enum.DIFFICULTY.HARD:
			savegame = level_enum.load_savegame(level_enum.HARD_SAVEGAME);
			default_min = level_enum.MAX_INTERMEDIATE + 1;
			default_max = level_enum.MAX_HARD;
		level_enum.DIFFICULTY.EXPERT:
			savegame = level_enum.load_savegame(level_enum.EXPERT_SAVEGAME);
			default_min = level_enum.MAX_HARD + 1;
			default_max = level_enum.MAX_EXPERT;
		_:
			return level_enum.MAX_EXPERT + 1;
	if (savegame.size() == 0):
		return default_min;
		
	var max_solved: int = default_min;
	for key in savegame:
		if (int(key) >= default_max):
			return default_max;
		if (int(key) >= max_solved):
			max_solved = int(key) + 1;
	return max_solved;
	
	
func _on_beginner_button_pressed() -> void:
	level_vars.initialize(_get_max_completed_level(level_enum.DIFFICULTY.EASY));
	_play();

func _on_intermediate_button_pressed() -> void:
	level_vars.initialize(_get_max_completed_level(level_enum.DIFFICULTY.INTERMEDIATE));
	_play();

func _on_hard_button_pressed() -> void:
	level_vars.initialize(_get_max_completed_level(level_enum.DIFFICULTY.HARD));
	_play();

func _on_expert_button_pressed() -> void:
	level_vars.initialize(_get_max_completed_level(level_enum.DIFFICULTY.EXPERT));
	_play();

func _on_custom_button_pressed() -> void:
	level_vars.initialize(_get_max_completed_level(level_enum.DIFFICULTY.CUSTOM));
	_play();
	
func _on_soundtrack_h_slider_value_changed(value: float) -> void:
	$Options/OptionsContainer/Soundtrack/SoundtrackProgressBar.value = $Options/OptionsContainer/Soundtrack/SoundtrackHSlider.value;	

func _on_soundtrack_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		$Options/OptionsContainer/Soundtrack/SoundtrackProgressBar.value = $Options/OptionsContainer/Soundtrack/SoundtrackHSlider.value;	

func _on_sfxh_slider_value_changed(value: float) -> void:
	$Options/OptionsContainer/SFX/SFXProgressBar.value = $Options/OptionsContainer/SFX/SFXHSlider.value;	
	
func _on_sfxh_slider_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.








