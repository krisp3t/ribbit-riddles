extends Node

var current_level : int;
var difficulty : level_enum.DIFFICULTY;
var diff_layout : Dictionary;
var level_layout : Array;
var background : Resource;
var next_background : Resource;

func initialize(level : int) -> void:
	current_level = level;
	var new_difficulty : level_enum.DIFFICULTY = level_enum.get_level_difficulty(current_level);
	var bg_path : String = level_enum.get_difficulty_background(new_difficulty);
	background = ResourceLoader.load_threaded_get(bg_path);
	difficulty = new_difficulty;
	diff_layout = level_enum.get_level_layout_dict(difficulty);
	level_layout = diff_layout[str(current_level)];
	queue_next_bg();
	
func queue_next_bg() -> void:
	var next_difficulty : level_enum.DIFFICULTY = level_enum.get_level_difficulty(current_level + 1);
	var next_bg_path : String = level_enum.get_difficulty_background(next_difficulty);
	ResourceLoader.load_threaded_request(next_bg_path);
	
func _ready() -> void:
	ResourceLoader.load_threaded_request(level_enum.get_difficulty_background(level_enum.DIFFICULTY.EASY));
	initialize(1);
