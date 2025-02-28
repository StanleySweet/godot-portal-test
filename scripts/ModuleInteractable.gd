class_name ModuleInteractable
extends Interactable

@export var target_camera_position: Vector3
@export var target_camera_rotation_degrees: Vector3
@export var animation_duration: float = 1

var elapsed: float = 0
var module_running: bool = false
var focused: bool = false
var body: Player = null
var targeted_camera_position: Vector3
var targeted_camera_rotation_degrees: Vector3
var initial_camera_position: Vector3
var initial_camera_rotation_degrees: Vector3

func _ready() -> void:
	super._ready()
	is_module = true
	
func _process(_delta : float) -> void:
	if body != null && elapsed <= animation_duration:
		elapsed += _delta
		body.camera.global_position = lerp(initial_camera_position, targeted_camera_position, elapsed / animation_duration)
		body.camera.global_rotation_degrees = lerp(initial_camera_rotation_degrees, targeted_camera_rotation_degrees, elapsed / animation_duration)
	elif body != null && elapsed > animation_duration and module_running:
		module_running = false
		if !focused:
			body.disable_mouse_interaction()
		
		
	#if Input.is_action_just_pressed("escape") && focused:
		#elapsed = 0
		#targeted_camera_position = body.head.global_position
		#targeted_camera_rotation_degrees = body.head.global_rotation_degrees
		#initial_camera_position = body.camera.global_position
		#initial_camera_rotation_degrees = body.camera.global_rotation_degrees
		#
		#if abs(initial_camera_rotation_degrees.y - targeted_camera_rotation_degrees.y) > 90:
			#initial_camera_rotation_degrees.y += 360
		#
		#focused = false
		#module_running = true

func interact(_body) -> void:
	if enabled:
		super.interact(_body)
		body = _body

		#body.enable_mouse_interaction()
		#elapsed = 0
		#targeted_camera_position = target_camera_position
		#targeted_camera_rotation_degrees = target_camera_rotation_degrees
		#initial_camera_position = body.head.global_position
		#initial_camera_rotation_degrees = body.head.global_rotation_degrees
		#
		#if abs(initial_camera_rotation_degrees.y - targeted_camera_rotation_degrees.y) > 90:
			#initial_camera_rotation_degrees.y += 360
			#
		focused = true
		module_running = true
