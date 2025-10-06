extends Node2D

@export var layer_players : Array[AudioStreamPlayer2D]
@export var level_num = 0
var fading_in = false
var fade_level = 0

func _ready() -> void:
	fading_in = true
	for player in layer_players:
		player.volume_linear = 0
	
func _process(delta: float) -> void:
	if fading_in:
		fade_level = clamp(fade_level + delta, 0.0, 1.0)
		for i in level_num:
			layer_players[i].volume_linear = fade_level
		if fade_level >= 1.0:
			fading_in = false	
