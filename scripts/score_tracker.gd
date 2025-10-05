extends Label

var score : int = 0

func _ready():
	Events.add_points.connect(points_added)
	Events.clear_points.connect(clear_points)
	clear_points()
	
func points_added(number_of_points : int):
	score += number_of_points
	update_text()

func clear_points():
	score = 0
	update_text()
	
func update_text():
	text = "Animals: " + str(score)
