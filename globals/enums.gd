extends Node

enum AllWords {
	Move,
	Push,
	See,
	Steady,
	Strong,
	Fast,
	Grab,
	Throw,
	Jump,
	Talk
}

func get_string_from_enum(word : AllWords) -> String:
	return str(AllWords.keys()[word])
