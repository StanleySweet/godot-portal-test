class_name PlayerCoins
extends Label

const CURRENCY: String = "₴"

var coins: int = 0

func _ready():
	var cash_module = get_tree().get_root().get_node("Node3D/Room/Modules/CashModule")
	cash_module.add_coins.connect(_on_coins_added)
	text = "O%s" % CURRENCY
	
	
func _on_coins_added(amount: int):
	coins += amount
	text = "%s%s" % [coins, CURRENCY]

func pay(amount: int):
	_on_coins_added(-amount)
