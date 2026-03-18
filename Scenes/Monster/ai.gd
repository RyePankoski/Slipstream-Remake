extends Node

enum States { PASSIVE, HOSTILE, INACTIVE }
enum Behavior_Set { WANDERING, HUNTING, CHASING, FLEEING, LAYING_TRAP }

@export var state = States.PASSIVE
@export var behavior = Behavior_Set.WANDERING

var behaviors: Node

var wander_timer: float = 0.0
var wander_path_timer: float = 0.0    # Counts up while following a wander path
var wander_path_timeout: float = 0.0  # Max time before the path is considered stuck

var ronald: CharacterBody2D
var pathfinder: Node
var movement: Node
var senses: Node
var request_queue: Array
var debug_timer: float = 0.0

signal state_changed(new_value)
signal behavior_changed(new_value)

func _ready():
	ronald = get_tree().root.get_node("Main/Ronald")
	pathfinder = ronald.get_node("Brain/A*")
	movement = ronald.get_node("Brain/Movement")
	senses = ronald.get_node("Brain/Senses")
	behaviors = ronald.get_node("Brain/Behaviors")
	
	request(States.PASSIVE)
	
	_emit_signals()
	
func _process(delta):
	_debug_prints(delta)
	_handle_behavior(delta)
	if not request_queue.is_empty():
		handle_request(request_queue.front())
		
func _handle_behavior(delta):
	match behavior:
		Behavior_Set.WANDERING:
			behaviors.update_wander(delta)
		Behavior_Set.HUNTING:
			behaviors.update_hunt(delta)
	
func request(director_request):
	request_queue.append(director_request)
	
func handle_request(req):	
	
	if req == States.HOSTILE:
		if behavior == Behavior_Set.WANDERING:
			behavior = Behavior_Set.HUNTING
			behaviors.enter_hunt()
		if behavior == Behavior_Set.CHASING:
			behavior = Behavior_Set.FLEEING
			behaviors.enter_flee()
	
	if req == States.PASSIVE:
		if behavior == Behavior_Set.CHASING:
			behavior = Behavior_Set.FLEEING
			behaviors.enter_flee()
		if behavior == Behavior_Set.HUNTING:
			behavior = Behavior_Set.WANDERING
			behaviors.enter_wander()
		
	state = req
	movement.abandon_path()
	request_queue.pop_front()
	_emit_signals()	
	
	
func _debug_prints(delta):
	debug_timer += delta
	if debug_timer >= 10.0:
		debug_timer = 0.0
		#print("My state is: ", States.keys()[state], " My behavior is: ", Behavior_Set.keys()[behavior])
		
func _emit_signals():
	state_changed.emit(States.keys()[state])
	behavior_changed.emit(Behavior_Set.keys()[behavior])
	

	
