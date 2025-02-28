class_name SimplePressButtonInteractable
extends Interactable

@export var active_color: Color = Color(0, 1, 0)  # Green
@export var inactive_color: Color = Color(1, 0, 0)  # Red
@export var transition_duration: float = 0.1

@export var mesh: MeshInstance3D

var material: StandardMaterial3D
var tween: Tween


func _ready() -> void:
	super._ready()
	# Create material for color changes
	var currentMat = mesh.get_active_material(0)
	if currentMat != null:
		material = currentMat.duplicate()
	else:
		material = StandardMaterial3D.new()
	material.albedo_color = inactive_color
	mesh.material_override = material


func press_button() -> void:
	# Cancel existing tween if any
	if tween:
		tween.kill()

	# Create new tween for color transition
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(material, "albedo_color", active_color, transition_duration)
	# Wait for transition duration
	await get_tree().create_timer(transition_duration).timeout

	# Transition back to inactive color
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(material, "albedo_color", inactive_color, transition_duration)


func interact(body) -> void:
	if enabled:
		super.interact(body)
		press_button()
