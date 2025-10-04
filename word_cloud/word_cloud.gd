extends Node

@export var word_ui_template : PackedScene

@export var words_that_can_be_used : Array[Enums.AllWords] = []
@export var words_that_are_selected : Array[Enums.AllWords] = []
@onready var update_word_list = %update_word_list

var word_ui_toggles : Array[Node2D]

signal selected_words_changed

func _ready():
	instantiate_word_ui()
	update_word_list.pressed.connect(update_words_selected)
	
func instantiate_word_ui():
	for word in words_that_can_be_used:
		create_word_toggle_ui(word)
		
func create_word_toggle_ui(word: Enums.AllWords):
	pass
	
func toggle_word_selected(word: Enums.AllWords):
	# check if word is selected, and then toggle its state
	update_words_selected()
	pass
	
func update_words_selected():
	selected_words_changed.emit()

func evaluate_score(target_words : Array[Enums.AllWords]) -> float:
	var score : float = 0.
	for word in target_words:
		if check_if_word_is_selected(word):
			score += 1
	score /= float(target_words.size())
	return score
	
func check_if_word_is_selected(word: Enums.AllWords) -> bool:
	return words_that_are_selected.has(word)
