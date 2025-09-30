# Events
# this script is defined as a globally accessible singleton in: Project -> Project Settings -> Globals
extends Node

signal add_points(number_of_points : int)
signal clear_points

func _ready():
	add_points.connect(points_added)
	clear_points.connect(points_cleared)
	
func points_added(number_of_points):
	print_debug("points added: ", number_of_points)

func points_cleared():
	print_debug("points cleared")
