extends Area3D

@export var environment: Node

@onready var collision_polygon: CollisionPolygon3D = $CollisionPolygon3D

var _cam: Camera3D
var _player: SummonerController
var _following = true
var _cam_offset: Vector3

func _ready():
	_cam = environment.get_child(1)
	
func _process(delta):
	if _following:
		return
	
	var direction = (position - _player.position).normalized()
	var new_position = _cam.position 
	var bottom_left = collision_polygon.polygon[0]
	var up_right = collision_polygon.polygon[2]
	
	print(direction)
	if(_player.position.x > up_right.x or _player.position.x < bottom_left.x):
		new_position.z = _player.position.z + _cam_offset.z
	if(_player.position.z > up_right.y or _player.position.z < bottom_left.y):
		new_position.x = _player.position.x + _cam_offset.x
	
	_cam.position = new_position

func _on_body_exited(body):
	if body is SummonerController:
		_following = false

func _on_body_entered(body):
	_following = true
