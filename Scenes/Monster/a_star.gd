extends Node

var ronald: CharacterBody2D
var floor_map: TileMapLayer
var collision_map: TileMapLayer

const DEFAULT_TIMEOUT: float = 5.0

func _ready():
	ronald = get_tree().root.get_node("Main/Ronald")
	floor_map = get_tree().root.get_node("Main/World/Map/main_map/FloorLayer")
	collision_map = get_tree().root.get_node("Main/World/Map/main_map/NavigationRegion2D/collisionMap")
	#print("floor_map: ", floor_map)
	#print("collision_map: ", collision_map)

# Converts a world-space range in pixels to cell units.
func _to_cell_range(range_px: float) -> int:
	return int(range_px / floor_map.tile_set.tile_size.x)

# Checks whether a cell is valid: on the floor and not blocked.
func _is_valid_cell(cell: Vector2i) -> bool:
	return floor_map.get_cell_source_id(cell) != -1 and collision_map.get_cell_source_id(cell) == -1

# Converts a valid cell to a world position.
func _cell_to_world(cell: Vector2i) -> Vector2:
	return floor_map.map_to_local(cell) + Vector2(16, 16)

# Returns a random valid point within search_range pixels of a given origin point.
func get_random_valid_point(search_range: float, origin: Vector2, timeout: float = DEFAULT_TIMEOUT) -> Vector2:
	var origin_cell = floor_map.local_to_map(origin)
	var cell_range = _to_cell_range(search_range)
	var start_time = Time.get_ticks_msec()
	while true:
		if Time.get_ticks_msec() - start_time > timeout * 1000:
			push_warning("get_random_valid_point timed out after " + str(timeout) + "s")
			return Vector2(-1, -1)
		var cell = Vector2i(
			randi_range(origin_cell.x - cell_range, origin_cell.x + cell_range),
			randi_range(origin_cell.y - cell_range, origin_cell.y + cell_range)
		)
		if _is_valid_cell(cell):
			return _cell_to_world(cell)
	return Vector2(-1, -1)

# Returns a random valid point at least min_range pixels away from a given origin point.
func get_random_valid_point_far_from(min_range: float, origin: Vector2, timeout: float = DEFAULT_TIMEOUT) -> Vector2:
	var map_rect = floor_map.get_used_rect()
	var origin_cell = floor_map.local_to_map(origin)
	var cell_min_range = _to_cell_range(min_range)
	var start_time = Time.get_ticks_msec()
	while true:
		if Time.get_ticks_msec() - start_time > timeout * 1000:
			push_warning("get_random_valid_point_far_from timed out after " + str(timeout) + "s")
			return Vector2(-1, -1)
		var cell = Vector2i(
			randi_range(map_rect.position.x, map_rect.position.x + map_rect.size.x),
			randi_range(map_rect.position.y, map_rect.position.y + map_rect.size.y)
		)
		if origin_cell.distance_to(Vector2(cell)) < cell_min_range:
			continue
		if _is_valid_cell(cell):
			return _cell_to_world(cell)
	return Vector2(-1, -1)

func find_path_to(target: Vector2) -> void:
	if target == Vector2(-1, -1):
		return
	ronald.get_node("NavigationAgent2D").target_position = target
