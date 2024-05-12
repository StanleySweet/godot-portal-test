class_name Portal
extends Node3D

@onready var portal: MeshInstance3D = $MeshInstance3D

func set_portal_color(color: Color) -> void:
	var material = portal.material_override.duplicate()
	material.set_shader_parameter("PortalColor", color)
	portal.material_override = material
