extends Node2D;

const LILYPADS_OFFSET : Vector2i = Vector2i(200, 100);
const DROP_SHORTEST_DIST = 75;

var frog_scene : PackedScene = preload("res://scenes/frog.tscn");
var lilypad_scene : PackedScene = preload("res://scenes/lilypad.tscn");
var lilypads : Array = [];

func _center_self() -> void:
	position = get_viewport_rect().size / 2;
	print_debug(position);
	

func _ready() -> void:
	_center_self();
	get_tree().get_root().connect("size_changed", _center_self);
	var layout : Dictionary = read_JSON.get_dict("res://levels/easy.json");
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
			frog.attached_lilypad = lilypad;
			frog.red = (val == lilypad_enum.STATUS.RED);
			lilypad.status = lilypad_enum.STATUS.RED if frog.red else lilypad_enum.STATUS.GREEN;
			frog.connect('drop_frog', _on_frog_drop);
			add_child(frog);

func _check_valid_move(frog: Frog, lilypad: Lilypad) -> bool:
	print_debug("check valid move", frog.position, lilypad.position)
	if lilypad.status != lilypad_enum.STATUS.EMPTY:
		return false;
	return true;
	
	
func _on_frog_drop(frog: Frog) -> void:
	for child in get_tree().get_nodes_in_group("lilypads"):
		var lilypad : Lilypad = child;
		var distance : float = frog.position.distance_to(lilypad.position);
		print_debug(distance, "dropping frog", frog.position, lilypad.position)
		# Drop to the closest lilypad		
		if distance < DROP_SHORTEST_DIST:
			if (!_check_valid_move(frog, lilypad)):
				break;
			frog.attached_lilypad.status = lilypad_enum.STATUS.EMPTY;			
			frog.attached_lilypad = lilypad;
			lilypad.status = lilypad_enum.STATUS.RED if frog.red else lilypad_enum.STATUS.GREEN;
			break;
	


func _process(delta: float) -> void:
	pass
