extends Node2D

@export var speed = 1.0
@export var move_scale = 10.

var time : float = 0.
var start_pos : float= 0.

func _ready() -> void:
	start_pos = position.y

func _process(delta: float) -> void:
	time += delta
	position.y = start_pos + sin(time) * move_scale
	
