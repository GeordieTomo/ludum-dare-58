extends Sprite2D
class_name SpriteGlow

@export var fade_speed: float = 2.0      # Speed of the sine wave
@export var intensity_min: float = 1.0   # Minimum brightness (1.0 = normal white)
@export var intensity_max: float = 3.0   # Maximum HDR brightness
@export var base_color: Color = Color(1, 1, 1, 1)  # Base color

@export var _fade_enabled: bool = false
var _time: float = 0.0

func _process(delta: float) -> void:
	if not _fade_enabled:
		return

	_time += delta * fade_speed
	var t = - cos(_time) * 0.5 + 0.5  # oscillates between 0 and 1
	var intensity = lerp(intensity_min, intensity_max, t)
	modulate = base_color * intensity  # HDR modulation!

func enable_glow(enable: bool = true) -> void:
	_fade_enabled = enable
	if not enable:
		modulate = base_color  # Reset when disabled
		_time = 0.
