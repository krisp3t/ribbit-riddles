extends Sprite2D
class_name Frog

var selected : bool = false;
@export var red : bool = false;
@export var attached_lilypad : Lilypad = null;

signal drop_frog(Vector2i);


func _ready():
	add_to_group("frogs");
	if red:
		texture = preload("res://assets/frog_red.png");

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
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
	
