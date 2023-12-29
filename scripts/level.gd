extends Node2D;
@onready var level_vars : LevelVariables = $/root/LevelVariables;

var rng : RandomNumberGenerator = RandomNumberGenerator.new();
var is_muted : bool = false;

signal refresh;
signal mute;

func _initialize() -> void:
	var info : Dictionary = level_enum.get_level_info(level_vars.current_level);
	# Set up labels and textures
	$UI/CanvasLayer/LevelContainer/LevelLabel.text = "Level: %d" % level_vars.current_level;
	$UI/CanvasLayer/DifficultyLabel.text = "Difficulty: %s" % info["difficulty_name"];
	$UI/CanvasLayer/ParallaxBackground/Background.texture = level_vars.background;
	$UI/CanvasLayer/DifficultyProgressBar.texture = load(info["difficulty_progress_bar"]);
	# Set up muted / unmuted players
	is_muted = !level_vars.muted;
	_on_mute_button_pressed();
	# Is level already solved?
	$UI/CanvasLayer/NextLevelContainer/FinishWarning.visible = !info["solved"];
	$UI/CanvasLayer/NextLevelContainer/NextLevelButton.disabled = !info["solved"];
	if info["solved"]:
		$UI/CanvasLayer/LevelContainer/LevelSolved.texture = load("res://assets/buttons/4x/Asset 25@4x.png");
	# Min level boundary
	if level_vars.current_level == 1:
		$UI/CanvasLayer/PreviousLevelButton.disabled = true;
	# Max level boundary
	if level_vars.current_level == level_enum.MAX_EXPERT:
		$UI/CanvasLayer/NextLevelContainer/NextLevelButton.disabled = true;
		$UI/CanvasLayer/NextLevelContainer/FinishWarning.visible = false;

func _ready() -> void:
	_initialize();

func _on_restart_level_button_pressed() -> void:
	refresh.emit();
	
func save_game() -> void:
	if !(DirAccess.dir_exists_absolute("user://savegames")):
		var dir : DirAccess = DirAccess.open("user://");	
		dir.make_dir("savegames");
	var dict : Dictionary = level_vars["info"]["savegame"];
	dict[level_vars.current_level] = true;
	var json : String = JSON.stringify(dict);
	var file : FileAccess = FileAccess.open(level_vars["info"]["savegame_path"], FileAccess.WRITE);
	file.store_line(json);

func _on_playfield_solved() -> void:
	$WinPlayer.play();
	$UI/CanvasLayer/NextLevelContainer/NextLevelButton.disabled = false;
	$UI/CanvasLayer/NextLevelContainer/FinishWarning.visible = false;
	$UI/CanvasLayer/LevelContainer/LevelSolved.texture = preload("res://assets/buttons/4x/Asset 25@4x.png");
	
	if level_vars.current_level == level_enum.MAX_EXPERT:
		$UI/CanvasLayer/NextLevelContainer/NextLevelButton.disabled = true;
		$UI/CanvasLayer/Win/GameCompleteLabel.visible = true;
		$Playfield.visible = false;
	$UI/CanvasLayer/Win.visible = true;
	$UI/CanvasLayer/Win.scale = Vector2(0, 0);
	var tween = get_tree().create_tween();
	var pos : Vector2 = $UI/CanvasLayer/Win.position;
	$UI/CanvasLayer/Win.position += $UI/CanvasLayer/Win.size / 2;
	tween.set_parallel(true);
	tween.tween_property($UI/CanvasLayer/Win, "scale", Vector2(1, 1), 0.5);
	tween.tween_property($UI/CanvasLayer/Win, "position", pos, 0.5);
	save_game();
	
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
	$UI/CanvasLayer/MuteButton["theme_override_styles/normal"].texture = load(texture_path);
	$UI/CanvasLayer/MuteButton["theme_override_styles/hover"].texture = load(texture_path);
	$UI/CanvasLayer/MuteButton["theme_override_styles/pressed"].texture = load(texture_path);
	$UI/CanvasLayer/MuteButton["theme_override_styles/focus"].texture = load(texture_path);
	for player in get_tree().get_nodes_in_group("AudioStreamPlayers"):
		if (is_muted):
			player.set_volume_db(-999.0);
		else:
			player.set_volume_db(0.0);
	mute.emit(is_muted);
	level_vars.muted = is_muted;		


func _on_playfield_jump() -> void:
	$JumpPlayer.pitch_scale = rng.randf_range(0.7, 1.3);
	$JumpPlayer.play();
	pass # Replace with function body.
