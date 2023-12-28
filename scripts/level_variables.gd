extends Node

var current_level : int;
var info : Dictionary;
var background : Resource;
var next_background : Resource;

func initialize(level : int) -> void:
	current_level = level;
	info = level_enum.get_level_info(current_level);
	background = ResourceLoader.load_threaded_get(info["difficulty_bg"]);
	# If background thread failed to load bg, load normally
	if background == null:
		background = load(info["difficulty_bg"]);
	queue_next_bg();
	
func queue_next_bg() -> void:
	var next_info : Dictionary = level_enum.get_level_info(current_level + 1);
	ResourceLoader.load_threaded_request(next_info["difficulty_bg"]);
	
func _ready() -> void:
	var next_info : Dictionary = level_enum.get_level_info(1);
	ResourceLoader.load_threaded_request(next_info["difficulty_bg"]);
	initialize(1);
