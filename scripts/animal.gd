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
var being_collected = false
var destination = null

func set_being_collected(new_state: bool):
	being_collected = new_state

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if destination == null:
		# pick a random point to walk to
		destination = create_random_vec2_in_range(-500, 500)
		# start walking there
	else:
		if (destination - position).length() > 5:
			position += (destination - position).normalized() * 4
		else:
			destination = null

func create_random_vec2_in_range(min_val: float, max_val: float):
	# Initialize the random number generator
	var random_x = randf_range(min_val, max_val)
	var random_y = randf_range(min_val, max_val)
	var random_vec2 = Vector2(random_x, random_y)
	return random_vec2
