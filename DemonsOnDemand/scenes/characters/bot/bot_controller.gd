class_name BotController extends BaseController

@export_group("Movement")
@export var brain_delay: int = 2
@export var holding_duration: int = 2

@onready var collider: CollisionShape3D = $Collision

var _elapsed_time_brain: float = brain_delay
var _elapsed_time_holding: float = 0
var _direction: Vector3
var _targeted_ingredient: Ingredient
var _in_hand: bool = false

func desactive_bot(new_parent: Node3D):
	hide()
	_stop_character()
	collider.disabled = true
	_in_hand = true
	reparent(new_parent)
	position = Vector3.ZERO
	
func reactivate_bot(direction: Vector3):
	reparent(get_tree().get_root().get_child(0))
	show()
	collider.disabled = false
	_in_hand = false
	position += direction
	_direction = Vector3.ZERO
	_elapsed_time_brain = 0

func _physics_process(_delta):
	if(_in_hand):
		return
	
	_update_bot_direction(_delta)
	
	if _direction:
		_move_character(_direction)
	else:
		_stop_character()
	move_and_slide()
	
	if _holdingIngredient:
		_elapsed_time_holding += _delta
		
		if _elapsed_time_holding > holding_duration:
			_drop_item_from_arms()
			_direction *= -1

func _update_bot_direction(_delta):
	_elapsed_time_brain += _delta
	
	if _elapsed_time_brain >= brain_delay:
		_elapsed_time_brain = 0
		var rng = RandomNumberGenerator.new()
		var orientation: Vector3
		if not _targeted_ingredient:
			orientation = Vector3(rng.randi_range(-1, 1), 0, rng.randi_range(-1, 1))
		else:
			orientation = _targeted_ingredient.position - position
		_direction = (transform.basis * orientation).normalized()

func _on_close_detection_area_body_entered(body_param):
	if not _holdingIngredient and body_param is Ingredient and not body_param.in_hand:
		body_param.deactivate_ingredient(inventory)
		_holdingIngredient = body_param
		_displayArmDependingOnIngredient()
		pickups.pick_random().play()
		_elapsed_time_holding = 0

func _on_far_detection_area_body_entered(body_param):
	if not _in_hand and not _holdingIngredient and body_param is Ingredient and not _targeted_ingredient:
		_targeted_ingredient = body_param

func _on_far_detection_area_body_exited(body_param):
	if not _in_hand and body_param == _targeted_ingredient:
		_targeted_ingredient = null
