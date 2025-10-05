extends Control

func collect_animal(kind: Animal.AnimalKind):
	$MarginContainer.get_node("VBoxContainer").get_node("GridContainer").add_animal(kind)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
