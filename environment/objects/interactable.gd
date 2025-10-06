extends Area2D
class_name Interactable

var player_in_range = false
@onready var interaction_hint = %InteractionHint

func _ready() -> void:
	player_exited()
	area_entered.connect(_body_entered)
	area_exited.connect(_body_exited)
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)
	WordCloud.selected_words_changed.connect(update_text_hint)

func _body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_entered()
		
func _body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_exited()

func player_entered():
	player_in_range = true
	update_text_hint()

func player_exited():
	player_in_range = false
	update_text_hint()

func update_text_hint():
	if player_in_range:
		show_text_hint()
	else:
		hide_text_hint()

func show_text_hint():
	interaction_hint.visible = true
	
func hide_text_hint():
	interaction_hint.visible = false
