extends Control

@export var word_ui_template : PackedScene


@onready var available_word_container = %AvailableWordContainer
#@onready var selected_word_container = %SelectedWordContainer

var word_toggle_objects : Array[WordToggle] = []

@export var selectwordAudio : AudioStreamPlayer2D
@export var deselectAudio : AudioStreamPlayer2D


func _ready():
	Events.entered_portal.connect(deselect_all_words.unbind(1))
	instantiate_word_ui()
	WordCloud.available_words_changed.connect(update_word_ui)

func deselect_all_words():
	for word in word_toggle_objects:
		if word.word_toggle_button.button_pressed:
			word.toggle()

func instantiate_word_ui():
	for word in WordCloud.words_that_can_be_used:
		create_word_toggle_ui(word)

func update_word_ui():
	var existing_words: Array[Enums.AllWords]
	# if any items have been removed
	for word_toggle in word_toggle_objects.duplicate():
		if not WordCloud.word_is_available(word_toggle.word_value):
			word_toggle_objects.erase(word_toggle)
			word_toggle.queue_free()
		else:
			existing_words.append(word_toggle.word_value)

	for word in WordCloud.words_that_can_be_used:
		if not existing_words.has(word):
			create_word_toggle_ui(word)


func create_word_toggle_ui(word: Enums.AllWords):
	var new_word_toggle : WordToggle = word_ui_template.instantiate()
	new_word_toggle.toggled.connect(word_toggled.bind(new_word_toggle))
	new_word_toggle.text = Enums.get_string_from_enum(word)
	new_word_toggle.word_value = word
	available_word_container.add_child(new_word_toggle)
	word_toggle_objects.append(new_word_toggle)
	
func word_toggled(toggled_on: bool, word_toggle : WordToggle):
	WordCloud.set_word_selected_state(word_toggle.word_value, toggled_on)
	
	if WordCloud.too_many_words_selected():
		# Don't allow the player to select a new word
		#word_toggle.toggle()
		# Deselect the oldest word
		var oldest_word_toggle: WordToggle = WordCloud.player_container.get_child(0)
		if oldest_word_toggle.word_value == Enums.AllWords.See:
			oldest_word_toggle = WordCloud.player_container.get_child(1)
		oldest_word_toggle.toggle()
	
	if toggled_on:

		word_toggle.get_parent().remove_child(word_toggle)
		WordCloud.player_container.add_child(word_toggle)
		selectwordAudio.play()
		
	else:
		word_toggle.get_parent().remove_child(word_toggle)
		available_word_container.add_child(word_toggle)
		deselectAudio.play()
