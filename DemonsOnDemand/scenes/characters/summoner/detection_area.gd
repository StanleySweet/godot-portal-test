extends Area3D

@export var interactable_tweening_duration: float = 0.25

var _body_entered_tween: Tween = null
var _body_initial_scale: Vector3
var _body_in_area: Node3D

@export var inventory_node: Node3D

func _on_body_entered(other_body):
	if not other_body is Ingredient and not other_body is Stock and not other_body is Gate and not other_body is Station:
		return
	
	if _body_entered_tween:
		_body_entered_tween.kill()

	if other_body is Station or other_body is Stock or other_body is Gate:
		var is_holding_item: bool = inventory_node and inventory_node.get_child_count() > 0
		var ingredient: Ingredient = null
		if is_holding_item:
			ingredient = inventory_node.get_child(0)
		other_body.start_looking(ingredient)
	else:
		_body_in_area = other_body
		_body_initial_scale = other_body.scale
		var target_scale = Vector3(_body_initial_scale.x + 0.1, _body_initial_scale.y, _body_initial_scale.z)
		_body_entered_tween = create_tween().set_loops() # no parameters = loop infinitely
		if _body_entered_tween:
			_body_entered_tween.tween_property(other_body, "scale", target_scale, interactable_tweening_duration)
			_body_entered_tween.tween_property(other_body, "scale", _body_initial_scale, interactable_tweening_duration)

func _on_body_exited(body):
	if body is Station or body is Stock or body is Gate:
		body.stop_looking()
	elif _body_entered_tween != null:			
		_body_entered_tween.kill()
		_body_entered_tween = create_tween()
		if _body_entered_tween:
			_body_entered_tween.tween_property(_body_in_area, "scale", _body_initial_scale, interactable_tweening_duration)
