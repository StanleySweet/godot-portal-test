extends Area3D

@export var env : WorldEnvironment
@export var sun : DirectionalLight3D

var backup

func _on_area_body_entered(body) -> void:
	if body.is_in_group("player"):
		self.backup = env.environment
		env.environment = null
		sun.hide()


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		env.environment = self.backup
		self.backup = null
		sun.show()
