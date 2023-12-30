extends Node2D;
@onready var level_vars : LevelSystem = $/root/LevelSystem;
@onready var config : ConfigSystem = $/root/ConfigSystem;

var rng : RandomNumberGenerator = RandomNumberGenerator.new();
var is_muted : bool = false;

signal refresh;
signal mute;

func _initialize() -> void:
	var info : Dictionary = level_vars["info"];
	# Set up labels and textures
	%LevelLabel.text = "Level: %d" % level_vars.current_level;
	%Background.texture = level_vars.background;
	if info["difficulty"] == level_enum.DIFFICULTY.CUSTOM:
		%Difficulty.visible = false;
	else:
		%EditLevelButton.visible = false;
		%DifficultyLabel.text = "Difficulty: %s" % info["difficulty_name"];	
		%DifficultyProgressBar.texture = load(info["difficulty_progress_bar"]);
	# Set up muted / unmuted audio players
	is_muted = !level_vars.muted;
	_on_mute_button_pressed();
	$JumpPlayer.volume_db = audio_system.get_db(config.load_value("audio", "sfx"));
	$WinPlayer.volume_db = $JumpPlayer.volume_db;
	# Is level already solved?
	%FinishWarning.visible = !info["solved"];
	%NextLevelButton.disabled = !info["solved"];
	if info["solved"]:
		%LevelSolved.texture = load("res://assets/buttons/4x/Asset 25@4x.png");
	# Min level boundary
	if level_vars.current_level == 1:
		%PreviousLevelButton.disabled = true;
	# Max level boundary
	if level_vars.current_level == level_enum.MAX_EXPERT:
		%NextLevelButton.disabled = true;
		%FinishWarning.visible = false;
	elif info["difficulty"] == level_enum.DIFFICULTY.CUSTOM:
		if level_vars.current_level == level_enum.MAX_EXPERT + info["difficulty_levels"].size():
			%NextLevelButton.disabled = true;
			%FinishWarning.visible = false;

func _ready() -> void:
	_initialize();

func _on_restart_level_button_pressed() -> void:
	refresh.emit();
	
func _on_playfield_solved() -> void:
	$WinPlayer.play();
	%NextLevelButton.disabled = false;
	%FinishWarning.visible = false;
	%LevelSolved.texture = preload("res://assets/buttons/4x/Asset 25@4x.png");
	
	if level_vars.current_level == level_enum.MAX_EXPERT:
		%NextLevelButton.disabled = true;
		%GameCompleteLabel.visible = true;
		$Playfield.visible = false;
	elif level_vars["info"]["difficulty"] == level_enum.DIFFICULTY.CUSTOM:
		if level_vars.current_level == level_enum.MAX_EXPERT + level_vars["info"]["difficulty_levels"].size():
			%NextLevelButton.disabled = true;
			%FinishWarning.visible = false;
	%Win.visible = true;
	%Win.scale = Vector2(0, 0);
	var tween = get_tree().create_tween();
	var pos : Vector2 = %Win.position;
	%Win.position += %Win.size / 2;
	tween.set_parallel(true);
	tween.tween_property(%Win, "scale", Vector2(1, 1), 0.5);
	tween.tween_property(%Win, "position", pos, 0.5);
	level_vars.save_savegame();
	
func _on_previous_level_button_pressed() -> void:
	level_vars.initialize(level_vars.current_level - 1);
	refresh.emit();
	
func _on_next_level_button_pressed() -> void:
	level_vars.initialize(level_vars.current_level + 1);
	refresh.emit();
	
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn");

func _on_mute_button_pressed() -> void:
	var texture_path : String;
	is_muted = !is_muted;
	if is_muted:
		texture_path = "res://assets/buttons/4x/Asset 11@4x.png";
	else:
		texture_path = "res://assets/buttons/4x/Asset 12@4x.png";
	%MuteButton["theme_override_styles/normal"].texture = load(texture_path);
	%MuteButton["theme_override_styles/hover"].texture = load(texture_path);
	%MuteButton["theme_override_styles/pressed"].texture = load(texture_path);
	%MuteButton["theme_override_styles/focus"].texture = load(texture_path);
	for player in get_tree().get_nodes_in_group("AudioStreamPlayers"):
		if (is_muted):
			player.set_volume_db(-999.0);
		else:
			player.set_volume_db(audio_system.get_db(config.load_value("audio", "sfx")));
	mute.emit(is_muted);
	level_vars.muted = is_muted;		


func _on_playfield_jump() -> void:
	$JumpPlayer.pitch_scale = rng.randf_range(0.7, 1.3);
	$JumpPlayer.play();

func _on_edit_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/editor.tscn");
