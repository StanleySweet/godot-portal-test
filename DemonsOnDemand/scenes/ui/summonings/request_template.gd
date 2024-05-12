class_name RequestTemplate
extends Resource

@export var portal_type: Ingredient.INGREDIENT_COLOR
@export var inner_color: Color
@export var outer_color: Color
@export var horn: Texture2D
@export var horns: Texture2D
@export var tentacle: Texture2D
@export var wing: Texture2D

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_portal_type: Ingredient.INGREDIENT_COLOR = Ingredient.INGREDIENT_COLOR.NONE, p_inner_color = Color.BLACK, p_outer_color = Color.BLACK, p_horn = null, p_horns = null, p_tentacle = null, p_wing = null):
	portal_type = p_portal_type
	inner_color = p_inner_color
	outer_color = p_outer_color
	horn = p_horn
	horns = p_horns
	tentacle = p_tentacle
	wing = p_wing
