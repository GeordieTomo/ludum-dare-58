extends Node

@export var start_unlocked_words : Array[Enums.AllWords]

@export var collision_triggers : Array[Area2D]

@export var collision_trigger_words_unlocked : Array[Enums.AllWords]

@export var start_cloud_hidden : bool = false 

@export var tutorial_complete = true

func _ready():
	WordCloud.add_available_words(start_unlocked_words)
	
	WordCloud.tutorial_complete = tutorial_complete
	
	if start_cloud_hidden:
		WordCloud.hide_cloud()

	for i in range(collision_trigger_words_unlocked.size()):
		if collision_triggers.size() > i:
			collision_triggers[i].area_entered.connect(trigger_word_unlock.bind(collision_trigger_words_unlocked[i]))
			
			
func trigger_word_unlock(word : Enums.AllWords):
	WordCloud.add_available_word(word)
