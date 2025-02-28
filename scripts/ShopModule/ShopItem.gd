class_name ShopItem
extends BoxContainer

signal buy_pressed(item: String, price: int)

var current_item: String
var current_price: int

func init(item: String, price: int, texture: Texture2D):
	current_item = item
	current_price = price
	get_node("Image").texture = texture
	get_node("Description").text = "%s for sale %s₴" % [item, price]
	get_node("Button").pressed.connect(_on_button_pressed)
	
func _on_button_pressed():
	buy_pressed.emit(current_item, current_price)
	get_node("Button").release_focus()
