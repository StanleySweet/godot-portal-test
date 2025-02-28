extends Node

signal spawn_requested

var _active_requests: Array[RequestPanel] = []

var endGamePanel: Panel = null
var globalTimer: CustomTimer = null

var timer: float = 0
var beforeNextRequest = 2
var current_score: int = 0

var config : Config = null
var isStopped : bool = true

func  _ready():
	_retrieveTimerAndPanel()
	if globalTimer:
		globalTimer.connect("timer_elapsed", _endGame)
		config = get_tree().get_first_node_in_group("Config")
		if config == null:
			printerr("No Config found. Please add a config node to the scene and add it to the config group.")

func setIsStopped(newValue):
	isStopped = newValue

func _endGame():
	isStopped = true
	var ambient = get_tree().get_first_node_in_group("Ambiant")
	if ambient:
		ambient.stop()
	for requests in _active_requests:
		requests.timer.is_enabled = false
		requests.queue_free()

	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.stop_everything()
	
	var nbr_stars = 0
	if current_score >= config.score_for_first_star:
		nbr_stars += 1
	if current_score >= config.score_for_second_star:
		nbr_stars += 1	
	if current_score >= config.score_for_third_star:
		nbr_stars += 1
	
	endGamePanel.activate_end_screen(current_score, nbr_stars)

func _retrieveTimerAndPanel():
	endGamePanel = get_tree().get_first_node_in_group("EndGame")
	if endGamePanel == null:
		printerr("No endgamepanel found. Please add an endgamepanel node to the scene and add it to the EndGame group.")
	globalTimer = get_tree().get_first_node_in_group("GlobalTimer")
	if globalTimer == null:
		printerr("No globalTimer found. Please add an globalTimer node to the scene and add it to the GlobalTimer group.")
	pass


func _process(delta: float) -> void:
	if isStopped:
		return
	timer += delta
	if timer >= beforeNextRequest && _active_requests.size() < config.max_simultaneous_request:
		spawn_requested.emit()
		timer = 0
		var rng = RandomNumberGenerator.new()
		beforeNextRequest = rng.randf_range(config.min_temps_between_request, config.max_temps_between_requests)

func track_request(request_panel: RequestPanel) -> void:
	_active_requests.append(request_panel)

func handle_request_unfinished(request_panel: RequestPanel) -> void:
	var idx = _active_requests.find(request_panel)
	if idx > -1:
		_active_requests.pop_at(idx)
		request_panel.timer.is_enabled = false
		request_panel.is_enabled = false
		request_panel.queue_free()
		_update_points(config.lost_point_if_expired)

func submit_monster(gate: Gate, body: Body) -> void:
	var validated : bool = false
	var index: int = -1
	for i in range(0, _active_requests.size()):
		var actualRequest = _active_requests[i]
		if actualRequest.request.portal_type != gate.request_template.portal_type:
			continue

		validated = _check_request_validity(gate, _active_requests[i], body)
		if validated:
			index = i
			break

	if validated:
		print("Request Matched")
		_active_requests[index].finish()
		var request_panel = _active_requests.pop_at(index)
		request_panel.timer.is_enabled = false
		request_panel.is_enabled = false
		request_panel.queue_free()
		var size = request_panel.ingredients_to_grab.size()
		var points = config.points_gained_if_good
		_update_points(points * size + (points * (size - 1)) / 2)
	else:
		_update_points(config.lost_point_if_false)
		print("Request Unmatched")
	# animate the death
	body.queue_free()

func _check_request_validity(gate, matching_request, body) -> bool:
	var gate_ingredients = gate.request_template
	var is_correct: bool = true
	
	# Check for bad ingredients
	if body.have_wings and not matching_request.ingredients_to_grab.has(Config.INGREDIENTS.WING):
		return false
	if body.have_tentacles and not matching_request.ingredients_to_grab.has(Config.INGREDIENTS.TENTACLE):
		return false
	if body.have_pointy_horns and not matching_request.ingredients_to_grab.has(Config.INGREDIENTS.HORN):
		return false
	if body.have_refined_horns and not matching_request.ingredients_to_grab.has(Config.INGREDIENTS.HORNS):
		return false
	# Check for good ingredients
	for ingredient in matching_request.ingredients_to_grab:
		match ingredient:
			Config.INGREDIENTS.TENTACLE:
				is_correct = is_correct && body.have_tentacles
			Config.INGREDIENTS.WING:
				is_correct = is_correct && body.have_wings && body.wings_color == gate_ingredients.portal_type
			Config.INGREDIENTS.HORN:
				is_correct = is_correct && body.have_pointy_horns
			Config.INGREDIENTS.HORNS:
				is_correct = is_correct && body.have_refined_horns
	return is_correct

func _update_points(points_amount: int) -> void:
	current_score += points_amount

func is_request_active(request_panel: RequestPanel) -> bool:
	return _active_requests.find(request_panel) > -1
