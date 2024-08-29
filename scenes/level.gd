extends Node2D;
@onready var level_vars: LevelSystem = $ / root / LevelSystem;
@onready var config: ConfigSystem = $ / root / ConfigSystem;

var rng: RandomNumberGenerator = RandomNumberGenerator.new();

signal refresh;

func _initialize() -> void:
	var info: Dictionary = level_vars["level_info"];
	Logger.info("Loading level %d" % level_vars.level_num);
	# TODO: add asserts
	# Set up labels and textures
	%LevelLabel.text = "Level: %d" % level_vars.level_num;
	var completed_levels: Vector2i = level_vars.get_completed_levels(level_vars["level_info"]["difficulty"]);
	%DifficultySolvedLabel.text = "%d / %d solved" % [completed_levels.x, completed_levels.y];
	%Background.texture = level_vars.background;
	if info["difficulty"] == level_const.DIFFICULTY.CUSTOM:
		%Difficulty.visible = false;
		%CreatedLevels.visible = true;
		%NextLevelButton.disabled = false;
		%FinishWarning.visible = false;
	else:
		%EditLevelButton.visible = false;
		%DifficultyLabel.text = "Difficulty: %s" % info["name"];
		%DifficultyProgressBar.texture = load(info["path_progress_bar"]);
		# If level is already solved, proceeding to next level is available
		%FinishWarning.visible = !info["solved"];
		%NextLevelButton.disabled = !info["solved"];
	if info["solved"]:
		%LevelSolved.texture = load("res://assets/buttons/4x/Asset 14@4x.png");
	# Min level boundary
	if level_vars.level_num == 1:
		%PreviousLevelButton.disabled = true;
	# Max level boundary
	if level_vars.level_num == level_vars.MAX_EXPERT:
		%NextLevelButton.disabled = true;
		%FinishWarning.visible = false;
	if level_vars["level_info"]["difficulty"] == level_const.DIFFICULTY.CUSTOM:
		if level_vars.level_num >= int(level_vars["level_info"]["all_levels"].keys().max()):
			%NextLevelButton.disabled = true;
			%FinishWarning.visible = false;
		if level_vars.level_num == level_vars.MAX_EXPERT + 1:
			%PreviousLevelButton.disabled = true;
	# Audio system
	%JumpPlayer.volume_db = audio_system.get_db(config.load_value("audio", "sfx", 100.0));
	%WinPlayer.volume_db = %JumpPlayer.volume_db;


func _ready() -> void:
	_initialize();
	
func _on_playfield_solved() -> void:
	%WinPlayer.play();
	%NextLevelButton.disabled = false;
	%UndoButton.disabled = true;
	%FinishWarning.visible = false;
	%LevelSolved.texture = preload("res://assets/buttons/4x/Asset 14@4x.png");
	if level_vars.level_num >= level_vars.MAX_EXPERT:
		%NextLevelButton.disabled = true;
		%GameCompleteLabel.visible = true;
		$Playfield.visible = false;
	%Win.visible = true;
	%Win.scale = Vector2(0, 0);
	var tween = get_tree().create_tween();
	var pos: Vector2 = %Win.position;
	%Win.position += %Win.size / 2;
	tween.set_parallel(true);
	tween.tween_property(%Win, "scale", Vector2(1, 1), 0.5);
	tween.tween_property(%Win, "position", pos, 0.5);
	level_vars.save_savegame();
	level_vars["level_info"]["solved"] = true;

func _change_level(level: int) -> void:
	level_vars.initialize(level);
	refresh.emit();

func _on_previous_level_button_pressed() -> void:
	_change_level(level_vars.level_num - 1);

func _on_next_level_button_pressed() -> void:
	_change_level(level_vars.level_num + 1);

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn");

func _on_restart_level_button_pressed() -> void:
	_change_level(level_vars.level_num);
	
func _on_playfield_jump() -> void:
	%UndoButton.disabled = len(%Playfield.moves) == 0;
	$JumpPlayer.pitch_scale = rng.randf_range(0.7, 1.3);
	$JumpPlayer.play();

func _on_edit_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/editor.tscn");

func _on_undo_button_pressed():
	%Playfield.undo_last();

func _on_playfield_undo():
	%UndoButton.disabled = len(%Playfield.moves) == 0;
	$JumpPlayer.pitch_scale = rng.randf_range(0.7, 1.3);
	$JumpPlayer.play();
