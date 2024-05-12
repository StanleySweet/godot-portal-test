class_name Station extends Node

signal refinement_ended

@export var type: StationType.STATION_TYPE
@export var allowed_ingredient_type: Ingredient.INGREDIENT_TYPE
@export var timer: TimerBar
@export var isBlockingStation: bool
@export var refined_texture: CompressedTexture2D
@export var color: Ingredient.INGREDIENT_COLOR = Ingredient.INGREDIENT_COLOR.NONE
@export var ingr_type: Ingredient.INGREDIENT_TYPE
@export var WHEN_CHANGING_SOUND = 1.1
@export var interact_hand: Sprite3D
@export var info: Sprite3D

@onready var sounds: Array[AudioStreamPlayer] = [$Sounds/Sound1, $Sounds/Sound2, $Sounds/Sound3]
@onready var ding = $Sounds/Ding

@onready var Particles : CPUParticles3D 
@onready var Splash : CPUParticles3D 

@onready var interact: Sprite3D = $Interact

	
#Wing tweening
var oPos :  Vector3 = Vector3.ZERO
var _wing_tween : Tween = null

var _current_sound: AudioStreamPlayer
var _current_ingredient: Ingredient

var _working = false
const MAX_HEIGHT_WING = 0.6
const MIN_HEIGHT_WING = 0.3

func _ready():
	if allowed_ingredient_type == Ingredient.INGREDIENT_TYPE.WINGS:
		oPos = $Wing.position
		
	if self.get_node_or_null("Splash"):
		self.Splash = self.get_node("Splash")
	else:
		self.Particles = self.get_node("CPUParticles3D")

func start_looking(ingredient: Ingredient):
	if not _working and ingredient and ingredient.ingredient_type == allowed_ingredient_type:
		$Sounds/Approx.play()
		interact_hand.visible = true
		info.visible = false

func stop_looking():
	interact_hand.visible = false
	if not _working:
		info.visible = true

func try_interact(ingredient: Ingredient):
	if ingredient.ingredient_type != allowed_ingredient_type or _working:
		return false

	var duration = ingredient.get_refinement_duration()
	_current_ingredient = ingredient
	timer.set_timer(duration)
	_working = true
	interact_hand.visible = false
	info.visible = false
	match allowed_ingredient_type:
		Ingredient.INGREDIENT_TYPE.WINGS:
			_paint_differently(duration)
		Ingredient.INGREDIENT_TYPE.OCTOPUS:
			_cisel_differently(duration)
		Ingredient.INGREDIENT_TYPE.HORNS:
			_model_differently(duration)
		_:
			_paint_differently(duration)
	return true

func _model_differently(duration):
	WHEN_CHANGING_SOUND = duration - 1.4
	var rng = RandomNumberGenerator.new()
	_current_sound = sounds[rng.randf_range(0, 1)]
	_current_sound.play()
	Particles.set_emitting(true)
	await get_tree().create_timer(WHEN_CHANGING_SOUND).timeout
	_current_sound.stop()
	_current_sound = sounds[2]
	_current_sound.play()

func _cisel_differently(_duration):
	WHEN_CHANGING_SOUND = 0.3
	_current_sound = sounds.pick_random()
	_current_sound.play()
	Particles.set_emitting(true)
	while _working:
		await get_tree().create_timer(WHEN_CHANGING_SOUND).timeout
		_current_sound = sounds.pick_random()
		if _working:
			_current_sound.play()

func _paint_differently(duration):
	_handlePaintAnimation(duration)
	_current_sound = sounds.pick_random()
	_current_sound.play()
	while _working:
		await get_tree().create_timer(WHEN_CHANGING_SOUND).timeout
		_current_sound = sounds.pick_random()
		if _working:
			_current_sound.play()

func _on_refinement_ended():
	_working = false
	info.visible = true
	match allowed_ingredient_type:
		Ingredient.INGREDIENT_TYPE.WINGS:
			_clearPaintAnimation()
		_:
			Particles.set_emitting(false)
	_current_sound.stop()
	ding.play()
	_current_ingredient.refine(refined_texture, ingr_type, color)
	_current_ingredient.reactivate_ingredient(self.basis.z / 2)
	refinement_ended.emit()

func _on_area_3d_body_entered(body):
	if body is Ingredient and not isBlockingStation and not body.sleeping:
		var interactable = try_interact(body)
		if interactable:
			body.deactivate_ingredient(self)
		elif _current_ingredient != body:
			body.apply_impulse(self.basis.z * 4)
	elif body is Ingredient:
		body.apply_impulse(self.basis.z * 4)

func _handlePaintAnimation(_duration):
	$Splash.emitting = true
	_wing_tween = create_tween().set_loops()
	_wing_tween.tween_property($Wing, "position", Vector3(oPos.x,MAX_HEIGHT_WING,oPos.z), 0.6)
	_wing_tween.tween_property($Wing, "position", Vector3(oPos.x,MIN_HEIGHT_WING,oPos.z), 1)

func _clearPaintAnimation():
	$Splash.emitting = false
	$Wing.position = Vector3(oPos.x,MIN_HEIGHT_WING,oPos.z)
	_wing_tween.kill()
