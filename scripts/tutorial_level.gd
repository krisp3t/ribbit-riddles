extends Control

func _ready() -> void:
	_animate_tutorial();

func _animate_tutorial() -> void:
	%TutorialContainer.scale = Vector2(0, 0);
	%TutorialContainer.position = get_viewport_rect().size / 2;
	var tween = get_tree().create_tween();
	tween.set_parallel(true);
	tween.set_trans(Tween.TRANS_QUAD);
	tween.tween_property(%TutorialContainer, "scale", Vector2(1, 1), 0.3);
	tween.tween_property(%TutorialContainer, "position", Vector2(460, 190), 0.3);
