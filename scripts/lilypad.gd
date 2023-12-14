extends Marker2D;
class_name Lilypad;

@export var coord: Vector2i;
@export var attached_frog : Frog = null;

func _ready():
	add_to_group("lilypads");
