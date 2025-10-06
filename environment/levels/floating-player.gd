extends CharacterBody2D


func _ready():
	WordCloud.end_game = true

func _process(_delta):
	velocity.x = 30.
	move_and_slide()
