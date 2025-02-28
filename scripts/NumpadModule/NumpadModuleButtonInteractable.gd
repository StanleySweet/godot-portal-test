class_name NumpadModuleButtonInteractable
extends SimplePressButtonInteractable

signal button_pressed(pad_value: int)

@export var pad_value: int = 1
@onready var label_3d: Label3D = $Label3D

var player_inventory: PlayerInventory
var is_broken: bool = false


func _ready() -> void:
	super._ready()
	prompt_message = "Press Button"
	label_3d.text = str(pad_value)
	#player_inventory = get_tree().get_root().get_node("Node3D/Room/Player/CanvasLayer/Inventory")


func interact(body) -> void:
	if enabled and not is_broken:
		super.interact(body)
		button_pressed.emit(pad_value)
	elif is_broken and player_inventory.has_item("Button_" + str(pad_value)):
		player_inventory.remove_item("Button_" + str(pad_value))
		repair_button()


func broke_button() -> void:
	visible = false
	is_broken = true


func repair_button() -> void:
	visible = true
	is_broken = false
