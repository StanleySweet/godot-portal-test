class_name MouseRayInteractor
extends RayCast3D

@export var interaction_distance := 100.0
@export var prompt: Label
@onready var camera: Camera3D = get_viewport().get_camera_3d()

var current_interactable: Interactable = null

func _ready() -> void:
	prompt.text = ""


func _process(_delta: float) -> void:
	# Update ray position and direction based on mouse
	if camera:
		var mouse_pos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * interaction_distance

		global_position = from
		look_at(to)

	var detected = get_collider() if is_colliding() else null

	# Handle when no longer looking at previous interactable
	if current_interactable != detected:
		if current_interactable != null:
			current_interactable.hide_outline()
		prompt.text = "Back\n[Q]"
		current_interactable = null

	# Handle looking at new interactable
	if detected != null:
		if detected is not CSGCombiner3D and detected is not StaticBody3D and detected is not CharacterBody3D:
			detected.interact()

	if detected is Interactable:
		if current_interactable != detected:
			current_interactable = detected
			prompt.text = detected.get_prompt()
			current_interactable.show_outline()

		# Check for interaction input
		if Input.is_action_just_pressed("interact"):
			current_interactable.interact(owner)
