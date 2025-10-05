extends Node2D

@onready var gate_visual = %gate_visual
@onready var static_body_2d = %StaticBody2D

@export var connected_button : Node2D
@export var fade_duration : float = 0.5

var open : bool = false
var tween : Tween

func _ready():
	if connected_button:
		connected_button.toggled.connect(set_gate_open_state)

func set_gate_open_state(new_state : bool):
	print("gate open: ", new_state)
	open = new_state

	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(
		gate_visual, 
		"modulate:a", 
		1.0 if not open else 0.0, 
		fade_duration
	)

	if open:
		# disable collision after fade completes
		tween.finished.connect(func():
			static_body_2d.collision_layer = 0
		)
	else:
		# enable collision immediately before fading in
		static_body_2d.collision_layer = 1
