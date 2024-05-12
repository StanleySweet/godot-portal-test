extends Control
@onready var texts: Texts = $Texts
@onready var requests_container: BoxContainer = $Panel/CenterContainer/RequestsContainer

var rng = RandomNumberGenerator.new()

var config : Config = null
var scoreManager : Node = null

func  _ready():
	_retrieve_score_manager()
	config = get_tree().get_first_node_in_group("Config")
	if config == null:
		printerr("No Config found. Please add a config node to the scene and add it to the config group.")
	scoreManager.connect("spawn_requested", spawn_new_request)

# func spawn_request() -> void:
#	var request_spawned: bool = false
#	while not request_spawned:
#		var portalIndex = randi() % requests_container.get_child_count()
#		var portal: RequestPanel = requests_container.get_child(portalIndex)
#		generate_random_request(portal)
#		request_spawned = true

# Can be used to add an additional portal dynamically
func spawn_new_request() -> void:
	var portalIndex = randi() % requests_container.get_child_count()
	var portalTemplate: RequestPanel = requests_container.get_child(portalIndex)
	var request_panel = preload("res://DemonsOnDemand/scenes/ui/summonings/request_panel.tscn").instantiate()
	request_panel.request = portalTemplate.request.duplicate(true)
	requests_container.add_child(request_panel)
	generate_random_request(request_panel)

func generate_random_request(request_panel: RequestPanel) -> void:
	var character = texts.get_random_character()
	var verb = texts.get_random_verb()
	var monster = texts.get_random_monster()

	var first_line = str(character, " ", verb, " ", monster.name)
	var second_line = monster.line
	var duration = randi_range(config.min_duration, config.max_duration)
	request_panel.set_values(first_line, second_line, duration)
	request_panel.activate(config.available_ingredients)

func _retrieve_score_manager():
	scoreManager = get_tree().get_first_node_in_group("ScoreManager")
	if scoreManager == null:
		printerr("No scoreManager found. Please add a scoreManager node to the scene and add it to the ScoreManager group.")
