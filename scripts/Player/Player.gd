class_name Player
extends Node3D

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var interactor: Interactor = $Head/Camera3D/ModuleInteractor
@onready var mouseInteractor: MouseRayInteractor = $Head/Camera3D/ModuleMouseInteractor
@onready var mousePointer: Label = $CanvasLayer/Label

var isMouseInteraction = false

var is_freezed: bool = false

# Mouse sensitivity
const MOUSE_SENSITIVITY = 0.003

# Vertical rotation limits (in radians)
const MAX_UP_AIM_ANGLE = deg_to_rad(40)  # Looking up limit
const MAX_DOWN_AIM_ANGLE = deg_to_rad(-30)  # Looking down limit


func _ready() -> void:
	disable_mouse_interaction()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and !is_freezed:
		# Rotate head (up/down)
		head.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		# Clamp the vertical rotation
		head.rotation.x = clamp(head.rotation.x, MAX_DOWN_AIM_ANGLE, MAX_UP_AIM_ANGLE)
		# Rotate player (left/right)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)


func enable_mouse_interaction() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouseInteractor.enabled = true
	interactor.enabled = false
	is_freezed = true
	mousePointer.visible = false


func disable_mouse_interaction() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouseInteractor.enabled = false
	interactor.enabled = true
	is_freezed = false
	mousePointer.visible = true
