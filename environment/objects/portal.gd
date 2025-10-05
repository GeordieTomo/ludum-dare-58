extends Node2D

@export var target_level: PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.body_entered.connect(teleport)

func teleport(body):
	if body.is_in_group("player"):
		Events.entered_portal.emit(target_level)
