class_name Parcel
extends Interactable

@onready var collider = $CollisionShape3D

var items: Array[String] = []
var player_inventory: PlayerInventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	visible = false
	collider.disabled = true
	#player_inventory = get_tree().get_root().get_node("Node3D/Room/Player/CanvasLayer/Inventory")


func interact(body):
	super.interact(body)
	
	while player_inventory.can_get_item() and items.size() > 0:
		var item = items[0]
		player_inventory.add_item(item)
		items.remove_at(0)
	print(items.size())
	if items.size() == 0:
		visible = false
		collider.disabled = true

func _on_item_ordered(item: String):
	items.append(item)
	visible = true
	collider.disabled = false
