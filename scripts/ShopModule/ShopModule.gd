extends ModuleInteractable

@export var shop_items: Array[String] = []
@export var shop_items_textures: Array[Texture2D] = []
@export var shop_items_prices: Array[int] = []
@onready var items_container = $glass/SubViewport/PCUI/Control/Container/ScrollContainer/VBoxContainer
@onready var item_prefab = preload("res://scenes/shop/pc_item.tscn")

@export var expense_ok: AudioStreamPlayer
@export var expense_not_ok: AudioStreamPlayer

signal order_item(item: String)

var player_coins: PlayerCoins

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	player_coins = get_tree().get_root().get_node("Node3D/Room/Player/CanvasLayer/Coins")
	
	for i in shop_items.size():
		var item_name = shop_items[i]
		var texture = shop_items_textures[i]
		var price = shop_items_prices[i]
		var item: ShopItem = item_prefab.instantiate()
		item.init(item_name, price, texture)
		
		item.buy_pressed.connect(_on_command_passed)
		items_container.add_child(item)

func _on_command_passed(item: String, price: int):
	if player_coins.coins >= price:
		expense_ok.play()
		player_coins.pay(price)
		order_item.emit(item)
	else:
		expense_not_ok.play()
