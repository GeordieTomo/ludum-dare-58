extends MarginContainer
class_name SpeechBubble

signal finished(text: String)

@onready var label: RichTextLabel = %Label
@onready var type_sound: AudioStreamPlayer = $TypeSound if has_node("TypeSound") else null

# Config
@export var default_speed: float = 0.03  # seconds per character
@export var allow_skip_input: bool = true

# Internal
var _is_typing: bool = false
var _full_text: String = ""
var _current_index: int = 0
var _letter_delay: float = 0.03


func _ready() -> void:
	label.text = ""


# Public: show text and type it out
func show_text(text: String, speed: float = -1.0) -> void:
	show()
	if _is_typing:
		reveal_all()

	_full_text = text
	_letter_delay = speed if speed > 0 else default_speed
	_current_index = 0
	label.text = ""
	_is_typing = true

	# Run asynchronously
	start_typing()


# Internal coroutine for typing
func start_typing() -> void:
	await _type_text()
	emit_signal("finished", _full_text)


# Async text typing logic
func _type_text() -> void:
	var length := _full_text.length()
	while _current_index < length and _is_typing:
		label.text += _full_text[_current_index]
		_current_index += 1
		
		if _current_index < length:
			if _full_text[_current_index] == "[":
				while _full_text[_current_index] != "]":
					label.text += _full_text[_current_index]
					_current_index += 1
				label.text += _full_text[_current_index]
				_current_index += 1
		
		if type_sound:
			type_sound.play()

		await get_tree().create_timer(_letter_delay).timeout

	# Ensure all text is visible at end
	_is_typing = false
	label.text = _full_text


# Instantly reveal the full line
func reveal_all() -> void:
	if not _is_typing:
		return
	_is_typing = false
	label.text = _full_text
	emit_signal("finished", _full_text)


# Optional skip with input
func _unhandled_input(event: InputEvent) -> void:
	if allow_skip_input and _is_typing and event.is_action_pressed("ui_accept"):
		reveal_all()
	elif not _is_typing and event.is_action_pressed("ui_accept"):
		hide()
