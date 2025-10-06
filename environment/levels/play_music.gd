extends Node

@export var should_change_track = false
@export var track_index = 0
@export var should_add_layer = true
@export var new_layer_index = 0

func _ready():
	if should_change_track:
		Events.play_track.emit(track_index)
	if should_add_layer:
		Events.fade_layer_in.emit(new_layer_index)
