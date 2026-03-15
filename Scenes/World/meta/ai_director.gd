extends Node

enum State { INACTIVE, HUNTING, CHASING, FLEEING }

@export var state = State.INACTIVE
var Ronald: Node
var Player: Node
var los_timer: float = 0.0
var hunt_meter: float = 0.0
var menace_meter: float = 0.0

signal menace_changed(new_value)
signal hunt_changed(new_value)
signal status_changed(new_value)


func _ready() -> void:
	Ronald  = $"../Ronald"
	Player = $"../player" 
	_emit_status(state)

func _process(delta: float) -> void:
	pass
	
func _emit_status(current_state):
	var text = ""
	match current_state:
		State.INACTIVE:
			text = "INACTIVE"
		State.HUNTING:
			text = "HUNTING"
		State.CHASING:
			text = "CHASING"
		State.FLEEING:
			text = "FLEEING"
	status_changed.emit(text)
