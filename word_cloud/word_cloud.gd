extends Node

@export var words_that_can_be_used : Array[Enums.AllWords] = []
@export var words_that_are_selected : Dictionary = {}

var word_ui_toggles : Array[Node2D]

signal selected_words_changed

func _ready():
	add_words_to_selection_dictionary()
	
func add_words_to_selection_dictionary():
	for word in Enums.AllWords.values():
		if not words_that_are_selected.has(word):
			words_that_are_selected[word] = false

func set_word_selected_state(word: Enums.AllWords, new_state: bool):
	# check if word is selected, and then toggle its state
	words_that_are_selected[word] = new_state
	print_debug(Enums.get_string_from_enum(word), ": ", new_state)
	update_words_selected()
	
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
	return words_that_are_selected[word]
