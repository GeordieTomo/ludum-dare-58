extends Node2D

@onready var gate_visual = %gate_visual
@onready var static_body_2d = %StaticBody2D

@export var connected_button : Node2D

var open : bool = false

func _ready():
	if connected_button:
		connected_button.toggled.connect(set_gate_open_state)

func set_gate_open_state(new_state : bool):
	print("gate open: ", new_state)
	open = new_state
	gate_visual.visible = not open
	if open:
		static_body_2d.collision_layer = int(0)
	else:
		static_body_2d.collision_layer = int(1)
