class_name LedModuleLight
extends Interactable

@export var redLight: Node3D
@export var greenLight: Node3D
@export var brokenLight: Node3D

var player_inventory: PlayerInventory

var is_broken: bool = false
var was_green: bool = false  # Track if the light was green before breaking


func _ready():
	super._ready()
	#player_inventory = get_tree().get_root().get_node("Node3D/Room/Player/CanvasLayer/Inventory")
	enabled = false


func turn_on_green_light() -> void:
	if not is_broken:
		redLight.visible = false
		greenLight.visible = true
	was_green = true


func turn_on_red_light() -> void:
	if not is_broken:
		redLight.visible = true
		greenLight.visible = false
	was_green = false


func broke_light() -> void:
	redLight.visible = false
	greenLight.visible = false
	brokenLight.visible = true
	is_broken = true
	enabled = true


func repair_light() -> void:
	brokenLight.visible = false
	is_broken = false
	enabled = false
	# Restore previous state
	if was_green:
		turn_on_green_light()
	else:
		turn_on_red_light()


func interact(_body):
	if self.enabled and is_broken and player_inventory.has_item("Led"):
		player_inventory.remove_item("Led")
		repair_light()
