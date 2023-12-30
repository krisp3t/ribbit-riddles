extends Node2D;
@onready var level_vars : LevelSystem = $/root/LevelSystem;
@onready var config : ConfigSystem = $/root/ConfigSystem;

const CURSOR_OFFSET : Vector2 = Vector2(-60, -55);
const GREEN_INITIAL : Vector2 = Vector2(0, 40);
const RED_INITIAL : Vector2 = Vector2(120, 40);
const ERASER_INITIAL : Vector2 = Vector2(248, 56);
const DROP_SHORTEST_DIST : int = 75;

var rng : RandomNumberGenerator = RandomNumberGenerator.new();
var is_muted : bool = false;
var selected : Control = null;

signal refresh;
signal mute;

func _initialize() -> void:
	var info : Dictionary = level_enum.get_level_info(level_vars.current_level);
	# Set up labels and textures
	%LevelLabel.text = "Level: %d" % level_vars.current_level;
	%Background.texture = level_vars.background;
	# Set up muted / unmuted audio players
	is_muted = !level_vars.muted;
	_on_mute_button_pressed();
	$JumpPlayer.volume_db = audio_system.get_db(config.load_value("audio", "sfx"));
	$WinPlayer.volume_db = $JumpPlayer.volume_db;
	# Min level boundary
	if level_vars.current_level == level_enum.MAX_EXPERT + 1:
		%PreviousLevelButton.disabled = true;
	# Max level boundary
	# TODO: don't allow gaps
	if level_vars.current_level == level_enum.MAX_EXPERT:
		%NextLevelButton.disabled = true;
		%FinishWarning.visible = false;
	%SaveButton.text = "Save as Level %s" % level_vars.current_level;

func _ready() -> void:
	_initialize();

func _on_previous_level_button_pressed() -> void:
	level_vars.initialize(level_vars.current_level - 1);
	refresh.emit();
	
func _on_next_level_button_pressed() -> void:
	level_vars.initialize(level_vars.current_level + 1);
	refresh.emit();
	
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn");

func _on_mute_button_pressed() -> void:
	var texture_path : String;
	is_muted = !is_muted;
	if is_muted:
		texture_path = "res://assets/buttons/4x/Asset 11@4x.png";
	else:
		texture_path = "res://assets/buttons/4x/Asset 12@4x.png";
	%MuteButton["theme_override_styles/normal"].texture = load(texture_path);
	%MuteButton["theme_override_styles/hover"].texture = load(texture_path);
	%MuteButton["theme_override_styles/pressed"].texture = load(texture_path);
	%MuteButton["theme_override_styles/focus"].texture = load(texture_path);
	for player in get_tree().get_nodes_in_group("AudioStreamPlayers"):
		if (is_muted):
			player.set_volume_db(-999.0);
		else:
			player.set_volume_db(audio_system.get_db(config.load_value("audio", "sfx")));
	mute.emit(is_muted);
	level_vars.muted = is_muted;		

func _on_playfield_jump() -> void:
	$JumpPlayer.pitch_scale = rng.randf_range(0.7, 1.3);
	$JumpPlayer.play();


func _on_green_frog_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (selected != %GreenFrog):
			selected = %GreenFrog;
			selected.modulate = Color(1, 1, 1, 0.5);
			return;
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_on_item_drop(selected);
			selected.modulate = Color(1, 1, 1, 1);
			selected = null;


func _on_red_frog_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (selected != %RedFrog):
			selected = %RedFrog;
			selected.modulate = Color(1, 1, 1, 0.5);
			return;
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_on_item_drop(selected);
			selected.modulate = Color(1, 1, 1, 1);
			selected = null;

func _on_eraser_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (selected != %Eraser):
			selected = %Eraser;
			selected.modulate = Color(1, 1, 1, 0.5);
			return;
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_on_item_drop(selected);
			selected.modulate = Color(1, 1, 1, 1);
			selected = null;
			
func _on_item_drop(item: Control) -> void:
	for lilypad : Lilypad in get_tree().get_nodes_in_group("lilypads"):
		var item_pos : Vector2 = item.global_position - CURSOR_OFFSET;
		var distance : float = item_pos.distance_to(lilypad.global_position);
		if distance >= DROP_SHORTEST_DIST:
			continue;
		
		var coords : Vector2i = lilypad.coord;
		var status : lilypad_enum.STATUS = lilypad_enum.node_to_status(item.name)
		level_vars.update_level_layout(coords, status);
		$Playfield.initialize();
		print_debug(level_vars["info"]["level_layout"]);
		
		# Drop to the lilypad close enough
		#var start : Vector2i = item.attached_lilypad.coord;
		#var target : Vector2i = lilypad.coord;
		#if (!_check_valid_move(between, _get_lilypad(target))):
			#break;

	
	
func _process(delta: float) -> void:
	for c: Control in get_tree().get_nodes_in_group("EditorFrogs"):
		if c == selected:
			c.global_position = lerp(c.global_position, get_global_mouse_position() + CURSOR_OFFSET, 25 * delta);
		else:
			match c.name:
				"GreenFrog":
					c.position = lerp(c.position, GREEN_INITIAL, 25 * delta);
				"RedFrog":
					c.position = lerp(c.position, RED_INITIAL, 25 * delta);
				"Eraser":
					c.position = lerp(c.position, ERASER_INITIAL, 25 * delta);

