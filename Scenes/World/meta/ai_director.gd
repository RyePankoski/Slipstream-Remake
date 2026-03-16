extends Node

var Ronald: Node
var Ronald_AI: Node
var Player: Node

var los_timer: float = 0.0
var hunt_meter: float = 0.0

var menace_meter: float = 0.0
var menace_threshold: float = 100.0
var menace_radius: float = 2000.0

var unease_meter: float = 0.0
var unease_threshold: float = 50.0
var unease_radius: float = 1000.0

var player_peace: float = 90
var player_peace_threshold: float = 100.0

var distance_to_player: float = 0.0

signal menace_changed(new_value)
signal unease_changed(new_value)
signal player_peace_changed(new_value)

func _ready() -> void:
	Ronald  = $"../Ronald"
	Ronald_AI = $"../Ronald/Brain/AI"
	Player = $"../Player" 
	menace_changed.emit(menace_meter)
	
func _process(delta: float) -> void:
	distance_to_player = Player.position.distance_to(Ronald.position)
	match Ronald_AI.state:
		Ronald_AI.States.HOSTILE:
			_handle_menace(delta, distance_to_player)
		Ronald_AI.States.PASSIVE:
			_handle_unease(delta, distance_to_player)
			_handle_player_peace(delta, distance_to_player)
			
	_handle_state()
	_emit_signals()

func _handle_state():
	if menace_meter >= menace_threshold:
		Ronald_AI.request(Ronald_AI.States.PASSIVE)
		menace_meter = 0
	if unease_meter >= unease_threshold:
		Ronald_AI.request(Ronald_AI.States.HOSTILE)
		unease_meter = 0
	if player_peace >= player_peace_threshold:
		Ronald_AI.request(Ronald_AI.States.HOSTILE)
		player_peace = 0
		
func _handle_menace(delta, distance_to_player):
	if distance_to_player < menace_radius:
		menace_meter = min(menace_meter + delta, menace_threshold)
	else:
		menace_meter = max(menace_meter - delta, 0.0)
		
func _handle_unease(delta, distance_to_player):
	if distance_to_player < unease_radius:
		unease_meter = min(unease_meter + delta, unease_threshold)
	else:
		unease_meter = max(unease_meter - delta, 0.0)
		
func _handle_player_peace(delta, distance_to_player):
	if  Ronald_AI.state != Ronald_AI.States.HOSTILE:
		player_peace = min(player_peace + delta, player_peace_threshold)
	else:
		player_peace = max(player_peace - delta, 0.0)

func _emit_signals():
	unease_changed.emit(unease_meter)
	menace_changed.emit(menace_meter)
	player_peace_changed.emit(player_peace)




	
	


		
