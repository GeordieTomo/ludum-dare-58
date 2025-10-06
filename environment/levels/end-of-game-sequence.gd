extends Node

@onready var tween : Tween

@onready var color_rect = %ColorRect


func _ready():
	await get_tree().create_timer(2.).timeout
	Events.hide_screen.emit(true)
	fade_out(3.)

func fade_out(duration: float = 1.0):
	tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, duration)
	tween.finished.connect(func():
		color_rect.visible = false)
