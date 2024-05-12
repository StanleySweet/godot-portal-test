class_name BaseController extends CharacterBody3D

@export_group("Movement")
@export var speed: float = 3
@export var launch_force: int = 3

@export_group("Animation")
@export var idle_animation_speed: float = 1
@export var moving_animation_speed: float = 3

@export_group("Sprites")
@export var heads: Dictionary = { }
@export var bodies: Dictionary = { }

@onready var head: Sprite3D = $Graphics/Head
@onready var body: Sprite3D = $Graphics/Body
@onready var arms = $Graphics/Arms as Sprite3D
@onready var footsteps: AudioStreamPlayer = $Footsteps
@onready var inventory : Node3D = $Inventory
@onready var head_animation_player: AnimationPlayer = $HeadAnimationPlayer
@onready var body_animation_player: AnimationPlayer = $BodyAnimationPlayer
@onready var pickups: Array[AudioStreamPlayer] = [$"Pick-Ups/Pi1", $"Pick-Ups/PI2", $"Pick-Ups/Pi3"]

enum FACING_DIRECTION { LEFT, RIGHT }

var _holdingIngredient : Ingredient = null
var _previous_direction: Vector3
var _character_direction: FACING_DIRECTION = FACING_DIRECTION.LEFT


func _ready():
	arms.hide()
	if heads == null or bodies == null:
		print("Missing sprites for character player")

func _process(_delta):
	head.texture = heads[_character_direction]
	body.texture = bodies[_character_direction]

func _move_character(direction: Vector3):
	if not footsteps.playing:
		footsteps.play()

	_previous_direction = direction
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	head_animation_player.speed_scale = moving_animation_speed
	body_animation_player.speed_scale = moving_animation_speed
	if velocity.x > 0:
		_character_direction = FACING_DIRECTION.RIGHT
		arms.rotation.y = PI
		body_animation_player.stop()
		body_animation_player.play("body_animation_right")
	else:
		_character_direction = FACING_DIRECTION.LEFT
		arms.rotation.y = 0
		body_animation_player.stop()
		body_animation_player.play("body_animation_left")

func _stop_character():
	velocity.x = move_toward(velocity.x, 0, speed)
	velocity.z = move_toward(velocity.z, 0, speed)
	head_animation_player.speed_scale = idle_animation_speed
	body_animation_player.speed_scale = 0
	if velocity.x == 0 and velocity.z == 0:
		footsteps.stop()

func _drop_item_from_arms():
	inventory.get_child(0).reactivate_ingredient((_previous_direction + Vector3.UP) * launch_force)
	$Drop.play()
	_clear_arms()

func _delete_object_from_arms():
	inventory.get_child(0).queue_free()
	_clear_arms()

func _clear_arms():
	_holdingIngredient = null
	_displayArmDependingOnIngredient()

func _displayArmDependingOnIngredient():
	arms.hide()
	if _holdingIngredient == null:
		return
	arms.texture = inventory.ReturnProperSprite(_holdingIngredient)
	arms.show()
