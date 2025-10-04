extends Control

@export var lerp_speed := 5.0
var target_position : Vector2
var prev_position : Vector2

func _ready():
	# Start at the parent's current global position
	target_position = get_parent().global_position

func _process(delta):
	var parent_pos = get_parent().global_position
	
	# If parent moved, update target position
	if parent_pos != target_position:
		target_position = parent_pos
		global_position = prev_position

	# Smoothly move child towards the parent's position
	global_position = global_position.lerp(target_position, 1.0 - exp(-lerp_speed * delta))
	prev_position = global_position
