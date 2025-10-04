class_name Animal extends CharacterBody2D 

enum AnimalKind {
	ANT,
	LADYBUG,
	MOUSE,
	SPIDER,
	LEECH,
	GIRAFFE,
	MONKEY,
	ELEPHANT,
	LION,
	CAT,
}

@export var kind: AnimalKind = AnimalKind.CAT

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
