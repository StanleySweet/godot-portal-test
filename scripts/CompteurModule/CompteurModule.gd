class_name CompteurModule
extends Node3D

@export var list_of_displays: Array[CompteurModuleDisplay]

signal module_success(is_success: bool)


func _ready() -> void:
	reset()


func _process(_delta: float) -> void:
	if list_of_displays.all(
		func(display: CompteurModuleDisplay): return display.value >= display.max_value_display
	):
		module_success.emit(true)
	else:
		module_success.emit(false)


func on_button_pressed(compteur_number: int, energy_value: float) -> void:
	list_of_displays[compteur_number - 1].add_value(energy_value)


func reset() -> void:
	for display in list_of_displays:
		display.value = randf_range(0.0, display.max_value_display)
