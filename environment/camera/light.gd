extends WorldEnvironment

@export var light_evaluation_words : Array[Enums.AllWords] = []

var tonemap_target : float = 0.05

func _ready():
	words_updated()
	WordCloud.selected_words_changed.connect(words_updated)
	set_tonemap(tonemap_target)

func _process(delta):
	if environment.tonemap_exposure < tonemap_target:
		environment.tonemap_exposure += delta * 0.2
	elif environment.tonemap_exposure > tonemap_target:
		environment.tonemap_exposure -= delta * 0.2
	
	if abs(environment.tonemap_exposure - tonemap_target) < 0.05:
		environment.tonemap_exposure = tonemap_target

		
func words_updated():
	set_light(WordCloud.evaluate_score(light_evaluation_words))

func set_light(pct : float):
	# map between 0.05 -> 1.0
	tonemap_target = clamp(pct * 0.95 + 0.05, 0.05, 1.)
	
func set_tonemap(pct: float):
	environment.tonemap_exposure = pct
