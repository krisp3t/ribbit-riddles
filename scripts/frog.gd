extends Sprite2D
class_name Frog

var selected : bool = false;
@export var rest_point : Vector2;
@export var red : bool = false;
@export var coord : Vector2i;

signal drop_frog(Vector2i);


func _ready():
	add_to_group("frogs");
	if (red):
		modulate = Color(1, 0.2, 0.2);
	# rest_nodes = get_tree().get_nodes_in_group("zone");
	# rest_point = rest_nodes[0].global_position;
	# rest_nodes[0].select();
	pass;

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Start dragging
	if Input.is_action_just_pressed("click"):
		if not selected:
			print_debug(get_instance_id(), "start dragging");
			selected = true;
			modulate = Color(1, 1, 1, 0.5);
		else:
			print_debug(get_instance_id(), "emit");			
			selected = false;
			modulate = Color(1, 1, 1, 1);
			drop_frog.emit(self);


		
func _process(delta: float) -> void:
	if selected:
		# While dragging, follow cursor		
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta);
	else:
		position = lerp(position, rest_point, 10 * delta);
	

func _input(event: InputEvent):
	if not selected:
		return;
		
	#if event is InputEventMouseButton:
		# Stop dragging
		#if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			#print_debug(get_instance_id(), "emit");
			#drop_frog.emit();
			#selected = false;
			#for child in rest_nodes:
				#var distance = global_position.distance_to(child.global_position);
				#if distance < SHORTEST_DIST:
					#child.select();
					#rest_point = child.global_position;
