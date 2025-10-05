extends Node

@export var words_that_can_be_used : Array[Enums.AllWords] = []
@export var words_that_are_selected : Dictionary = {}
@export var max_words_can_select : int = 3

var word_ui_toggles : Array[Node2D]

signal selected_words_changed

signal available_words_changed
signal available_word_added(new_word: Enums.AllWords)
@onready var thought_cloud: Control = %ThoughtCloud

func _ready():
	add_words_to_selection_dictionary()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cloud"):
		toggle_cloud()

func add_words_to_selection_dictionary():
	for word in Enums.AllWords.values():
		if not words_that_are_selected.has(word):
			words_that_are_selected[word] = false

# called from word_cloud_display.gd -> when a word toggle button is pressed
func set_word_selected_state(word: Enums.AllWords, new_state: bool):
	# check if word is selected, and then toggle its state
	words_that_are_selected[word] = new_state
	print_debug(Enums.get_string_from_enum(word), ": ", new_state)
	update_words_selected()
	
func update_words_selected():
	selected_words_changed.emit()

func add_available_word(word: Enums.AllWords):
	if not words_that_can_be_used.has(word):
		words_that_can_be_used.append(word)
	available_word_added.emit(word)
	update_words_available()
	show_cloud()

func add_available_words(words: Array[Enums.AllWords]):
	for word in words:
		add_available_word(word)

func remove_available_word(word : Enums.AllWords):
	if words_that_can_be_used.has(word):
		words_that_can_be_used.erase(word)
		
	update_words_available()

func clear_all_available_words():
	words_that_can_be_used.clear()
	update_words_available()

func update_words_available():
	available_words_changed.emit()

func word_is_available(word: Enums.AllWords) -> bool:
	return words_that_can_be_used.has(word)

func evaluate_score(target_words : Array[Enums.AllWords]) -> float:
	var score : float = 0.
	for word in target_words:
		if check_if_word_is_selected(word):
			score += 1
	score /= float(target_words.size())
	return score
	
func check_if_word_is_selected(word: Enums.AllWords) -> bool:
	return words_that_are_selected[word]

func too_many_words_selected() -> bool:
	return words_that_are_selected.values().count(true) > max_words_can_select

func toggle_cloud():
	thought_cloud.toggle_cloud()

func hide_cloud():
	thought_cloud.hide_cloud()
	
func show_cloud():
	thought_cloud.show_cloud()
