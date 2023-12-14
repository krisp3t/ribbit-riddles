extends Marker2D;
class_name Lilypad;

@export var coord: Vector2i;
@export var status: lilypad_enum.STATUS = lilypad_enum.STATUS.EMPTY;

func _ready():
	add_to_group("lilypads");
