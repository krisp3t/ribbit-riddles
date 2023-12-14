extends Sprite2D
class_name Frog

var selected : bool = false;
@export var rest_point : Vector2;
@export var red : bool = false;
@export var coord : Vector2i;

signal drop_frog(Vector2i);


func _ready():
	add_to_group("frogs");
	if red:
		modulate = Color(1, 0.2, 0.2);

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Start dragging
	if Input.is_action_just_pressed("click"):
		if not selected:
			selected = true;
			modulate = Color(1, 1, 1, 0.5);
		else:
			selected = false;
			modulate = Color(1, 1, 1, 1);
			drop_frog.emit(self);


		
func _process(delta: float) -> void:
	if selected:
		# While dragging, follow cursor		
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta);
	else:
		# Animate back to rest_point
		position = lerp(position, rest_point, 10 * delta);
	
