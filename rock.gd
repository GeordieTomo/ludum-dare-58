extends RigidBody2D

@export var can_move_evaluation_words : Array[Enums.AllWords] = []

func _ready():
	WordCloud.selected_words_changed.connect(update_push_score)

func update_push_score():
	if WordCloud.evaluate_score(can_move_evaluation_words) > 0.:
		collision_layer = int(1) << 2
	else:
		collision_layer = int(1) << 1
