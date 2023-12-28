extends Node2D
@onready var level : PackedScene = load("res://scenes/level.tscn");
@onready var level_vars : LevelVariables = $/root/LevelVariables;
@onready var l : Node2D;

func _ready() -> void:
	l = level.instantiate();
	add_child(l);
	l.connect("refresh", _on_level_refresh);
		
func _on_level_refresh() -> void:
	l.queue_free();
	l = level.instantiate();
	add_child(l);
	l.connect("refresh", _on_level_refresh);
