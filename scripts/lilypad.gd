extends Marker2D
@export var coord: Vector2i;

func _ready():
	add_to_group("lilypads");
