extends Node2D;
@onready var level_vars : LevelSystem = $/root/LevelSystem;

const LILYPADS_OFFSET : Vector2i = Vector2i(300, 145);
const DROP_SHORTEST_DIST : int = 75;

var frog_scene : PackedScene = preload("res://scenes/frog.tscn");
var lilypad_scene : PackedScene = preload("res://scenes/lilypad.tscn");
var lilypads : Array = [];
var frogs_left : int = 0;
var is_solved : bool = false;
@export var is_editor : bool = false;

signal solved;
signal jump;

func initialize() -> void:
	_instantiate_lilypads();
	
func _ready() -> void:
	_animate_playfield();
	get_tree().root.connect("size_changed", _on_viewport_size_changed);
	initialize();
	_draw_lines_between_lilypads(lilypads);

	
func _animate_playfield() -> void:
	scale = Vector2(0, 0);
	position = get_viewport_rect().size / 2;
	var tween = get_tree().create_tween();
	tween.set_parallel(true);
	tween.set_trans(Tween.TRANS_QUAD);
	tween.tween_property($".", "scale", Vector2(1, 1), 0.5);
	tween.tween_property($".", "position", _get_center_position(), 0.5);

func _get_center_position() -> Vector2:
	var x : int = (get_viewport_rect().size.x - $PlayfieldBackground.size.x) / 2;
	var y : int = 125;
	return Vector2(x, y);
	
func _on_viewport_size_changed() -> void:
	position = _get_center_position();
	
func _draw_lines_between_lilypads(arr : Array) -> void:
	for x in arr:
		# Odd rows
		if len(x) % 2 != 0:
			var l : Line2D = Line2D.new();
			for lilypad: Lilypad in x:
				l.add_point(lilypad.position);
				# Connect upper and lower lilypad vertically
				if lilypad.coord.x % 4 == 2:
					var li: Line2D = Line2D.new();
					var c : Vector2i = lilypad.coord;
					var to_draw : Array = [lilypad.coord, Vector2i(c.x - 2, c.y), Vector2i(c.x + 2, c.y)];
					for t in to_draw:
						li.add_point(_get_lilypad(t).position);
					add_child(li);
			add_child(l);
		else:
			for lilypad: Lilypad in x:
				var c : Vector2i = lilypad.coord;
				var to_draw : Array = [Vector2i(c.x - 1, c.y - 1), Vector2i(c.x - 1, c.y + 1), Vector2i(c.x + 1, c.y - 1), Vector2i(c.x + 1, c.y + 1)];
				for t : Vector2i in to_draw:
					var l : Line2D = Line2D.new();
					l.add_point(lilypad.position);
					l.add_point(_get_lilypad(t).position);
					add_child(l);

func clear_playfield() -> void:
	level_vars["info"]["level_layout"] = [
		[0, 0, 0],
		[0, 0],
		[0, 0, 0],
		[0, 0],
		[0, 0, 0]
	];
	for lilypad : Lilypad in get_tree().get_nodes_in_group("lilypads"):
		var frog : Frog = lilypad.attached_frog;
		if (frog != null):
			frog.queue_free();
			lilypad.attached_frog = null;
		
	
	
func initialize_lilypad(ix: Vector2i, lilypad: Lilypad) -> void:
	var level_layout : Array = level_vars["info"]["level_layout"];
	var val : int = level_layout[ix.y][ix.x];
			
	if (ix.y % 2 == 0): # Rows with odd lilypads
		lilypad.coord = Vector2i(ix.y, ix.x * 2);
		lilypad.position = Vector2(200 + ix.x * LILYPADS_OFFSET.x, 150 + ix.y * LILYPADS_OFFSET.y);
	else: # Rows with even lilypads
		lilypad.coord = Vector2i(ix.y, ix.x * 2 + 1);
		# Centre the rows (have 1 lilypad less)				
		lilypad.position = Vector2(200 + ix.x * LILYPADS_OFFSET.x + (LILYPADS_OFFSET.x / 2.0), 150 + ix.y * LILYPADS_OFFSET.y);
	
	# Empty lilypads
	if (val == lilypad_enum.STATUS.EMPTY):
		var froge : Frog = lilypad.attached_frog;
		if (froge != null):
			froge.queue_free();
			lilypad.attached_frog = null;
		return;
	
	# Non-empty lilypads (have frogs)
	var frog : Node2D = frog_scene.instantiate();
	frog.attached_lilypad = lilypad;
	lilypad.attached_frog = frog;
	frog.position = lilypad.position;
	frog.red = (val == lilypad_enum.STATUS.RED);
	add_child(frog);
	frog.connect('drop_frog', _on_frog_drop);
	
func _instantiate_lilypads() -> void:
	var level_layout : Array = level_vars["info"]["level_layout"];
	frogs_left = 0;		
	for y in level_layout.size():
		lilypads.push_back([]);
		for x in level_layout[y].size():
			var val : int = level_layout[y][x];
			
			var lilypad : Node2D = lilypad_scene.instantiate();
			initialize_lilypad(Vector2i(x, y), lilypad);	
			add_child(lilypad);
			lilypads[y].push_back(lilypad);
			
			if (val != lilypad_enum.STATUS.EMPTY): 
				frogs_left += 1;

			
func _get_lilypad(coord: Vector2i) -> Lilypad:
	var y : int;
	if (coord.x % 2 == 0):
		y = floor(coord.y) / 2;
	else:
		y = floor(coord.y - 1) / 2;
	return lilypads[coord.x][y];
	
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
	return _get_lilypad(between);
	
func _check_valid_move(between: Lilypad, target: Lilypad) -> bool:
	if is_editor:
		return (target.attached_frog == null);
	
	if (target.attached_frog != null || between == null):
		return false;
	if (between.attached_frog == null || between.attached_frog.red == true):
		return false;		
	return true;

func _check_level_solved() -> bool:
	return frogs_left == 1;
	
func _on_frog_drop(frog: Frog) -> void:
	for lilypad : Lilypad in get_tree().get_nodes_in_group("lilypads"):
		var distance : float = frog.position.distance_to(lilypad.position);
		
		if distance >= DROP_SHORTEST_DIST:
			continue;
		
		# Drop to the lilypad close enough
		var start : Vector2i = frog.attached_lilypad.coord;
		var target : Vector2i = lilypad.coord;
		var between : Lilypad = _get_between_lilypad(start, target);
		if (!_check_valid_move(between, _get_lilypad(target))):
			break;
		
		
		# Jump over frog
		if !is_editor:
			frogs_left -= 1;
			between.attached_frog.queue_free();
			between.attached_frog = null;
		if is_editor:
			level_vars.update_level_layout(frog.attached_lilypad.coord, lilypad_enum.STATUS.EMPTY);
			level_vars.update_level_layout(lilypad.coord, lilypad_enum.STATUS.RED if frog.red else lilypad_enum.STATUS.GREEN);
			
		frog.attached_lilypad.attached_frog = null;
		frog.attached_lilypad = lilypad;
		lilypad.attached_frog = frog;
		
		jump.emit();
		break;
	
	if _check_level_solved():
		if (!is_solved):
			solved.emit();
			is_solved = true;
	


