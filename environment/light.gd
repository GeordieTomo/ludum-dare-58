extends WorldEnvironment

@export var light_evaluation_words : Array[Enums.AllWords] = []

func _ready():
	words_updated()
	WordCloud.selected_words_changed.connect(words_updated)
	
func words_updated():
	set_light(WordCloud.evaluate_score(light_evaluation_words))

func set_light(pct : float):
	# map between 0.05 -> 1.0
	environment.tonemap_exposure = clamp(pct * 0.95 + 0.05, 0.05, 1.)
