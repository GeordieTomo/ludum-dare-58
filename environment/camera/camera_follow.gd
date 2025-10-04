extends Camera2D


@export var lerp_speed := 5.0
var target_position : Vector2

@export var follow_target : Node2D

func _ready():
	# Start at the parent's current global position
	target_position = follow_target.global_position
	global_position = target_position

func _process(delta):
	target_position = follow_target.global_position
	
	# Smoothly move child towards the parent's position
	global_position = global_position.lerp(target_position, 1.0 - exp(-lerp_speed * delta))
