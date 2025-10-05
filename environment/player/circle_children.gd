extends Control

@export var radius: float = 50.0
@export var speed: float = 0.3

var angle_offset: float = 0.0

func _process(delta: float) -> void:
	if get_child_count() == 0:
		return

	angle_offset += speed * delta

	var center = size / 2.0
	var child_count = get_child_count()

	for i in range(child_count):
		var child = get_child(i)
		if not child is Control:
			continue

		# Evenly distribute children in a circle
		var angle = angle_offset + (TAU / child_count) * i
		var modifier = sin(angle * TAU)
		var x = center.x + cos(angle) * radius*(0.9 + 0.1 * modifier)
		var y = center.y + sin(angle) * radius*(0.9 + 0.1 * modifier)
		child.position = Vector2(x, y) - child.size / 2.0
