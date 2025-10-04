extends CenterContainer

@onready var message_display = %MessageDisplay

func _ready():
	WordCloud.available_word_added.connect(new_word)
	
func new_word(word: Enums.AllWords):
	message_display.display_message(Enums.get_string_from_enum(word) + " unlocked", 3.)
