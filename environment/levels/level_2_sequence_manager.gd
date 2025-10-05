extends Node

@export var unlocked_words : Array[Enums.AllWords]

func _ready():
	WordCloud.add_available_words(unlocked_words)
