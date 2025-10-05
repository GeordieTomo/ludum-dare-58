extends CharacterBody2D

signal collected_animal

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollectionArea.collected_animal.connect(collected_animal.emit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_collection_enabled(enabled: bool):
	$CollectionArea.enabled = enabled
