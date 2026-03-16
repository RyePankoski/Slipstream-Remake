extends Node

var ronald: CharacterBody2D
var nav: NavigationAgent2D
var ronald_ai: Node

@export var move_speed: float = 80.0

func _ready():
	ronald = get_tree().root.get_node("Main/Ronald")
	nav = ronald.get_node("NavigationAgent2D")
	ronald_ai = ronald.get_node("Brain/AI")

func follow_path(delta):
	if nav.is_navigation_finished():
		ronald.velocity = Vector2.ZERO
		ronald.move_and_slide()
		return
		
	match ronald_ai.behavior:
		ronald_ai.Behavior_Set.HUNTING:
			move_speed = 500.0
		ronald_ai.Behavior_Set.WANDERING:
			move_speed = 50.0
	
	var next = nav.get_next_path_position()
	var direction = (next - ronald.global_position).normalized()
	ronald.velocity = direction * move_speed
	ronald.move_and_slide()

func is_path_done() -> bool:
	return nav.is_navigation_finished()

func abandon_path():
	nav.target_position = ronald.global_position
