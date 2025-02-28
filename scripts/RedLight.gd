class_name RedLight
extends Node3D

@onready var light: OmniLight3D = $OmniLight3D
@onready var mesh: MeshInstance3D = $MeshInstance3D
@export var max_intensity: float = 5
@export var speed: float = 6
@export var current_material: StandardMaterial3D

var running: bool = false
var direction: int = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if running:
		light.light_energy += delta * speed * direction / 2
		current_material.emission_energy_multiplier += delta * speed * direction
		
		if light.light_energy < 0 or light.light_energy > max_intensity:
			direction = -direction

func start_blink():
	running = true
	direction = 1
	
func stop_blink():
	running = false
	light.light_energy = 0
	current_material.emission_energy_multiplier = 0
