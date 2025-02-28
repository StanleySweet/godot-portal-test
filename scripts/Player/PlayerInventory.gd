class_name PlayerInventory
extends Node

@onready var slot1_rect: TextureRect = $BoxContainer/Slot1
@onready var slot2_rect: TextureRect = $BoxContainer/Slot2
@onready var slot3_rect: TextureRect = $BoxContainer/Slot3
@onready var slot4_rect: TextureRect = $BoxContainer/Slot4
@export var items_names: Array[String]
@export var items_icons: Array[Texture2D]

var slot1_item: String = ""
var slot2_item: String = ""
var slot3_item: String = ""
var slot4_item: String = ""


func add_item(item: String):
	var id = items_names.find(item, 0)
	show_item(item, items_icons[id])

func show_item(item_name: String, icon: Texture2D) -> bool:
	if slot1_item == "":
		slot1_item = item_name
		slot1_rect.texture = icon
		return true
	elif slot2_item == "":
		slot2_item = item_name
		slot2_rect.texture = icon
		return true
	elif slot3_item == "":
		slot3_item = item_name
		slot3_rect.texture = icon
		return true
	elif slot4_item == "":
		slot4_item = item_name
		slot4_rect.texture = icon
		return true
	return false


func has_item(item_name: String) -> bool:
	return slot1_item == item_name || slot2_item == item_name || slot3_item == item_name || slot4_item == item_name


func remove_item(item_name: String):
	if slot1_item == item_name:
		slot1_item = ""
		slot1_rect.texture = null
	elif slot2_item == item_name:
		slot2_item = ""
		slot2_rect.texture = null
	elif slot3_item == item_name:
		slot3_item = ""
		slot3_rect.texture = null
	elif slot4_item == item_name:
		slot4_item = ""
		slot4_rect.texture = null
	reorganise_slots()


func reorganise_slots():
	if slot1_item == "" and slot2_item != "":
		slot1_item = slot2_item
		slot2_item = ""
		slot1_rect.texture = slot2_rect.texture
		slot2_rect.texture = null
		reorganise_slots()
	elif slot2_item == "" and slot3_item != "":
		slot2_item = slot3_item
		slot3_item = ""
		slot2_rect.texture = slot3_rect.texture
		slot3_rect.texture = null
		reorganise_slots()
	elif slot3_item == "" and slot4_item != "":
		slot3_item = slot4_item
		slot4_item = ""
		slot3_rect.texture = slot4_rect.texture
		slot4_rect.texture = null
		reorganise_slots()

func can_get_item() -> bool:
	return slot1_item == "" or slot2_item == "" or slot3_item == "" or slot4_item == ""
