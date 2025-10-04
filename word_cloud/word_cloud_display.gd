extends Control

@export var word_ui_template : PackedScene

func _ready():
	instantiate_word_ui()

func instantiate_word_ui():
	for word in WordCloud.words_that_can_be_used:
		create_word_toggle_ui(word)
		
func create_word_toggle_ui(word: Enums.AllWords):
	var new_word_toggle : WordToggle = word_ui_template.instantiate()
	new_word_toggle.toggled.connect(word_toggled.bind(word))
	new_word_toggle.text = Enums.get_string_from_enum(word)
	add_child(new_word_toggle)
	
func word_toggled(toggled_on: bool, word: Enums.AllWords):
	WordCloud.set_word_selected_state(word, toggled_on)
