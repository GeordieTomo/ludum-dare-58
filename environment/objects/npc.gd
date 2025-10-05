extends Interactable
class_name NPC

@export var colour : Color = Color.WHITE

@export var can_talk_evaluation_words : Array[Enums.AllWords] = []

@export_multiline var dialogue_pre_word : String
@export var word_to_pickup : Enums.AllWords
@export_multiline var dialogue_post_word : String

@onready var speech_bubble: SpeechBubble = %SpeechBubble

@onready var sprite_2d: SpriteGlow = %Sprite2D

var word_discovered : bool = false

func _ready() -> void:
	super._ready()
	speech_bubble.finished.connect(talking_complete.unbind(1))
	sprite_2d.self_modulate = colour

func _input(event):
	if player_in_range and can_talk():
		if event.is_action_pressed("interact"):
			try_talk()

func try_talk():
	if can_talk():
		run_speech_bubble()
		hide_text_hint()

func run_speech_bubble():
	if speech_bubble._is_typing:
		speech_bubble.reveal_all()
	elif speech_bubble.visible:
		speech_bubble.hide()
	else:
		speech_bubble.show_text(str(dialogue_pre_word, " [b]", Enums.get_string_from_enum(word_to_pickup), "[/b] ", dialogue_post_word))

func talking_complete():
	if not word_discovered:
		word_discovered = true
		WordCloud.add_available_word(word_to_pickup)

func can_talk() -> bool:
	return WordCloud.evaluate_score(can_talk_evaluation_words) > 0.

func player_exited():
	super.player_exited()
	speech_bubble.hide()

func update_text_hint():
	if player_in_range and can_talk():
		show_text_hint()
	else:
		hide_text_hint()

func show_text_hint():
	interaction_hint.visible = true
	sprite_2d.enable_glow(true)
	
func hide_text_hint():
	interaction_hint.visible = false
	sprite_2d.enable_glow(false)
