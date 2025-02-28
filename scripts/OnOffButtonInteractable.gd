class_name OnOffButtonInteractable
extends Interactable

@export var active_color: Color = Color(0, 1, 0)  # Green
@export var inactive_color: Color = Color(1, 0, 0)  # Red
@export var transition_duration: float = 0.3

@export var mesh: MeshInstance3D

var button_active: bool = false
var material: StandardMaterial3D
var tween: Tween


func _ready() -> void:
	super._ready()
	# Create material for color changes
	material = StandardMaterial3D.new()
	material.albedo_color = inactive_color
	mesh.material_override = material


func toggle_button() -> void:
	button_active = !button_active

	# Cancel existing tween if any
	if tween:
		tween.kill()

	# Create new tween for color transition
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	var target_color = active_color if button_active else inactive_color
	tween.tween_property(material, "albedo_color", target_color, transition_duration)


func interact(body) -> void:
	if enabled:
		toggle_button()
		super.interact(body)
