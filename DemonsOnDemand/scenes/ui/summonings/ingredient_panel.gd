class_name IngredientPanel
extends Panel

@export var sprite: Texture2D
@onready var rect: TextureRect = $TextureRect

func _ready() -> void:
	rect.texture = sprite

func set_sprite(ingredient_sprite: Texture2D) -> void:
	rect.texture = ingredient_sprite
