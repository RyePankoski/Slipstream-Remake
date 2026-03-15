extends Node

enum State { INACTIVE, HUNTING }
enum Behavior { WANDERING, HUNTING, CHASING, FLEEING, LAYING_TRAP }

@export var state = State.INACTIVE
@export var menace_radius: float = 1500.0
@export var hunt_threshold: float = 10.0
@export var menace_threshold: float = 50.0


var wander_timer: float = 0.0
var wander_path_timer: float = 0.0    # Counts up while following a wander path
var wander_path_timeout: float = 0.0  # Max time before the path is considered stuck

var ronald: CharacterBody2D
var pathfinder: Node
var movement: Node
var senses: Node
var request_queue: Array

func _ready():
	ronald = get_tree().root.get_node("Main/Ronald")
	pathfinder = ronald.get_node("Brain/A*")
	movement = ronald.get_node("Brain/Movement")
	senses = ronald.get_node("Brain/Senses")

func _process(delta):
	if not request_queue.is_empty():
		handle_request(request_queue.pop_front())
		
	
func handle_request(req):
	pass
	
func request(director_request):
	request_queue.append(director_request)
	
