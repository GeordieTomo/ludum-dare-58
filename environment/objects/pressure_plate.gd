extends Interactable

@export var can_push_evaluation_words : Array[Enums.AllWords] = []

# if 0, doesn't ever timeout
@export var timeout : float = 0. 

@onready var buttonAudio = %AUD_button

var state : bool = false
@onready var depressed_sprite : SpriteGlow = %Depressed
@onready var pressed_sprite = %Pressed
@onready var progress_bar = %ProgressBar

var num_bodies = 0

signal toggled(new_state: bool)

func _ready():
	super._ready()
	set_state(false)

	
func set_state(new_state):
	state = new_state
	pressed_sprite.visible = state
	depressed_sprite.visible = not state

func _body_entered(body: Node2D):
	print(body.name)
	if body.is_in_group("player") or body.is_in_group("rock"):
		num_bodies += 1
		update_state()
		
func _body_exited(body: Node2D):
	print(body.name)
	if body.is_in_group("player") or body.is_in_group("rock"):
		num_bodies -= 1
		update_state()
func update_state():
	if(num_bodies > 0):
			set_state(true)
			buttonAudio.play()
	else:
		set_state(false)		
