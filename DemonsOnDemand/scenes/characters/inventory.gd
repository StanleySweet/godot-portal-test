extends Node3D

@export var allArmsSprites : Array[CompressedTexture2D] = []

func ReturnProperSprite(ingredient: Ingredient):
	match ingredient.ingredient_type:
		Ingredient.INGREDIENT_TYPE.HORNS:
			return allArmsSprites[0]
		Ingredient.INGREDIENT_TYPE.REFINED_HORNS:
			return allArmsSprites[1]
		Ingredient.INGREDIENT_TYPE.POINTY_HORNS:
			return allArmsSprites[2]
		Ingredient.INGREDIENT_TYPE.OCTOPUS:
			return allArmsSprites[3]
		Ingredient.INGREDIENT_TYPE.TENTACLES:
			return allArmsSprites[4]
		Ingredient.INGREDIENT_TYPE.WINGS:
			return allArmsSprites[5]
		Ingredient.INGREDIENT_TYPE.COLORED_WINGS:
			return allArmsSprites[5 + int(ingredient.ingredient_color)]
		Ingredient.INGREDIENT_TYPE.BODY:
			return allArmsSprites[10]
		_:
			return null
