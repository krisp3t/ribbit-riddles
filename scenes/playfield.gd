extends Node2D

const LILYPADS_OFFSET : Vector2i = Vector2i(200, 100);
const DROP_SHORTEST_DIST = 75;

var frog_scene : PackedScene = preload("res://scenes/frog.tscn");
var lilypad_scene : PackedScene = preload("res://scenes/lilypad.tscn");
var lilypads : Array = [];

func read_JSON(json_file_path: String) -> Dictionary:
	var file : FileAccess = FileAccess.open(json_file_path, FileAccess.READ);
	var content : String = file.get_as_text();
	return JSON.new().parse_string(content);

func center_self() -> void:
	position = get_viewport_rect().size / 2;
	print_debug(position);
	

func _ready() -> void:
	center_self();
	get_tree().get_root().connect("size_changed", center_self);
	var layout : Dictionary = read_JSON("res://levels/easy.json");
	# TODO: get current level instead of hardcode	
	var level_layout : Array = layout["1"];
	
	for y in level_layout.size():
		for x in level_layout[y].size():
			var val : int = level_layout[y][x];
			
			# Instantiate lilypads
			var lilypad : Node2D = lilypad_scene.instantiate();
			lilypad.coord = Vector2i(x, y);
			if (y % 2 == 0):
				lilypad.position = Vector2i((x - 1) * LILYPADS_OFFSET.x, (y - 1) * LILYPADS_OFFSET.y);
			else:
				# Centre the rows with even numbers of lilypads (have 1 lilypad less)
				lilypad.position = Vector2i((x - 1) * LILYPADS_OFFSET.x + (LILYPADS_OFFSET.x / 2), (y - 1) * LILYPADS_OFFSET.y);
			add_child(lilypad);
			if (val == lilypad_enum.STATUS.EMPTY): 
				continue;
			
			# Instantiate frogs on the lilypads
			var frog : Node2D = frog_scene.instantiate();
			frog.coord = Vector2i(x, y);
			frog.red = (val == lilypad_enum.STATUS.RED);
			lilypad.status = lilypad_enum.STATUS.RED if frog.red else lilypad_enum.STATUS.GREEN;
			frog.rest_point = lilypad.position;
			frog.connect('drop_frog', _on_frog_drop);
			add_child(frog);

func _on_frog_drop(frog: Frog) -> void:
	for child in get_tree().get_nodes_in_group("lilypads"):
		var lilypad : Lilypad = child;
		# Drop to the closest lilypad
		var distance : float = frog.position.distance_to(lilypad.position);
		print_debug(distance, frog.position, lilypad.position, lilypad.coord);
		if distance < DROP_SHORTEST_DIST:
			print_debug("frog dropping", lilypad.coord);
			frog.rest_point = lilypad.position;
			lilypad.status = lilypad_enum.STATUS.RED if frog.red else lilypad_enum.STATUS.GREEN;
			return;
	


func _process(delta: float) -> void:
	pass
