extends WorldEnvironment

@export var light_evaluation_words : Array[Enums.AllWords] = []

var tonemap_target : float = 1.
@onready var color_rect = %ColorRect

func _ready():
	words_updated()
	WordCloud.selected_words_changed.connect(words_updated)
	set_tonemap(tonemap_target)

func _process(delta):
	if color_rect.color.a < tonemap_target:
		color_rect.color.a += delta * 0.5
	elif color_rect.color.a > tonemap_target:
		color_rect.color.a -= delta * 0.5
	
	if abs(color_rect.color.a - tonemap_target) < 0.05:
		color_rect.color.a = tonemap_target

		
func words_updated():
	set_light(WordCloud.evaluate_score(light_evaluation_words) + WordCloud.is_end_game())

func set_light(pct : float):
	# map between 0.05 -> 1.0
	tonemap_target = clamp(1. - pct * 0.95 - 0.05, 0.0, 1.)
	
func set_tonemap(pct: float):
	#print(color_rect.modulate.a)
	#color_rect.color.a = 1.
	pass
