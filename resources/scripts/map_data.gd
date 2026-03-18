extends Node

# Keys are Vector2i grid coordinates, values are tile type strings
var tiles: Dictionary = {}
var preview_cells: Array = []

func set_tile(coord: Vector2i, type: String) -> void:
	tiles[coord] = type

func erase_tile(coord: Vector2i) -> void:
	tiles.erase(coord)

func get_tile(coord: Vector2i) -> String:
	return tiles.get(coord, "")
