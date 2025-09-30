# TweenCustom
# this script is defined as a globally accessible singleton in: Project -> Project Settings -> Globals
extends Node

# dictionary to track currently animating objects
var currently_shaking = {}

func animate_to_position(object, new_position, duration):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	await tween.tween_property(object, "position", new_position, duration).finished

func animate_to_scale(object, new_scale, duration):
	if not object:
		return
	if new_scale is float:
		new_scale = Vector2(new_scale,new_scale)
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	await tween.tween_property(object, "scale", new_scale, duration).finished

func animate_to_alpha(object, new_alpha, duration):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(object, "modulate:a", new_alpha, duration)
	return tween

func animate_to_alpha_wait(object, new_alpha, duration):
	var tween = get_tree().create_tween()
	#tween.set_ease(Tween.EASE_IN_OUT)
	#tween.set_trans(Tween.TRANS_QUINT)
	await tween.tween_property(object, "modulate:a", new_alpha, duration).finished

func animate_to_colour(object, new_colour, duration):
	var tween = get_tree().create_tween()
	await tween.tween_property(object, "modulate", new_colour, duration).finished

func screen_shake(duration: float = 0.1):
	shake(Camera, 5., duration)

func shake(object, strength: float, duration: float = 0.2) -> void:
	if not object:
		return
	if currently_shaking.has(object):
		return
	currently_shaking[object] = true
	var prev_target : Vector2 = Vector2.ZERO
	var timer = get_tree().create_timer(duration)
	var init_rot = object.rotation
	while timer.time_left > 0. and object:
		var shake_offset := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		var target : Vector2 = strength * shake_offset
		
		object.rotation = init_rot+ 0.1 * sin(timer.time_left * 100.)
		object.position += target - prev_target
		await get_tree().create_timer(0.01).timeout
		prev_target = target

	if not object:
		return
	currently_shaking.erase(object)
	object.rotation = init_rot
	object.position -= prev_target
