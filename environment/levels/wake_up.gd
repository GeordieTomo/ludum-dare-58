extends Node

@export var wake_up_evaluation_words : Array[Enums.AllWords] = []

@export var end_game_scene : PackedScene

func _ready():
	WordCloud.selected_words_changed.connect(check_words)
	Events.play_track.emit(2)

func check_words():
	if WordCloud.evaluate_score(wake_up_evaluation_words) >= 1.:
		Events.entered_portal.emit(end_game_scene)
