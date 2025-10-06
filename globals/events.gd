# Events
# this script is defined as a globally accessible singleton in: Project -> Project Settings -> Globals
extends Node

var selected_words: Array[Enums.AllWords]

var fade_time_scale = 1.

signal entered_portal(new_scene_to_load : PackedScene)

signal new_scene_loaded

signal hide_screen(slow: bool)

signal play_track(index: int)
