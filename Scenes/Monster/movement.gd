extends Node

var ronald: CharacterBody2D
var nav: NavigationAgent2D
var ai: Node

@export var move_speed: float = 80.0

func _ready():
	ronald = get_tree().root.get_node("Main/Ronald")
	nav = ronald.get_node("NavigationAgent2D")
	ai = ronald.get_node("Brain/AI")

func follow_path(delta):
	if nav.is_navigation_finished():
		ronald.velocity = Vector2.ZERO
		ronald.move_and_slide()
		return
	
	var next = nav.get_next_path_position()
	var direction = (next - ronald.global_position).normalized()
	
	if ai.state == ai.State.FLEEING:
		ronald.velocity = direction * move_speed * 2.2
	elif ai.state == ai.State.INACTIVE:
		ronald.velocity = direction * move_speed
	elif ai.state == ai.State.HUNTING:
		ronald.velocity = direction * move_speed * 1.5
	elif ai.state == ai.State.CHASING:
		ronald.velocity = direction * move_speed * 2

	ronald.move_and_slide()

func set_target(target: Vector2):
	nav.target_position = target

func is_path_done() -> bool:
	return nav.is_navigation_finished()
