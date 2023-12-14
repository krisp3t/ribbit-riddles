extends Node2D

const LILYPADS_OFFSET : Vector2i = Vector2i(200, 100);

var frog_scene : PackedScene = preload("res://scenes/frog.tscn");
var lilypad_scene : PackedScene = preload("res://scenes/lilypad.tscn");
var lilypads : Array = [];

func read_JSON(json_file_path: String) -> Dictionary:
	var file : FileAccess = FileAccess.open(json_file_path, FileAccess.READ);
	var content : String = file.get_as_text();
	return JSON.new().parse_string(content);
	

func _ready() -> void:
	var layout : Dictionary = read_JSON("res://levels/easy.json");
	# TODO: get current level instead of hardcode	
	var level_layout : Array = layout["1"];
	
	for y in level_layout.size():
		for x in level_layout[y].size():
			var val : int = level_layout[y][x];
			
			# Instantiate lilypads
			var lilypad : Node2D = lilypad_scene.instantiate();
			if (y % 2 == 0):
				lilypad.position = Vector2i(x * LILYPADS_OFFSET.x, y * LILYPADS_OFFSET.y);
			else:
				# Centre the rows with even numbers of lilypads (have 1 lilypad less)
				lilypad.position = Vector2i(x * LILYPADS_OFFSET.x + (LILYPADS_OFFSET.x / 2), y * LILYPADS_OFFSET.y);
			add_child(lilypad);
			if (val == 0): 
				continue;
			
			# Instantiate frogs
			var frog : Node2D = frog_scene.instantiate();
			frog.red = (val == 2);
			frog.rest_point = lilypad.global_position;
			add_child(frog);
			


func _process(delta: float) -> void:
	pass
