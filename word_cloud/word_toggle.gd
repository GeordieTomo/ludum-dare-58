extends Control
class_name WordToggle

@onready var word_toggle_button : Button = %WordToggleButton

var text : String : set = set_text
var word_value : Enums.AllWords

signal toggled(new_state : bool)

func _ready():
	word_toggle_button.toggled.connect(_pressed)
	word_toggle_button.global_position = global_position
	word_toggle_button.visible = true
	
func _pressed(new_val : bool):
	toggled.emit(new_val)

func toggle():
	word_toggle_button.button_pressed = !word_toggle_button.button_pressed

func set_text(new_text: String):
	set_button_text.call_deferred(new_text)

func set_button_text(new_text: String):
	word_toggle_button.text = new_text
