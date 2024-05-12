class_name Ingredient extends RigidBody3D

@export var ingredient_type: INGREDIENT_TYPE
@export var refinement_duration: float

@onready var collision : CollisionShape3D = $Collision
@onready var sprite : Sprite3D = $Sprite3D

var ingredient_color: INGREDIENT_COLOR
var timer : Timer
var in_hand: bool = false

const TIME_BEFORE_DETECT_AGAINT = 0.8

enum INGREDIENT_TYPE
{
	BODY,
	HORNS,
	REFINED_HORNS,
	POINTY_HORNS,
	OCTOPUS,
	TENTACLES,
	WINGS,
	COLORED_WINGS
}

enum INGREDIENT_COLOR
{
	NONE,
	BLUE,
	GREEN,
	YELLOW,
	RED
}

func deactivate_ingredient(new_parent: Node3D):
	reparent(new_parent)
	sleeping = true
	in_hand = true
	gravity_scale = 0
	hide()
	position = Vector3.UP * 0.3
	if collision:
		collision.set_deferred("disabled", true)
		


func reactivate_ingredient(direction: Vector3):
	reparent(get_tree().get_root().get_child(0))
	show()
	_deactivate_temp_obj_detection()
	collision.set_deferred("disabled",false)
	sleeping = false
	in_hand = false
	gravity_scale = 1
	apply_impulse(direction)

func _deactivate_temp_obj_detection():
	# We force the deactivation of the  area layer detection
	set_collision_layer_value(4, false)
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.autostart = false
	timer.set_wait_time(TIME_BEFORE_DETECT_AGAINT)
	timer.timeout.connect(_reactivate_object_detection)
	timer.start()

func _reactivate_object_detection():
	set_collision_layer_value(4, true)
	if timer:
		timer.queue_free()

func get_refinement_duration():
	return refinement_duration

func refine(refined_sprite, type, color: INGREDIENT_COLOR):
	ingredient_type = type
	if ingredient_type == INGREDIENT_TYPE.COLORED_WINGS:
		ingredient_color = color
	sprite.texture = refined_sprite
