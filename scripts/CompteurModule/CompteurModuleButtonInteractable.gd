class_name CompteurModuleButtonInteractable
extends SimplePressButtonInteractable

signal button_pressed(compteur_number: int, energy_value: float)

@export var compteur_number: int = 1
@export var base_energy: float = 1.0


func _ready() -> void:
	super._ready()
	prompt_message = "Press Button"


func interact(body) -> void:
	if enabled:
		super.interact(body)
		button_pressed.emit(compteur_number, randf_range(base_energy, base_energy * 2))
