# Events
# this script is defined as a globally accessible singleton in: Project -> Project Settings -> Globals
extends Node

var selected_words: Array[Enums.AllWords]

signal entered_portal(new_scene_to_load : PackedScene)

signal new_scene_loaded

signal hide_screen(slow: bool)
