extends CharacterBody2D

# 100 pixels per second
const BASE_MOVE_SPEED = 200.
# move speed multiplier
var move_speed : float = 1.
@export var move_evaluation_words : Array[Enums.AllWords] = []
@export var fast_evaluation_words : Array[Enums.AllWords] = []
@export var jump_evaluation_words : Array[Enums.AllWords] = []
@export var jump_height_evaluation_words : Array[Enums.AllWords] = []
@export var jump_speed_evaluation_words : Array[Enums.AllWords] = []
@export var light_evaluation_words : Array[Enums.AllWords] = []
@onready var brainmoveAudio = %AUD_brainmove
@onready var brainjumpAudio = %AUD_brainjump
@onready var brainlandAudio = %AUD_brainland

var jumping : bool = false
var falling : bool = false
var fall_time : float = 0.
var touching_ground : bool = true
var jump_lerp_pct : float = 0.

var y_velocity : float = 0.
var y_offset : float = 0.

var player_sprite_origin : Vector2
var player_default_collision
var floating_y_offset : float = 0.
var time : float = 0.

var start_position

var last_grounded_pos : Array[Vector2]

@onready var player_sprite: Sprite2D = %Player

@onready var ground_detector: Area2D = %GroundDetector
@onready var word_container: Control = %WordContainer

var light_target = 0.5
@onready var point_light_2d = %PointLight2D
@onready var think_harder = %think_harder

func _ready():
	WordCloud.selected_words_changed.connect(update_scores)
	player_sprite_origin = player_sprite.position
	player_default_collision = collision_mask
	WordCloud.player_container = word_container
	start_position = position
	
func _process(delta):
	
	
	var input = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_just_pressed("cloud"):
		hide_think_hint()
	
	if can_move():

		# Target velocity based on input
		var target_velocity = input * move_speed * BASE_MOVE_SPEED * Vector2(1., 0.5)
		
		# Smoothly accelerate toward the target velocity
		var acceleration = 20.0  # higher = snappier, lower = smoother
		velocity = velocity.lerp(target_velocity, 1.0 - exp(-acceleration * delta))
		
		if velocity.length() > 60.:
			WordCloud.hide_cloud()
			brainmoveAudio.volume_linear = velocity.length() / 30
			WordCloud.set_tutorial_complete()
		else:
			brainmoveAudio.volume_linear = 0
		
		move_and_slide()
	else:
		if input.length() > 0.:
			show_think_hint()
	
	if can_jump():
		if Input.is_action_just_pressed("jump"):
			try_jump()
			
	process_y_level(delta)
	
	if position != start_position:
		check_on_ground()
	
	update_light(delta)

func show_think_hint():
	think_harder.show()

func hide_think_hint():
	think_harder.hide()

func update_light(delta):
	if point_light_2d.texture_scale < light_target:
		point_light_2d.texture_scale += delta * 0.1
	elif point_light_2d.texture_scale > light_target:
		point_light_2d.texture_scale -= delta * 0.1
	
	if abs(point_light_2d.texture_scale - light_target) < 0.05:
		point_light_2d.texture_scale = light_target

func check_on_ground():
	touching_ground = ground_detector.get_overlapping_bodies().size() > 0.
	
	if not touching_ground and not jumping:
		fall()
	if touching_ground:
		last_grounded_pos.append(position)
		if last_grounded_pos.size() > 40:
			last_grounded_pos.pop_front()
	return touching_ground
	
func fall():
	falling = true

func can_jump() -> bool:
	return touching_ground and not jumping and WordCloud.evaluate_score(jump_evaluation_words) > 0.0
				
func try_jump():
	if can_jump():
		jumping = true
		brainjumpAudio.play()
		y_velocity = - get_jump_height()

func process_y_level(delta):
	
	time += delta
	floating_y_offset = 5. * sin(time)
	
	z_index = 3
	collision_mask = player_default_collision
	collision_layer = player_default_collision

	if falling or jumping:
		# apply gravity
		y_velocity += delta * 200.
		# move offset
		y_offset += y_velocity * delta

	if jumping:
		collision_mask = int(1) << 4
		collision_layer = int(1) << 4

		player_sprite.position = player_sprite_origin + Vector2(0, floating_y_offset+ y_offset)
		if y_offset >= 0.0 and y_velocity > 0.:
			jumping = false
			brainlandAudio.play()
			player_sprite.position = player_sprite_origin + Vector2(0, floating_y_offset)

	elif falling:
		z_index = -5

		player_sprite.position = player_sprite_origin + Vector2(0, floating_y_offset+ y_offset)
		if y_offset >= 100.0:
			falling = false
			player_sprite.position = player_sprite_origin + Vector2(0, floating_y_offset)
			position = last_grounded_pos[0]
			y_offset = 0.
			
	else:
		player_sprite.position = player_sprite_origin + Vector2(0, floating_y_offset)

			
func get_jump_duration() -> float:
	return 0.5 / WordCloud.evaluate_score(jump_speed_evaluation_words)

func get_jump_height() -> float:
	# map from 0.75 to 1.
	return 150. * (WordCloud.evaluate_score(jump_height_evaluation_words) * 0.5 + 0.5)

func update_scores():
	evaluate_light()
	
func evaluate_light():
	if WordCloud.evaluate_score(light_evaluation_words) > 0.:
		light_target = 5.
	else:
		light_target = 1.5

func can_move() -> bool:
	move_speed = 1. + 0.75 * WordCloud.evaluate_score(fast_evaluation_words)
	return not falling and WordCloud.evaluate_score(move_evaluation_words)
