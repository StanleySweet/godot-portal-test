class_name Stock extends StaticBody3D

signal ingredient_ready

@export var ingredient : PackedScene
@export var interact_hand: Sprite3D
@export var info: Sprite3D

var _animation_player : AnimationPlayer
var _is_animation_running = false

func _ready():
	self._animation_player = self.get_node_or_null("AnimationPlayer")

func get_ingredient():
	if _is_animation_running:
		return
	
	if self._animation_player:
		$Use.play()
		self._animation_player.play("open")
		_is_animation_running = true
	else:
		$Use.play()
		ingredient_ready.emit(ingredient)

func start_looking(_ingredient: Ingredient):
	interact_hand.visible = true
	info.visible = false
	$Approx.play()

func stop_looking():
	interact_hand.visible = false
	info.visible = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "open":
		ingredient_ready.emit(ingredient)
		_is_animation_running = false
		
	print(_animation_player.has_animation("idle"))
	if _animation_player.has_animation("idle"):
		_animation_player.play("idle")
