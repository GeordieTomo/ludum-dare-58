extends Area2D

@export var can_pickup_evaluation_words : Array[Enums.AllWords] = []
@export var can_throw_evaluation_words : Array[Enums.AllWords] = []
@export var throw_distance_evaluation_words : Array[Enums.AllWords] = []

var player_in_range = false
var player_holding = false
var player_holding_lerp : float = 0.

var throwing = false
var throwing_lerp : float = 0.
var target_throw_position : Vector2 = Vector2.ZERO
@export var max_throw_distance = 200.

@export var holding_offset = Vector2(0,-40)

var player = null

@onready var interaction_hint = %InteractionHint
@onready var sprite_glow : SpriteGlow = %Sprite2D
@onready var ground_detector: Area2D = %GroundDetector

var start_position

func _ready():
	player_exited()
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)
	WordCloud.selected_words_changed.connect(update_text_hint)
	start_position = position

func can_pickup_or_put_down() -> bool:
	return WordCloud.evaluate_score(can_pickup_evaluation_words) > 0.

func can_throw() -> bool:
	return player_holding and WordCloud.evaluate_score(can_throw_evaluation_words) > 0.

func get_throw_distance() -> float:
	return WordCloud.evaluate_score(throw_distance_evaluation_words) * max_throw_distance

func _input(event):
	if player_in_range:
		if can_throw():
			if event.is_action_pressed("interact"):
				try_throw()
		elif can_pickup_or_put_down():
			if event.is_action_pressed("interact"):
				try_pickup_or_putdown()
		
func try_pickup_or_putdown():
	if can_pickup_or_put_down():
		rotation = 0
		throwing = false
		player_holding = not player_holding
		player_holding_lerp = 0.
		throwing_lerp = 0.
		if player_holding:
			z_index = 4
		else:
			z_index = 3
		hide_text_hint()

func try_throw():
	if can_throw():
		throwing_lerp = 0.
		player_holding = not player_holding
		target_throw_position = global_position + get_throw_distance() * global_position.direction_to(get_global_mouse_position())
		throwing = true

func _process(delta):
	if player_holding:
		follow_player(delta)
	elif throwing:
		follow_arc(delta)
		
func follow_player(delta):
	var target = player.position + holding_offset
	rotation = global_position.angle_to(get_global_mouse_position())
	player_holding_lerp = clamp(player_holding_lerp + delta, 0.0, 1.0)
	position = position.lerp(target, player_holding_lerp)

func follow_arc(delta):
	throwing_lerp = clamp(throwing_lerp + delta, 0.0, 1.0)
	global_position = global_position.lerp(target_throw_position, throwing_lerp)
	rotation = lerpf(rotation, 0, throwing_lerp)
	if throwing_lerp >= 1.0:
		print("checking landed")
		check_landed()
		throwing = false
	


func _body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_entered()
		player = body
		
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
	if player_in_range and can_pickup_or_put_down():
		show_text_hint()
	else:
		hide_text_hint()

func show_text_hint():
	interaction_hint.visible = true
	sprite_glow.enable_glow(true)
	
func hide_text_hint():
	interaction_hint.visible = false
	sprite_glow.enable_glow(false)
	
func check_landed():
	if ground_detector.get_overlapping_bodies().size() == 0:
		position = start_position
