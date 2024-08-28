extends Control
@onready var level_vars: LevelSystem = $ / root / LevelSystem;
@onready var config: Config = $ / root / ConfigSystem;

func _play() -> void:
	if (!config.load_value('tutorial', 'level', true)):
		get_tree().change_scene_to_file("res://scenes/level.tscn");
	else:
		get_tree().change_scene_to_file("res://scenes/tutorial_level.tscn");
	
func _ready() -> void:
	%IntermediateButton.disabled = !level_vars.is_completed_difficulty(level_const.DIFFICULTY.EASY);
	%IntermediateLabel.visible = %IntermediateButton.disabled;
	%HardButton.disabled = !level_vars.is_completed_difficulty(level_const.DIFFICULTY.INTERMEDIATE);
	%HardLabel.visible = %HardButton.disabled;
	%ExpertButton.disabled = !level_vars.is_completed_difficulty(level_const.DIFFICULTY.HARD);
	%ExpertLabel.visible = %ExpertButton.disabled;
	%CustomButton.disabled = !level_vars.is_completed_difficulty(level_const.DIFFICULTY.CUSTOM);
	%CustomLabel.visible = %CustomButton.disabled;

func _on_beginner_button_pressed() -> void:
	level_vars.initialize(level_vars.get_max_completed_level(level_const.DIFFICULTY.EASY));
	_play();

func _on_intermediate_button_pressed() -> void:
	level_vars.initialize(level_vars.get_max_completed_level(level_const.DIFFICULTY.INTERMEDIATE));
	_play();

func _on_hard_button_pressed() -> void:
	level_vars.initialize(level_vars.get_max_completed_level(level_const.DIFFICULTY.HARD));
	_play();

func _on_expert_button_pressed() -> void:
	level_vars.initialize(level_vars.get_max_completed_level(level_const.DIFFICULTY.EXPERT));
	_play();

func _on_custom_button_pressed() -> void:
	level_vars.initialize(level_vars.get_max_completed_level(level_const.DIFFICULTY.CUSTOM));
	_play();
