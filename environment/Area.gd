extends Area3D

@export var MaxAngle : float = 1.0
@onready var player = $"../../../../Player"
@onready var camera = $"../../SubViewport/Cameras/TCAM"

func _on_area_body_entered(body):	
	var angle: float = Vector3.LEFT.angle_to(player.position)
	if angle < self.MaxAngle and body.is_in_group("player"):
		var camera_pos: Vector3 = camera.position - Vector3(0, camera.position.y - body.position.y, 0)
		body.position = camera_pos
