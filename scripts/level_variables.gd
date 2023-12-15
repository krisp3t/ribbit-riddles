extends Node

var current_level : int;
var difficulty : level_enum.DIFFICULTY;
var diff_layout : Dictionary;
var level_layout : Array;
var background : Resource;

func initialize(level : int) -> void:
	current_level = level;
	var new_difficulty : level_enum.DIFFICULTY = level_enum.get_level_difficulty(current_level);
	if (background == null or difficulty != new_difficulty):
		var bg_path : String = level_enum.get_difficulty_background(new_difficulty);
		background = load(bg_path);
	difficulty = new_difficulty;
	diff_layout = level_enum.get_level_layout_dict(difficulty);
	level_layout = diff_layout[str(current_level)];
	
	

func _ready() -> void:
	initialize(1);
