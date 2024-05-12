class_name Gate
extends StaticBody3D

@export var request_template: RequestTemplate
@export var interact_hand: Sprite3D

@onready var portal: Portal = $Portal
var scoreManager : Node = null
@onready var bolt : CPUParticles3D = $Bolt
var is_active : bool = false
var timer : Timer
func _ready() -> void:
	_retrieve_score_manager()
	if request_template:
		portal.set_portal_color(request_template.inner_color)
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1
	timer.connect("timeout", _timeout)
	timer.start()

	
func start_looking(ingredient: Ingredient):
	if ingredient and ingredient is Body:
		interact_hand.visible = true
		$Approx.play()

func stop_looking():
	interact_hand.visible = false
	
func submit_body(body):
	$Use.play()
	print("submit")
	scoreManager.submit_monster(self, body)
	bolt.emitting = true;
	timer.start()
	


func _timeout():
	bolt.emitting = false;


func _on_area_3d_body_entered(body):
	if body is Body:
		submit_body(body)
	elif body is Ingredient:
		body.apply_impulse(body.linear_velocity * -2)

func _retrieve_score_manager():
	scoreManager = get_tree().get_first_node_in_group("ScoreManager")
	if scoreManager == null:
		printerr("No scoreManager found. Please add a scoreManager node to the scene and add it to the ScoreManager group.")
