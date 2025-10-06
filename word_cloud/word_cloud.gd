extends CanvasLayer

@export var words_that_can_be_used : Array[Enums.AllWords] = []
@export var words_that_are_selected : Dictionary = {}
@export var max_words_can_select : int = 3

@export var words_that_dont_deselect : Array[Enums.AllWords] =[]

#var word_ui_toggles : Array[Node2D]
var selected_word_toggles : Array[WordToggle]

signal selected_words_changed

signal available_words_changed
signal available_word_added(new_word: Enums.AllWords)
@onready var thought_cloud: Control = %ThoughtCloud
@onready var wasd_hint = %WASDHint
@onready var spaceto_jump_hint = %SpacetoJumpHint

var end_game = false : set = _set_end_game

var player_container : Control

var tutorial_complete : bool = false

var scene_transition : bool = false

var player_has_jumped : bool = false

func _ready():
	add_words_to_selection_dictionary()
	Events.new_scene_loaded.connect(reload_selected_words)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cloud"):
		toggle_cloud()

func reload_selected_words():
	print(selected_word_toggles)
	for toggle : WordToggle in selected_word_toggles:
		if toggle != null:
			if not toggle.word_toggle_button.button_pressed:
				toggle.toggle()

func add_word_toggle(toggle: WordToggle):
	if not selected_word_toggles.has(toggle):
		selected_word_toggles.append(toggle)
	print(selected_word_toggles)

func remove_word_toggle(toggle: WordToggle):
	if selected_word_toggles.has(toggle) and not scene_transition:
		selected_word_toggles.erase(toggle)

func _set_end_game(new_val):
	if new_val:
		end_game = true
		lock_word_cloud()
	else:
		end_game = false

func is_end_game():
	if end_game:
		return 1.
	else:
		return 0.

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

	if not tutorial_complete:
		print("tutorial not complete")
		if word == Enums.AllWords.Move:
			print("Showing WASD")
			show_WASD_hint()
	
	if not player_has_jumped:
		if word == Enums.AllWords.Jump:
			if new_state:
				show_jump_hint()
			else:
				hide_jump_hint()
	
	
func update_words_selected():
	selected_words_changed.emit()

func add_available_word(word: Enums.AllWords):
	if not words_that_can_be_used.has(word):
		words_that_can_be_used.append(word)
	available_word_added.emit(word)
	update_words_available()
	if (tutorial_complete):
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
	hide_WASD_hint()

func show_WASD_hint():
	wasd_hint.visible = true

func hide_WASD_hint():
	wasd_hint.visible = false
	
func show_jump_hint():
	spaceto_jump_hint.visible = true

func hide_jump_hint():
	spaceto_jump_hint.visible = false

func set_tutorial_complete():
	tutorial_complete = true

func show_cloud():
	thought_cloud.show_cloud()

func lock_word_cloud():
	hide()
	
func unlock_word_cloud():
	show()
