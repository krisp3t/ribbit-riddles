extends Control

@onready var level : LevelSystem = $/root/LevelSystem;
@onready var config : Config = $/root/ConfigSystem;
var step : int = 1;

func _ready() -> void:
	step = 1;
	_animate_tutorial();

func _animate_tutorial() -> void:
	%TutorialContainer.scale = Vector2(0, 0);
	%TutorialContainer.position = get_viewport_rect().size / 2;
	var tween = get_tree().create_tween();
	tween.set_parallel(true);
	tween.set_trans(Tween.TRANS_QUAD);
	tween.tween_property(%TutorialContainer, "scale", Vector2(1, 1), 0.5);
	tween.tween_property(%TutorialContainer, "position", Vector2(400, 76), 0.5);

func _update_step() -> void:
	match step:
		1:
			%PreviousStepButton.disabled = true;
			%FrogGreen.visible = true;
			%FrogGreen2.visible = true;
			%FrogRed.visible = true;
			%FrogRed.position = Vector2(985, 385);
			%ImageDisplay.texture = preload("res://assets/tutorial/tutorial_1.jpg");
			%Instructions.text = "Jump with            or\nover";
		2:
			%PreviousStepButton.disabled = false;
			%FrogGreen.visible = false;
			%FrogGreen2.visible = false;
			%FrogRed.visible = false;
			%ImageDisplay.texture = preload("res://assets/tutorial/tutorial_2.jpg");
			%Instructions.text = "You can move vertically, horizontally or diagonally.\nMake sure the lilypad behind is empty though!";
		3:
			%PreviousStepButton.disabled = false;
			%FrogGreen.visible = false;
			%FrogGreen2.visible = false;
			%FrogRed.visible = true;
			%FrogRed.position = Vector2(695, 425);
			%ImageDisplay.texture = preload("res://assets/tutorial/tutorial_3.jpg");
			%Instructions.text = "To solve the level,\nonly           must remain. Have fun hopping!";
		_:
			config.save_value('tutorial', 'level', false);
			level.initialize(1);
			get_tree().change_scene_to_file("res://scenes/main.tscn");

func _on_next_step_button_pressed() -> void:
	step += 1;
	_update_step();


func _on_previous_step_button_pressed() -> void:
	step -= 1;
	_update_step();
	pass # Replace with function body.
