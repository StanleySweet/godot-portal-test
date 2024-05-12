extends Panel

var player = null;
var scoreManager = null;
var globalTimer = null;

func _ready():
	_retrieve_score_and_player()
	if scoreManager:
		scoreManager.setIsStopped(true)
	if player:
		player.stop_everything()
	if globalTimer:
		globalTimer.is_paused = true

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		if scoreManager:
			scoreManager.setIsStopped(false)
		if player:
			player.start_everything()
		if globalTimer:
			globalTimer.is_paused = false

		self.visible = false
		queue_free()
		
func _retrieve_score_and_player():
	scoreManager = get_tree().get_first_node_in_group("ScoreManager")
	player = get_tree().get_first_node_in_group("Player")
	globalTimer = get_tree().get_first_node_in_group("GlobalTimer")
