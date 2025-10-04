extends Node

var stage : int = 0

@export var words_to_add : Array[Enums.AllWords]

func _ready():
	
	WordCloud.selected_words_changed.connect(selected_words_changed)
	WordCloud.clear_all_available_words()
	
	await get_tree().create_timer(0.5).timeout
	WordCloud.add_available_word(Enums.AllWords.Light)

func selected_words_changed():
	
	match(stage):
		0:
			if WordCloud.check_if_word_is_selected(Enums.AllWords.Light):
				stage += 1
				await get_tree().create_timer(1.5).timeout
				WordCloud.add_available_word(Enums.AllWords.Move)
		1:
			if WordCloud.check_if_word_is_selected(Enums.AllWords.Move):
				stage += 1
				await get_tree().create_timer(1.5).timeout
				WordCloud.add_available_word(Enums.AllWords.Push)
		2:
			if WordCloud.check_if_word_is_selected(Enums.AllWords.Push):
				stage += 1
				await get_tree().create_timer(1.5).timeout
				WordCloud.add_available_words(words_to_add)
