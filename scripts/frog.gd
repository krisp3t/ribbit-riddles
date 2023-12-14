extends Sprite2D
class_name Frog

var selected : bool = false;
@export var red : bool = false;
@export var attached_lilypad : Lilypad = null;

signal drop_frog(Vector2i);


func _ready():
	add_to_group("frogs");
	if red:
		modulate = Color(1, 0.2, 0.2);

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Start dragging
	if event.is_action_pressed("click"):
		if not selected:
			selected = true;
			modulate = Color(1, 1, 1, 0.5);
		else:
			modulate = Color(1, 1, 1, 1);
			drop_frog.emit(self);
			selected = false;


		
func _process(delta: float) -> void:
	if selected:
		# While dragging, follow cursor		
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta);
	else:
		# Animate back to current lilypad
		position = lerp(position, attached_lilypad.position, 10 * delta);
	
