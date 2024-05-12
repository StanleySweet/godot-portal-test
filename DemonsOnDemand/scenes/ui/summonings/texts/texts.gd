class_name Texts
extends Node

var texts: Dictionary
var rng = RandomNumberGenerator.new()

func _ready():
	texts = read_from_JSON("res://DemonsOnDemand/files/texts.json")

func get_random_monster():
	var index = rng.randf_range(0, len(texts["monsters"]))
	return texts["monsters"][index]

func get_random_character():
	var index = rng.randf_range(0, len(texts["characters"]))
	return texts["characters"][index]

func get_random_verb():
	var index = rng.randf_range(0, len(texts["verbs"]))
	return texts["verbs"][index]

func read_from_JSON(path):
	var json = JSON.new()
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var parse_result = json.parse(file.get_as_text())
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", path, " at line ", json.get_error_line())
			return
		return json.get_data()
	else:
		printerr("Invalid path given")
