extends Node

var stage : int = 2

@export var words_to_add : Array[Enums.AllWords]

@export var push_stage_collision_trigger : Area2D




func _ready():
	WordCloud.selected_words_changed.connect(selected_words_changed)
	WordCloud.clear_all_available_words()
	
	await get_tree().create_timer(0.5).timeout
	WordCloud.add_available_word(Enums.AllWords.See)
	WordCloud.add_available_word(Enums.AllWords.Move)
	WordCloud.add_available_word(Enums.AllWords.Push)
	push_stage_collision_trigger.body_entered.connect(push_stage.unbind(1))

func selected_words_changed():
	match(stage):
		0:
			move_stage()
		2:
			end_stage()

func move_stage():
	if WordCloud.check_if_word_is_selected(Enums.AllWords.See):
		stage += 1
		await get_tree().create_timer(1.5).timeout
		WordCloud.add_available_word(Enums.AllWords.Move)

func push_stage():
	if stage == 1:
		stage += 1
		await get_tree().create_timer(1.5).timeout
		WordCloud.add_available_word(Enums.AllWords.Push)

func end_stage():
	if WordCloud.check_if_word_is_selected(Enums.AllWords.Push):
		stage += 1
		await get_tree().create_timer(1.5).timeout
		WordCloud.add_available_words(words_to_add)
