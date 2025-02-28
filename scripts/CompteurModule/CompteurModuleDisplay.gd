class_name CompteurModuleDisplay
extends Node3D

@export var label: Label3D

var max_value_display: float = 1000.0
var value: float = 0.0

var decrease_speed: float = randf_range(1.0, 3.0)


func _process(delta: float) -> void:
	value = max(0.0, value - decrease_speed * delta)
	label.text = (
		str(
			roundf(
				min(value, max_value_display),
			)
		)
		+ " kW"
	)


func add_value(value_to_add: float) -> void:
	value += value_to_add
