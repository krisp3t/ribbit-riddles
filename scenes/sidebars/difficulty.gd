extends Control
@onready var level_vars: LevelSystem = $ / root / LevelSystem;
@onready var config: Config = $ / root / ConfigSystem;

func _play() -> void:
	if (!config.load_value('tutorial', 'level', true)):
		get_tree().change_scene_to_file("res://scenes/main.tscn");
	else:
		get_tree().change_scene_to_file("res://scenes/tutorial_level.tscn");
	
func _ready() -> void:
	var beginner_completed = level_vars.get_completed_levels(level_const.DIFFICULTY.EASY);
	var intermediate_completed = level_vars.get_completed_levels(level_const.DIFFICULTY.INTERMEDIATE);
	var hard_completed = level_vars.get_completed_levels(level_const.DIFFICULTY.HARD);
	var expert_completed = level_vars.get_completed_levels(level_const.DIFFICULTY.EXPERT);

	%BeginnerLabel.text = "%d / %d solved" % [beginner_completed.x, beginner_completed.y];
	%IntermediateButton.disabled = !level_vars.is_completed_difficulty(level_const.DIFFICULTY.EASY);
	%IntermediateLabel.text = "%d / %d solved" % [intermediate_completed.x, intermediate_completed.y] if !%IntermediateButton.disabled else "Finish Frogspawn to unlock";
	%HardButton.disabled = !level_vars.is_completed_difficulty(level_const.DIFFICULTY.INTERMEDIATE);
	%HardLabel.text = "%d / %d solved" % [hard_completed.x, hard_completed.y] if !%HardButton.disabled else "Finish Tadpole to unlock";
	%ExpertButton.disabled = !level_vars.is_completed_difficulty(level_const.DIFFICULTY.HARD);
	%ExpertLabel.text = "%d / %d solved" % [expert_completed.x, expert_completed.y] if !%ExpertButton.disabled else "Finish Froglet to unlock";
	%CustomButton.disabled = !level_vars.is_completed_difficulty(level_const.DIFFICULTY.CUSTOM);

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
