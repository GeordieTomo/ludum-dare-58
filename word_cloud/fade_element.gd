extends Control

var fading := false
var fade_speed := 2.0

@onready var texture_rect = %TextureRect
@onready var texture_rect_2 = %TextureRect2
@onready var texture_rect_3 = %TextureRect3
@onready var texture_rect_4 = %TextureRect4
@onready var margin_container = %MarginContainer

func _process(delta):
	if fading:
		margin_container.modulate.a = clamp(margin_container.modulate.a + fade_speed * delta, 0.0, 1.0)
		texture_rect.modulate.a = clamp(texture_rect.modulate.a + fade_speed * delta, 0.0, 1.0)
		texture_rect_2.modulate.a = clamp(texture_rect_2.modulate.a + (fade_speed+0.5) * delta, 0.0, 1.0)
		texture_rect_3.modulate.a = clamp(texture_rect_3.modulate.a + (fade_speed+1.0) * delta, 0.0, 1.0)
		texture_rect_4.modulate.a = clamp(texture_rect_4.modulate.a + (fade_speed+1.5) * delta, 0.0, 1.0)
		if texture_rect.modulate.a == 1.0 or texture_rect_4.modulate.a == 0.0:
			fading = false

func toggle_cloud():
	if texture_rect_4.modulate.a > 0.8:
		hide_cloud()
	else:
		show_cloud()

func hide_cloud():
	fading = true # fade out
	fade_speed = -abs(fade_speed)


func show_cloud():
	fading = true
	fade_speed = abs(fade_speed) # fade in
