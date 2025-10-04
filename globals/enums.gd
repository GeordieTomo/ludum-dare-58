extends Node

enum AllWords {
	Move,
	Push,
	Light,
	Precise,
	Strong,
	Steady,
	Fast
}

func get_string_from_enum(word : AllWords) -> String:
	return str(AllWords.keys()[word])
