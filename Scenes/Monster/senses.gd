extends Node

var ronald: CharacterBody2D
var player: Node2D

func _ready():
	ronald = get_tree().root.get_node("Main/Ronald")
	player = get_tree().get_first_node_in_group("player")

func has_los_to_player() -> bool:
	var space = ronald.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(ronald.global_position, player.global_position)
	query.collision_mask = 128
	query.exclude = [ronald]
	var result = space.intersect_ray(query)
	return result.is_empty()

func distance_to_player() -> float:
	return ronald.global_position.distance_to(player.global_position)

func get_player_position() -> Vector2:
	return player.global_position
