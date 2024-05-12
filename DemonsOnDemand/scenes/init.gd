extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var configRes = preload("res://DemonsOnDemand/scenes/ui/config.tscn")
	var config = configRes.instantiate()
	add_child(config)
