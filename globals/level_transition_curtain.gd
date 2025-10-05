extends ColorRect

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fade_in():
	# TODO: disable mouse
	animation_player.play("fade_in")
	await animation_player.animation_finished

func fade_out():
	animation_player.play("fade_out")
	# TODO: re-enable mouse
