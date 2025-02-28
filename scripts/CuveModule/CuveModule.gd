class_name CuveModule
extends ModuleInteractable

@onready var rift_1: StaticBody3D = $"Rifts/Rift_01"
@onready var rift_2: StaticBody3D = $"Rifts/Rift_02"
@onready var rift_3: StaticBody3D = $"Rifts/Rift_03"
@onready var rift_4: StaticBody3D = $"Rifts/Rift_04"

@onready var tape_1: MeshInstance3D = $"Tapes/Tape_01"
@onready var tape_2: MeshInstance3D = $"Tapes/Tape_02"
@onready var tape_3: MeshInstance3D = $"Tapes/Tape_03"
@onready var tape_4: MeshInstance3D = $"Tapes/Tape_04"

@onready var red_light: RedLight = $RedLight

var player_inventory: PlayerInventory

var score: float = 100

signal module_success(is_success: bool)
signal module_score(score: int)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	hide_rift(rift_1)
	hide_rift(rift_2)
	hide_rift(rift_3)
	hide_rift(rift_4)
	player_inventory = get_tree().get_root().get_node("Node3D/Room/Player/CanvasLayer/Inventory")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if not rift_1.visible and not rift_2.visible and not rift_3.visible and not rift_4.visible:
		module_success.emit(true)
	else:
		module_success.emit(false)
		score -= 10 * delta
		score = max(score, 0)
		module_score.emit(floor(score))


func _on_cuve_broken():
	var rng = RandomNumberGenerator.new()
	var id = rng.randi_range(1, 4)
	if id == 1 and (!rift_1.visible or tape_1.visible):
		show_rift(rift_1)
		tape_1.visible = false
		red_light.start_blink()
	elif id == 2 and (!rift_2.visible or tape_2.visible):
		show_rift(rift_2)
		tape_2.visible = false
		red_light.start_blink()
	elif id == 3 and (!rift_3.visible or tape_3.visible):
		show_rift(rift_3)
		tape_3.visible = false
		red_light.start_blink()
	elif id == 4 and (!rift_4.visible or tape_4.visible):
		show_rift(rift_4)
		tape_4.visible = false
		red_light.start_blink()
	elif !rift_1.visible or !rift_2.visible or !rift_3.visible or !rift_4.visible:
		_on_cuve_broken()


func hide_rift(rift: StaticBody3D):
	rift.visible = false
	var collider = rift.get_node("CollisionShape3D")
	collider.disabled = true
	if !rift_1.visible and !rift_2.visible and !rift_3.visible and !rift_4.visible:
		red_light.stop_blink()

func show_rift(rift: StaticBody3D):
	rift.visible = true
	var collider = rift.get_node("CollisionShape3D")
	collider.disabled = false


func _on_rift1_interacted(_body):
	if rift_1.visible and player_inventory.has_item("Gaffer"):
		player_inventory.remove_item("Gaffer")
		hide_rift(rift_1)
		tape_1.visible = true


func _on_rift2_interacted(_body):
	if rift_2.visible and player_inventory.has_item("Gaffer"):
		player_inventory.remove_item("Gaffer")
		hide_rift(rift_2)
		tape_2.visible = true


func _on_rift3_interacted(_body):
	if rift_3.visible and player_inventory.has_item("Gaffer"):
		player_inventory.remove_item("Gaffer")
		hide_rift(rift_3)
		tape_3.visible = true


func _on_rift4_interacted(_body):
	if rift_4.visible and player_inventory.has_item("Gaffer"):
		player_inventory.remove_item("Gaffer")
		hide_rift(rift_4)
		tape_4.visible = true
