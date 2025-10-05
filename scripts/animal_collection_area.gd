extends Area2D

@onready var audio = $AudioStreamPlayer2D

signal collected_animal
var enabled: bool = false

func _on_Area2D_body_entered(body):
	if body is Animal and enabled:
		collected_animal.emit(body.kind)
		body.queue_free()
		audio.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_Area2D_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
