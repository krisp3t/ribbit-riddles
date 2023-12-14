extends Node2D

var selected : bool = false;
var rest_point;
var rest_nodes = [];

func _ready():
	rest_nodes = get_tree().get_nodes_in_group("zone");
	rest_point = rest_nodes[0].global_position;
	rest_nodes[0].select();

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		selected = true;
		
func _process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta);
	else:
		global_position = lerp(global_position, rest_point, 10 * delta);
	


func _input(event):
	if event is InputEventMouseButton:
		# Left mouse lifted
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false;
			const SHORTEST_DIST = 75;
			for child in rest_nodes:
				var distance = global_position.distance_to(child.global_position);
				if distance < SHORTEST_DIST:
					child.select();
					rest_point = child.global_position;
