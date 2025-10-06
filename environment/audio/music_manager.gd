
extends Node

@export var track_list : Array[Array]

@export var fade_speed : float = 1.5  # seconds per fade
@export var crossfade_speed : float = 0.1  # crossfade speed between tracks

var current_track_name : String = ""
var current_layers : Array[AudioStreamPlayer] = []
var target_volumes : Array[float] = []

# For crossfading
var fading_out_layers : Array[AudioStreamPlayer] = []
var fading_out_volumes : Array[float] = []

var current_index

const max_vol : float = -6

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(true)
	Events.play_track.connect(play_track)
	Events.fade_layer_in.connect(fade_layer_in)


func play_track(index):
	if index == current_index:
		return  # Already playing

	# Move current layers into fading out group
	for player in current_layers:
		fading_out_layers.append(player)
		fading_out_volumes.append(player.volume_db)

	current_layers.clear()
	target_volumes.clear()
	
	current_index = index
	var layers = track_list[index]

	for i in layers.size():
		var player = AudioStreamPlayer.new()
		player.stream = layers[i]
		player.volume_db = -80.0  # start silent
		player.autoplay = false
		add_child(player)
		player.play()
		current_layers.append(player)
		target_volumes.append(-80.0)

	print("Crossfading to track:", name)



func fade_layer_in(layer_index: int):
	if layer_index >= 0 and layer_index < target_volumes.size():
		target_volumes[layer_index] = max_vol  # 0 dB


func fade_layer_out(layer_index: int):
	if layer_index >= 0 and layer_index < target_volumes.size():
		target_volumes[layer_index] = -80.0


func _process(delta):
	# Fade in/out current track layers
	for i in range(current_layers.size()):
		var player = current_layers[i]
		var target = target_volumes[i]
		player.volume_db = lerp(player.volume_db, target, delta * fade_speed)
	
	# Crossfade old track out
	for i in range(fading_out_layers.size() - 1, -1, -1):
		var player = fading_out_layers[i]
		player.volume_db = lerp(player.volume_db, -80.0, delta * crossfade_speed)
		if player.volume_db < -75.0:
			player.queue_free()
			fading_out_layers.remove_at(i)
			fading_out_volumes.remove_at(i)
