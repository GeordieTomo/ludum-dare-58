extends GridContainer

var bag_size = 12
var animals: Array[Animal.AnimalKind] = []

const animal_textures = {
	Animal.AnimalKind.ANT: preload("res://textures/animals/Ant.png"),
	Animal.AnimalKind.CAT: preload("res://textures/animals/Cat.png"),
	Animal.AnimalKind.ELEPHANT: preload("res://textures/animals/Elephant.png"),
	Animal.AnimalKind.LADYBUG: preload("res://textures/animals/Lbug.png"),
	Animal.AnimalKind.LEECH: preload("res://textures/animals/Leech.png"),
	Animal.AnimalKind.LION: preload("res://textures/animals/Lion.png"),
	Animal.AnimalKind.MONKEY: preload("res://textures/animals/MOnki.png"),
	Animal.AnimalKind.MOUSE: preload("res://textures/animals/Mouse.png"),
	Animal.AnimalKind.GIRAFFE: preload("res://textures/animals/Raff.png"),
	Animal.AnimalKind.SPIDER: preload("res://textures/animals/Spider.png"),
}

func add_animal(kind: Animal.AnimalKind):
	if animals.size() == bag_size:
		# can't fit any more animals
		return
	var tile = get_children()[animals.size()]
	animals.push_back(kind)
	tile.get_node("MarginContainer").get_node("TextureRect").texture = animal_textures[kind]

func deposit_all():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 12:
		var tile = preload("res://AnimalGridTile.tscn").instantiate()
		add_child(tile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
