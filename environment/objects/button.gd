extends Area2D

@export var can_push_evaluation_words : Array[Enums.AllWords] = []

# if 0, doesn't ever timeout
@export var timeout : float = 0. 

var state : bool = false
var player_in_range = false
@onready var interaction_hint = %InteractionHint
@onready var depressed_sprite : SpriteGlow = %Depressed
@onready var pressed_sprite = %Pressed

signal toggled(new_state: bool)

func _ready():
	set_state(false)
	player_exited()
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)
	WordCloud.selected_words_changed.connect(update_text_hint)

func _input(event):
	if player_in_range:
		if event.is_action_pressed("interact"):
			try_press_button()

func try_press_button():
	if (can_push_button()):
		toggle()
		print_debug("button pressed: ", state)

func can_push_button() -> bool:
	return WordCloud.evaluate_score(can_push_evaluation_words) > 0.

func toggle():
	if timeout > 0.:
		turn_off_button_delayed(timeout)
	set_state(not state)
	toggled.emit(state)
	hide_text_hint()
	
func turn_off_button_delayed(delay: float):
	await get_tree().create_timer(delay).timeout
	set_state(false)
	toggled.emit(state)

func set_state(new_state):
	state = new_state
	pressed_sprite.visible = state
	depressed_sprite.visible = not state

func _body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_entered()
		
func _body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_exited()

func player_entered():
	player_in_range = true
	update_text_hint()

func player_exited():
	player_in_range = false
	update_text_hint()

func update_text_hint():
	if player_in_range and can_push_button():
		show_text_hint()
	else:
		hide_text_hint()

func show_text_hint():
	interaction_hint.visible = true
	depressed_sprite.enable_glow(true)
	
func hide_text_hint():
	interaction_hint.visible = false
	depressed_sprite.enable_glow(false)
