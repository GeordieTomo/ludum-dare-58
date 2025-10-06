extends Node

@export var track_index = 0

func _ready():
	Events.play_track.emit(track_index)
