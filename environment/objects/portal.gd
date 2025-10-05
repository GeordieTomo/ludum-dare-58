extends Node2D

@export var target_level: PackedScene = null

signal entered_portal

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.body_entered.connect(teleport)

func teleport(_body):
	entered_portal.emit(target_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
