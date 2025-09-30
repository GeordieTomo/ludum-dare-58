extends Node

func _ready():
	Events.add_points.connect(screen_shake.unbind(1))
	Events.clear_points.connect(screen_shake_large)
	
func screen_shake():
	TweenCustom.screen_shake(0.1)

func screen_shake_large():
	TweenCustom.screen_shake(0.3)
