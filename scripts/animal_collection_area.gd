extends Area2D

signal collected_animal
var collection_enabled: bool = false

func set_collection_enabled(enabled: bool):
	collection_enabled = enabled

func _on_Area2D_body_entered(body):
	if body is Animal and collection_enabled:
		collected_animal.emit(body.kind)
		body.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_Area2D_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
