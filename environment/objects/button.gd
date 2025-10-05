extends Interactable

@export var can_push_evaluation_words : Array[Enums.AllWords] = []

# if 0, doesn't ever timeout
@export var timeout : float = 0. 

@export var buttonAudio : AudioStreamPlayer2D

var state : bool = false
@onready var depressed_sprite : SpriteGlow = %Depressed
@onready var pressed_sprite = %Pressed
@onready var progress_bar = %ProgressBar

signal toggled(new_state: bool)

func _ready():
	super._ready()
	set_state(false)

func _input(event):
	if player_in_range:
		if event.is_action_pressed("interact"):
			try_press_button()

func try_press_button():
	if (can_push_button() and not progress_bar.visible):
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
	buttonAudio.play()
	
func turn_off_button_delayed(delay: float):
	run_progress_bar(delay)
	await get_tree().create_timer(delay).timeout
	set_state(false)
	toggled.emit(state)
	
func run_progress_bar(duration: float) -> void:
	# Make sure the ProgressBar starts visible and full
	progress_bar.visible = true
	progress_bar.value = 1.0

	var elapsed := 0.0
	while elapsed < duration:
		await get_tree().process_frame
		elapsed += get_process_delta_time()
		progress_bar.value = 100.0 - 100.0 * (elapsed / duration)
	
	progress_bar.value = 0.0
	progress_bar.visible = false

func set_state(new_state):
	state = new_state
	pressed_sprite.visible = state
	depressed_sprite.visible = not state

# overrides
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
