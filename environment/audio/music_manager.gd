extends Node

@export var track_list: Array[AudioStream]
@export var track_durations: Array[float]
@export var fade_duration: float = 2.0  # seconds for fade in/out
@export var crossfade: bool = true      # if true, next track fades in while previous fades out

var current_index := 0
var next_index := 0
var audio_player_a: AudioStreamPlayer
var audio_player_b: AudioStreamPlayer
var fading := false
var fade_time := 0.0
var active_player: AudioStreamPlayer
var next_player: AudioStreamPlayer


var music_vol_db = -12

func _ready():
	if track_list.is_empty():
		push_warning("No tracks assigned to track_list.")
		return
  
	audio_player_a = AudioStreamPlayer.new()
	audio_player_b = AudioStreamPlayer.new()
	add_child(audio_player_a)
	add_child(audio_player_b)

	active_player = audio_player_a
	next_player = audio_player_b

	play_track(current_index)
	
	Events.play_track.connect(start_specific_track)


func play_track(index: int):
	active_player.stream = track_list[index]
	active_player.volume_db = -80  # start silent
	active_player.play()
	fade_in(active_player)


func fade_in(player: AudioStreamPlayer):
	fading = true
	fade_time = 0.0
	player.volume_db = -80


func _process(delta):
	if not active_player.playing:
		start_next_track()
		return

	if fading:
		fade_time += delta
		var t = fade_time / fade_duration
		active_player.volume_db = lerp(-80, music_vol_db, t)
		if t >= 1.0:
			fading = false

	get_length_of_stream(active_player.stream)

	# When near the end of the current song, start fading to next
	if active_player.get_playback_position() >= get_length_of_stream(active_player.stream) - fade_duration and not next_player.playing:
		if current_index != 0 and current_index != 5:
			start_specific_track(current_index)

func get_length_of_stream(stream: AudioStream):
	var index = track_list.find(stream)
	if track_durations[index] != 0:
		return track_durations[index]
	return stream.get_length()

func start_specific_track(index):
	next_index = index
	next_player.stream = track_list[next_index]
	next_player.volume_db = -80
	next_player.play()

	var a = active_player
	var b = next_player

	await fade_tracks(a, b, fade_duration)

	# swap roles
	active_player.stop()
	var temp = active_player
	active_player = next_player
	next_player = temp
	current_index = next_index
	
func start_next_track():
	next_index = (current_index + 1) % track_list.size()
	next_player.stream = track_list[next_index]
	next_player.volume_db = -80
	next_player.play()

	var a = active_player
	var b = next_player

	await fade_tracks(a, b, fade_duration)

	# swap roles
	active_player.stop()
	var temp = active_player
	active_player = next_player
	next_player = temp
	current_index = next_index


func fade_tracks(out_player: AudioStreamPlayer, in_player: AudioStreamPlayer, duration: float) -> void:
	var t := 0.0
	while t < duration:
		t += get_process_delta_time()
		var pct = clamp(t / duration, 0, 1)
		out_player.volume_db = lerp(music_vol_db, -80, pct)
		in_player.volume_db = lerp(-80, music_vol_db, pct)
		await get_tree().process_frame
