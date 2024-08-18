extends Sprite2D
class_name Frog

var selected : bool = false;
@export var red : bool = false;
@export var attached_lilypad : Lilypad = null;

signal drop_frog(frog: Frog);
signal hover_frog(frog: Frog);

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			modulate = Color(1, 1, 1, 1);
			selected = false;
			drop_frog.emit(self);
	
func _ready():
	add_to_group("frogs");
	if red:
		texture = preload("res://assets/frog_red.png");
		
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		selected = true;
		modulate = Color(1, 1, 1, 1);
	
func _process(delta: float) -> void:
	if selected:
		z_index = 100;
		# While dragging, follow cursor		
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta);
		hover_frog.emit(self);
	else:
		z_index = 10;
		# Animate back to current lilypad
		position = lerp(position, attached_lilypad.position, 10 * delta);
