extends Control
class_name MessageDisplay

@onready var rich_text_label = %RichTextLabel

func _ready():
	hide_display()

func display_message(new_text: String, time):
	rich_text_label.text = "[wave]" + new_text
	await fade_in_display(0.2 * time)
	await get_tree().create_timer(0.6*time).timeout
	await fade_out_display(0.2 * time)

func fade_in_display(duration):
	await TweenCustom.animate_to_alpha_wait(self, 1., duration)
	
func fade_out_display(duration):
	await TweenCustom.animate_to_alpha_wait(self, 0., duration)

func hide_display():
	modulate.a = 0.
