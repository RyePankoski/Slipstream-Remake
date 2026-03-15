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

func is_path_done() -> bool:
	return nav.is_navigation_finished()

func abandon_path():
	nav.target_position = ronald.global_position

func get_path_timeout(slack: float = 2.0) -> float:
	var path = nav.get_current_navigation_path()
	if path.size() < 2:
		return 0.0
	var total_distance := 0.0
	for i in range(path.size() - 1):
		total_distance += path[i].distance_to(path[i + 1])
	var effective_speed = move_speed  # caller can scale if needed
	return (total_distance / effective_speed) * slack
