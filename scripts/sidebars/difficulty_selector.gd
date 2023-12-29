extends Control
@onready var level_vars : LevelSystem = $/root/LevelSystem;
@onready var config : Config = $/root/ConfigSystem;

func _play() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn");
	
func _ready() -> void:
	%IntermediateButton.disabled = !level_vars.is_completed_difficulty(level_enum.DIFFICULTY.EASY);
	%IntermediateLabel.visible = %IntermediateButton.disabled;
	%HardButton.disabled = !level_vars.is_completed_difficulty(level_enum.DIFFICULTY.INTERMEDIATE);
	%HardLabel.visible = %HardButton.disabled;
	%ExpertButton.disabled = !level_vars.is_completed_difficulty(level_enum.DIFFICULTY.HARD);
	%ExpertLabel.visible = %ExpertButton.disabled;
	%CustomButton.disabled = !level_vars.is_completed_difficulty(level_enum.DIFFICULTY.CUSTOM);
	%CustomLabel.visible = %CustomButton.disabled;


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
	for key: String in savegame:
		if (int(key) >= default_max):
			return default_max;
		if (int(key) >= max_solved):
			max_solved = int(key) + 1;
	return max_solved;
	
