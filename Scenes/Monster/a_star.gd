extends Node

var ronald: CharacterBody2D
var floor_map: TileMapLayer
var collision_map: TileMapLayer

func _ready():
	ronald = get_tree().root.get_node("Main/Ronald")
	floor_map = get_tree().root.get_node("Main/World/Map/main_map/FloorLayer")
	collision_map = get_tree().root.get_node("Main/World/Map/main_map/NavigationRegion2D/collisionMap")
	print("floor_map: ", floor_map)
	print("collision_map: ", collision_map)

func get_random_valid_point() -> Vector2:
	var map_rect = floor_map.get_used_rect()
	for i in range(100):
		var cell = Vector2i(
			randi_range(map_rect.position.x, map_rect.position.x + map_rect.size.x),
			randi_range(map_rect.position.y, map_rect.position.y + map_rect.size.y)
		)
		if floor_map.get_cell_source_id(cell) != -1 and collision_map.get_cell_source_id(cell) == -1:
			return floor_map.map_to_local(cell) + Vector2(16, 16)
	return Vector2(-1, -1)

func find_path_to(target: Vector2) -> void:
	if target == Vector2(-1, -1):
		return
	ronald.get_node("NavigationAgent2D").target_position = target
