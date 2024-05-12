class_name Body extends Ingredient

@export var horn_sprite: Sprite3D
@export var tentacles_sprite: Sprite3D
@export var wings_sprite: Sprite3D
@export var all_parts_sprites : Array[CompressedTexture2D] = []

var have_pointy_horns = false
var have_refined_horns = false
var have_tentacles = false
var have_wings = false
var wings_color = INGREDIENT_COLOR.NONE

func try_assemble(ingredient: Ingredient):
	match ingredient.ingredient_type:
		INGREDIENT_TYPE.REFINED_HORNS, INGREDIENT_TYPE.TENTACLES, INGREDIENT_TYPE.COLORED_WINGS, INGREDIENT_TYPE.POINTY_HORNS:
			return try_add(ingredient)
		_:
			return false

func try_add(ingredient: Ingredient):
	match ingredient.ingredient_type:
		INGREDIENT_TYPE.REFINED_HORNS:
			if have_refined_horns:
				return false
			else:
				horn_sprite.texture = all_parts_sprites[0]
				have_refined_horns = true
				return true
		INGREDIENT_TYPE.POINTY_HORNS:
			if have_pointy_horns:
				return false
			else:
				horn_sprite.texture = all_parts_sprites[1]
				have_pointy_horns = true
				return true
		INGREDIENT_TYPE.TENTACLES:
			if have_tentacles:
				return false
			else:
				tentacles_sprite.texture = all_parts_sprites[2]
				have_tentacles = true
				return true
		INGREDIENT_TYPE.COLORED_WINGS:
			if have_wings:
				return false
			else:
				wings_sprite.texture = all_parts_sprites[2 + int(ingredient.ingredient_color)]
				have_wings = true
				wings_color = ingredient.ingredient_color
				return true

func _on_area_3d_body_entered(obj):
	if obj is Ingredient and not obj is Body and not in_hand and not obj.in_hand:
		var assembled = try_assemble(obj)
		if assembled:
			obj.in_hand = true
			obj.queue_free()
