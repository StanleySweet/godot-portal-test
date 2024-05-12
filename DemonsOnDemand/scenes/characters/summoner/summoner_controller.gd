class_name SummonerController extends BaseController

@export_group("Sprites")
@export var bot_bag_sprite : CompressedTexture2D

@onready var areaDetect = $DetectionArea as Area3D

var _isBlocked: bool = true
var _holdingBot: BotController
var _last_interacted_stock: Stock = null

func start_everything():
	_isBlocked = false

func stop_everything():
	footsteps.stop()
	_isBlocked = true

func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and not _isBlocked:
		_move_character(direction)
	else:
		_stop_character()
	move_and_slide()

	if Input.is_action_just_pressed("interact") and not _isBlocked:
		var interacted : Array[Node3D] = areaDetect.get_overlapping_bodies() #visionRay.get_collider()
		interacted.sort_custom(func(a,b): return a.global_position.distance_to(position) < b.global_position.distance_to(position))
		var selectObj = _check_and_return(interacted)

		if _holdingIngredient or _holdingBot:
			_interact_while_holding(selectObj)
		else:
			_interact_not_holding(selectObj)

func _check_and_return(interacted):
	if interacted.size() == 0:
		return null
		
	if interacted.size() >= 2:
		var inter1 = interacted[0]
		var inter2 = interacted[1]
		if inter2 is Ingredient && inter1 is Station:
			if global_position.distance_to(inter2.global_position) < 3:
				return inter2
			else:
				return inter1
	
	return interacted[0]

func _interact_while_holding(obj):
	if _holdingBot and not obj:
		_drop_bot()
	elif _holdingBot:
		return
	elif not obj:
		_drop_item_from_arms()
	elif obj is Ingredient and _holdingIngredient is Body:
		var assembled = _holdingIngredient.try_assemble(obj)
		if assembled:
			obj.queue_free()
	elif obj is Body:
		var assembled = obj.try_assemble(_holdingIngredient)
		if assembled:
			_delete_object_from_arms()
		else:
			_drop_item_from_arms()
	elif obj is Ingredient:
		_drop_item_from_arms()
	elif obj is Station:
		var interacted = obj.try_interact(_holdingIngredient)
		if interacted:
			_isBlocked = obj.isBlockingStation
			if obj and not obj.refinement_ended.is_connected(_on_refinement_ended):
				obj.refinement_ended.connect(_on_refinement_ended)
			inventory.get_child(0).reparent(obj)
			_clear_arms()
	elif obj is Gate && _holdingIngredient is Body:
		obj.submit_body(_holdingIngredient)
		_delete_object_from_arms()

func _interact_not_holding(obj):
	if not obj:
		return

	if obj is Ingredient and not obj.in_hand:
		obj.deactivate_ingredient(inventory)
		_holdingIngredient = obj
		_displayArmDependingOnIngredient()
		pickups.pick_random().play()
	elif obj is Stock:
		_last_interacted_stock = obj
		if _last_interacted_stock and not _last_interacted_stock.ingredient_ready.is_connected(_on_stock_ingredient_ready):
			_last_interacted_stock.ingredient_ready.connect(_on_stock_ingredient_ready)
		_last_interacted_stock.get_ingredient()
	elif obj is BotController and not obj._holdingIngredient:
		_holdingBot = obj
		obj.desactive_bot(inventory)
		arms.texture = bot_bag_sprite
		arms.show()

func _drop_bot():
	inventory.get_child(0).reactivate_bot(_previous_direction.normalized() / 2)
	$Drop.play()
	_clear_arms()
	_holdingBot = null

func _on_refinement_ended():
	_isBlocked = false

func _on_stock_ingredient_ready(ingredient: PackedScene):
	var instantiated_ingredient = ingredient.instantiate()
	_last_interacted_stock.add_child(instantiated_ingredient)
	instantiated_ingredient.position += Vector3.UP * 0.5
	instantiated_ingredient.position += Vector3.FORWARD * -0.5
	instantiated_ingredient.reactivate_ingredient(Vector3(0, 2, 1))
	_isBlocked = false
