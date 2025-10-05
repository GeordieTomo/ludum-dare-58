extends Control

var fading := false
var fade_speed := 2.0

func _process(delta):
	if fading:
		modulate.a = clamp(modulate.a + fade_speed * delta, 0.0, 1.0)
		if modulate.a == 1.0 or modulate.a == 0.0:
			fading = false

func toggle_cloud():
	if modulate.a > 0.5:
		hide_cloud()
	else:
		show_cloud()

func hide_cloud():
	fading = true
	fade_speed = -abs(fade_speed) # fade out

func show_cloud():
	fading = true
	fade_speed = abs(fade_speed) # fade in
