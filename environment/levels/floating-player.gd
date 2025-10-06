extends CharacterBody2D


func _ready():
	WordCloud.end_game = true

func _process(delta):
	velocity.x = 30.
	rotation += delta * 0.2
	scale = scale.lerp(Vector2.ZERO, delta * 0.01)
	move_and_slide()
