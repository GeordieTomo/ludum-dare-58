extends ColorRect

@onready var animation_player = $AnimationPlayer


func fade_in():
	# TODO: disable mouse
	animation_player.play("fade_in")
	await animation_player.animation_finished

func fade_out():
	animation_player.play("fade_out")
	# TODO: re-enable mouse
