extends Button

func _ready():
	pressed.connect(on_press_add_score)
	
func on_press_add_score():
	Events.add_points.emit(1)
