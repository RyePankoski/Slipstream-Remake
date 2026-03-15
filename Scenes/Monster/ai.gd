extends Node

enum State { INACTIVE, HUNTING, CHASING, FLEEING }
var state = State.INACTIVE

@export var menace_radius: float = 1500.0
@export var flee_distance: float = 5000.0
@export var wander_interval: float = 10.0
@export var hunt_threshold: float = 100.0
@export var menace_threshold: float = 50.0
@export var los_threshold: float = 1.0

var hunt_meter: float = 0.0
var menace_meter: float = 0.0
var los_timer: float = 0.0
var wander_timer: float = 0.0
var hunt_distance_offset: float = 500.0

var ronald: CharacterBody2D
var pathfinder: Node
var movement: Node
var senses: Node

signal menace_changed(new_value)
signal hunt_changed(new_value)

func _ready():
	ronald = get_tree().root.get_node("Main/Ronald")
	pathfinder = ronald.get_node("Brain/A*")
	movement = ronald.get_node("Brain/Movement")
	senses = ronald.get_node("Brain/Senses")

func _process(delta):
	if senses.has_los_to_player():
		los_timer += delta
		if los_timer >= los_threshold and state == State.INACTIVE:
			_start_hunt()
	else:
		los_timer = max(0, los_timer - delta * 2.0)

	match state:
		State.INACTIVE:
			_handle_inactive(delta)
		State.HUNTING:
			_handle_hunting(delta)
		State.CHASING:
			_handle_chasing(delta)
		State.FLEEING:
			_handle_fleeing(delta)

func _handle_inactive(delta):
	hunt_meter += delta
	hunt_changed.emit(hunt_meter)
	if hunt_meter >= hunt_threshold:
		hunt_meter = 0.0
		_start_hunt()
	
	wander_timer += delta
	if movement.is_path_done() or wander_timer >= wander_interval:
		wander_timer = 0.0
		var target = pathfinder.get_random_valid_point()
		if target != Vector2(-1, -1):
			pathfinder.find_path_to(target)
	
	movement.follow_path(delta)

func _start_hunt():
	state = State.HUNTING
	_set_target_near_player()

func _start_chase():
	state = State.CHASING
	pathfinder.find_path_to(senses.get_player_position())

func _handle_hunting(delta):
	if senses.has_los_to_player():
		los_timer += delta
		if los_timer >= los_threshold:
			_start_chase()
	else:
		los_timer = max(0.0, los_timer - delta * 2.0)
	
	if movement.is_path_done():
		_set_target_near_player()
	
	movement.follow_path(delta)
	
	if senses.distance_to_player() < menace_radius:
		menace_meter += delta
		menace_changed.emit(menace_meter)
		if menace_meter >= menace_threshold:
			_flee()
	else:
		menace_meter = max(0.0, menace_meter - delta)

func _handle_chasing(delta):
	if senses.has_los_to_player():
		los_timer += delta
		pathfinder.find_path_to(senses.get_player_position())
	else:
		los_timer = max(0.0, los_timer - delta * 2.0)
		if los_timer <= 0.0:
			state = State.HUNTING
			_set_target_near_player()
	
	movement.follow_path(delta)
	
	if senses.distance_to_player() < menace_radius:
		menace_meter += delta
		menace_changed.emit(menace_meter)
		if menace_meter >= menace_threshold:
			_flee()
	else:
		menace_meter = max(0.0, menace_meter - delta)

func _handle_fleeing(delta):
	movement.follow_path(delta)
	if movement.is_path_done():
		state = State.INACTIVE
		hunt_meter = 0.0

func _flee():
	state = State.FLEEING
	menace_meter = 0.0
	hunt_meter = 0.0
	menace_changed.emit(menace_meter)
	hunt_changed.emit(hunt_meter)
	
	var flee_dir = (ronald.global_position - senses.get_player_position()).normalized()
	var flee_target = ronald.global_position + flee_dir * flee_distance
	pathfinder.find_path_to(flee_target)

func _set_target_near_player():
	var offset = Vector2(randf_range(-hunt_distance_offset, hunt_distance_offset), randf_range(-hunt_distance_offset, hunt_distance_offset))
	pathfinder.find_path_to(senses.get_player_position() + offset)
