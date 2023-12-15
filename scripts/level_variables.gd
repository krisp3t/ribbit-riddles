extends Node

var current_level : int;
var difficulty : level_enum.DIFFICULTY;
var diff_layout : Dictionary;
var level_layout : Array;

func initialize(level : int = 1) -> void:
	current_level = level;
	difficulty = level_enum.get_level_difficulty(current_level);
	diff_layout = level_enum.get_level_layout_dict(difficulty);
	level_layout = diff_layout[str(current_level)];

func _ready() -> void:
	initialize();
