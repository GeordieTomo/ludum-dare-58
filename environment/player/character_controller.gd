extends CharacterBody2D

# 100 pixels per second
const BASE_MOVE_SPEED = 200.
# move speed multiplier
var move_speed : float = 1.
var can_move : bool = false
@export var move_evaluation_words : Array[Enums.AllWords] = []
@export var fast_evaluation_words : Array[Enums.AllWords] = []
@export var jump_evaluation_words : Array[Enums.AllWords] = []
@export var jump_height_evaluation_words : Array[Enums.AllWords] = []
@export var jump_speed_evaluation_words : Array[Enums.AllWords] = []

var jumping : bool = false
var jump_lerp_pct : float = 0.

var player_sprite_origin : Vector2
var floating_y_offset : float = 0.
var time : float = 0.

@onready var player_sprite: Sprite2D = %Player

func _ready():
	WordCloud.selected_words_changed.connect(update_scores)
	player_sprite_origin = player_sprite.position

func _process(delta):
	
	if can_move:
		var input = Input.get_vector("left", "right", "up", "down")
		# Target velocity based on input
		var target_velocity = input * move_speed * BASE_MOVE_SPEED * Vector2(1., 0.5)
		
		# Smoothly accelerate toward the target velocity
		var acceleration = 20.0  # higher = snappier, lower = smoother
		velocity = velocity.lerp(target_velocity, 1.0 - exp(-acceleration * delta))
		
		move_and_slide()
	
	if can_jump():
		if Input.is_action_just_pressed("jump"):
			try_jump()
			
	process_jump(delta)
	
func can_jump() -> bool:
	return not jumping and WordCloud.evaluate_score(jump_evaluation_words) > 0.0
				
func try_jump():
	if can_jump():
		jumping = true

func process_jump(delta):
	
	time += delta
	floating_y_offset = 5. * sin(time)
	
	if jumping:
		jump_lerp_pct += delta / get_jump_duration()
		jump_lerp_pct = clamp(jump_lerp_pct, 0.0, 1.0)

		var y_offset = -sin(jump_lerp_pct * PI) * get_jump_height()
		player_sprite.position = player_sprite_origin + Vector2(0, floating_y_offset+ y_offset)
		if jump_lerp_pct >= 1.0:
			jumping = false
			player_sprite.position = player_sprite_origin + Vector2(0, floating_y_offset)
			jump_lerp_pct = 0.0
	else:
		player_sprite.position = player_sprite_origin + Vector2(0, floating_y_offset)

			
func get_jump_duration() -> float:
	return 0.5 / WordCloud.evaluate_score(jump_speed_evaluation_words)

func get_jump_height() -> float:
	# map from 0.75 to 1.
	return 50. * (WordCloud.evaluate_score(jump_height_evaluation_words) * 0.5 + 0.5)

func update_scores():
	update_move_score()

func update_move_score():
	can_move = WordCloud.evaluate_score(move_evaluation_words)
	# move speed is between 1. -> 2.
	move_speed = 1. + WordCloud.evaluate_score(fast_evaluation_words)
