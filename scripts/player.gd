extends CharacterBody2D

var mouse_pos = Vector2(0, 0) # position of the mouse, relative to 0, 0

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
	elif event is InputEventMouseMotion:
		var viewport_size = get_viewport().get_visible_rect().size
		mouse_pos = event.position - viewport_size/2 # we subtract half of the view size to get coords relative to world origin
		pass

	# print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var speed = 500.0
	velocity = direction * speed
	move_and_slide()

	# Compute vector to mouse from player
	var vec_to_mouse = mouse_pos - global_position
	var vacuum_angle = atan2(vec_to_mouse.y, vec_to_mouse.x)
	$Vacuum.rotation_degrees = vacuum_angle * 180 / PI

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
