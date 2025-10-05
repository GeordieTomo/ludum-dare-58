extends CharacterBody2D

var mouse_pos = Vector2(0, 0) # position of the mouse, relative to 0, 0
var mouse_is_pressed = false

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		$Vacuum.get_node("Sprite2D").get_node("Polygon2D").get_node("GPUParticles2D").emitting = event.pressed
		mouse_is_pressed = event.pressed
		$Vacuum.set_collection_enabled(mouse_is_pressed)

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var speed = 500.0
	velocity = direction * speed
	move_and_slide()

	# Compute vector to mouse from player
	var vec_to_mouse = mouse_pos - global_position
	var vacuum_angle = atan2(vec_to_mouse.y, vec_to_mouse.x)
	$Vacuum.rotation_degrees = vacuum_angle * 180 / PI
	var collider = $Vacuum.get_node("Sprite2D").get_node("RayCast2D").get_collider()
	if collider != null and mouse_is_pressed:
		collider.position = collider.position - vec_to_mouse * 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	$Vacuum.collected_animal.connect(receive_collected_animal)
	pass

func receive_collected_animal(kind: Animal.AnimalKind):
	print("Collected a ", Animal.AnimalKind.find_key(kind))
	$VacuumUi.collect_animal(kind)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport_size = get_viewport().get_visible_rect().size
	mouse_pos = global_position + get_viewport().get_mouse_position() - viewport_size/2 # we subtract half of the view size to get coords relative to world origin
