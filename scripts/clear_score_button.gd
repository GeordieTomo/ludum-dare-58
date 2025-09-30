extends Button

func _ready():
	pressed.connect(on_press_add_score)
	
func on_press_add_score():
	Events.clear_points.emit()
