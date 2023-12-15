extends Node2D;
@onready var level_vars = get_node("/root/LevelVariables");

const LILYPADS_OFFSET : Vector2i = Vector2i(200, 100);
const DROP_SHORTEST_DIST = 75;

var frog_scene : PackedScene = preload("res://scenes/frog.tscn");
var lilypad_scene : PackedScene = preload("res://scenes/lilypad.tscn");
var lilypads : Dictionary = {};
var frogs_left : int = 0;

signal solved;

func _center_self() -> void:
	position = get_viewport_rect().size / 2;
	print_debug(position);
	

func _ready() -> void:
	_center_self();
	get_tree().get_root().connect("size_changed", _center_self);
	var layout : Dictionary = read_JSON.get_dict("res://levels/easy.json");
	var level_layout : Array = layout[str(level_vars.current_level)];
	
	for y in level_layout.size():
		for x in level_layout[y].size():
			var val : int = level_layout[y][x];
			
			# Instantiate lilypads
			var lilypad : Node2D = lilypad_scene.instantiate();
			if (y % 2 == 0):
				lilypad.coord = Vector2i(y, x * 2);
				lilypad.position = Vector2i((x - 1) * LILYPADS_OFFSET.x, (y - 1) * LILYPADS_OFFSET.y);
			else:
				lilypad.coord = Vector2i(y, x * 2 + 1);
				# Centre the rows with even numbers of lilypads (have 1 lilypad less)				
				lilypad.position = Vector2i((x - 1) * LILYPADS_OFFSET.x + (LILYPADS_OFFSET.x / 2), (y - 1) * LILYPADS_OFFSET.y);
			add_child(lilypad);
			lilypads[lilypad.coord] = lilypad;
			if (val == lilypad_enum.STATUS.EMPTY): 
				continue;
			
			# Instantiate frogs on the lilypads
			var frog : Node2D = frog_scene.instantiate();
			frog.attached_lilypad = lilypad;
			lilypad.attached_frog = frog;
			frog.position = lilypad.position;
			frog.red = (val == lilypad_enum.STATUS.RED);
			frog.connect('drop_frog', _on_frog_drop);
			add_child(frog);
			frogs_left += 1;

func _get_between_lilypad(start: Vector2i, target: Vector2i) -> Lilypad:
	var between : Vector2i;
	# Horizontal move
	if (start.x == target.x and abs(start.y - target.y) == 4):
		between = Vector2i(start.x, abs(start.y - target.y) / 2);
	# Vertical move
	elif (start.y == target.y and abs(start.x - target.x) == 4):
		between = Vector2i(abs(start.x - target.x) / 2, start.y);
	# Diagonal move
	elif (abs(start.x - target.x) == 2 and abs(start.y - target.y) == 2):
		between = Vector2i(min(start.x, target.x) + 1, min(start.y, target.y) + 1);
	else:
		return null;
	return lilypads[between];
	
func _check_valid_move(start: Lilypad, between: Lilypad, target: Lilypad) -> bool:
	if (target.attached_frog != null || between == null):
		return false;
	if (between.attached_frog == null || between.attached_frog.red == true):
		return false;		
	return true;

func _check_level_solved() -> bool:
	return frogs_left == 1;
	
	
func _on_frog_drop(frog: Frog) -> void:
	for child in get_tree().get_nodes_in_group("lilypads"):
		var lilypad : Lilypad = child;
		var distance : float = frog.position.distance_to(lilypad.position);
		
		if distance >= DROP_SHORTEST_DIST:
			continue;
		
		# Drop to the lilypad close enough
		var start : Vector2i = frog.attached_lilypad.coord;
		var target : Vector2i = lilypad.coord;
		var between : Lilypad = _get_between_lilypad(start, target);
		if (!_check_valid_move(lilypads[start], between, lilypads[target])):
			break;
			
		# Jump over frog
		frogs_left -= 1;
		between.attached_frog.queue_free();
		between.attached_frog = null;
		frog.attached_lilypad.attached_frog = null;
		frog.attached_lilypad = lilypad;
		lilypad.attached_frog = frog;
		break;
	
	if _check_level_solved():
		print_debug("win");
		solved.emit();
	


func _process(delta: float) -> void:
	pass
