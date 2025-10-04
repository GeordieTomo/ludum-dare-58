extends CharacterBody2D

# 100 pixels per second
const BASE_MOVE_SPEED = 100.
# move speed multiplier
var move_speed : float = 1.
var can_move : bool = false
@export var move_evaluation_words : Array[Enums.AllWords] = []
@export var fast_evaluation_words : Array[Enums.AllWords] = []

func _ready():
	WordCloud.selected_words_changed.connect(update_scores)

func _process(delta):
	
	if can_move:
		var input = Input.get_vector("left", "right", "up", "down")
		velocity = input * delta * move_speed * 100.
		move_and_collide(velocity)
		
				
func update_scores():
	update_move_score()

func update_move_score():
	can_move = WordCloud.evaluate_score(move_evaluation_words)
	# move speed is between 1. -> 2.
	move_speed = 1. + WordCloud.evaluate_score(fast_evaluation_words)
