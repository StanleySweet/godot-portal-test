class_name Config extends Node

enum DIFFICULTY { EASY, MEDIUM, HARD }
enum INGREDIENTS { TENTACLE, WING, HORN, HORNS }

@export var available_ingredients : Array[INGREDIENTS] = [INGREDIENTS.HORNS]
@export var lost_point_if_false = -10
@export var lost_point_if_expired = -15
@export var points_gained_if_good = 30

@export var min_duration: int = 50
@export var max_duration: int = 50

@export var max_simultaneous_request = 3
@export var min_temps_between_request = 10
@export var max_temps_between_requests = 20

@export var score_for_first_star = 60
@export var score_for_second_star = 120
@export var score_for_third_star = 200

@export var global_timer_duration = 120
