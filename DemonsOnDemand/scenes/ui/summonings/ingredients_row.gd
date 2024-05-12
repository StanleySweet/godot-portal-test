class_name IngredientsRow
extends HBoxContainer

@onready var tentacle: IngredientPanel = $Tentacle
@onready var wing: IngredientPanel = $Wing
@onready var horn: IngredientPanel = $Horn
@onready var horns: IngredientPanel = $Horns

func set_request_template(request_template: RequestTemplate):
	tentacle.set_sprite(request_template.tentacle)
	wing.set_sprite(request_template.wing)
	horn.set_sprite(request_template.horn)
	horns.set_sprite(request_template.horns)

func set_ingredients(ingredients_to_grab):
	for i in range(0, get_child_count()):
		var panel = get_child(i)
		panel.visible = ingredients_to_grab.find(i) > -1
