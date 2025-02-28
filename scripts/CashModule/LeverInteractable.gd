class_name LeverInteractable
extends Interactable

@export var lever: Node3D
@export var pull_duration: float = 0.5
@export var back_duration: float = 1
@export var target_rotation: Vector3
@export var module: CashModule

var initial_lever_rotation_degrees: Vector3
var targeted_lever_rotation_degrees: Vector3
var running: bool = true
var pulling: bool = false
var elapsed: float = 0
var wait_duration: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if wait_duration > 0:
		wait_duration -= delta
	
	if running:
		elapsed += delta
		
		if pulling and elapsed < pull_duration:
			lever.rotation_degrees = lerp(initial_lever_rotation_degrees, targeted_lever_rotation_degrees, elapsed / pull_duration)
		elif pulling and elapsed >= pull_duration:
			pulling = false
			elapsed = 0
			wait_duration = module.start_weels()
			targeted_lever_rotation_degrees = initial_lever_rotation_degrees
			initial_lever_rotation_degrees = lever.rotation_degrees
		elif !pulling && elapsed < back_duration:
			lever.rotation_degrees = lerp(initial_lever_rotation_degrees, targeted_lever_rotation_degrees, elapsed / back_duration)
		elif !pulling && elapsed >= back_duration:
			running = false

func interact(body) -> void:
	if enabled and !running and wait_duration <= 0:
		super.interact(body)
		running = true
		pulling = true
		elapsed = 0
		initial_lever_rotation_degrees = lever.rotation_degrees
		targeted_lever_rotation_degrees = target_rotation
