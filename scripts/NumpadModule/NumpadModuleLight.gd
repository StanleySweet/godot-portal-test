class_name NumpadModuleLight
extends Node3D

@export var redLight: Node3D
@export var greenLight: Node3D


func turn_on_green_light() -> void:
	redLight.visible = false
	greenLight.visible = true


func turn_on_red_light() -> void:
	redLight.visible = true
	greenLight.visible = false
