extends Node

func _ready():
	await get_tree().create_timer(2.).timeout
	Events.hide_screen.emit(true)
