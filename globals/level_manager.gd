extends Node

@onready var current_level = $TestLevel # TODO: make this dynamic

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level.get_node("Portal").entered_portal.connect(handle_portal_entry)

func handle_portal_entry(target_level: PackedScene):
	await $level_transition_canvas/level_transition_curtain.fade_in()
	current_level.queue_free()
	current_level = target_level.instantiate()
	add_child(current_level)
	await get_tree().create_timer(2).timeout
	$level_transition_canvas/level_transition_curtain.fade_out()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
