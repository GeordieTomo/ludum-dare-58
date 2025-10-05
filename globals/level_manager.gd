extends Node

@export var starting_level : PackedScene
var current_level  # TODO: make this dynamic

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Events.entered_portal.connect(handle_portal_entry)
	
	var children = get_children()
	var scene_exists = false
	if children.size() > 1:
		for child in children:
			if child is Node2D and child is not CanvasLayer:
				current_level = child
				scene_exists = true
				
	if not scene_exists:
		add_scene(starting_level)
	
func handle_portal_entry(target_level: PackedScene):
	await $level_transition_canvas/level_transition_curtain.fade_in()
	current_level.queue_free()
	add_scene(target_level)
	await get_tree().create_timer(0.2).timeout
	$level_transition_canvas/level_transition_curtain.fade_out()

func add_scene(target_level: PackedScene):
	current_level = target_level.instantiate()
	add_child(current_level)
