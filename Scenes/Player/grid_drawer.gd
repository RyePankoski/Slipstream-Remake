extends Node2D

const CELL_SIZE = 16
const GRID_COLOR = Color(0.2, 0.2, 0.2, 1.0)
const GRID_WIDTH = 469
const GRID_HEIGHT = 312

func _draw():
	# Black background
	draw_rect(Rect2(0, 0, GRID_WIDTH * CELL_SIZE, GRID_HEIGHT * CELL_SIZE), Color(0, 0, 0, 1.0))
	
	# Grid lines
	for x in range(GRID_WIDTH + 1):
		draw_line(
			Vector2(x * CELL_SIZE, 0),
			Vector2(x * CELL_SIZE, GRID_HEIGHT * CELL_SIZE),
			Color(0.15, 0.15, 0.15, 1.0), 1.0
		)
	for y in range(GRID_HEIGHT + 1):
		draw_line(
			Vector2(0, y * CELL_SIZE),
			Vector2(GRID_WIDTH * CELL_SIZE, y * CELL_SIZE),
			Color(0.15, 0.15, 0.15, 1.0), 1.0
		)
	
	# Walls
	for coord in MapData.tiles:
		if MapData.tiles[coord] == "wall":
			var rect = Rect2(coord.x * CELL_SIZE, coord.y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
			draw_rect(rect, Color(0.0, 1.0, 0.3, 1.0))
	
	# Preview
	for coord in MapData.preview_cells:
		var rect = Rect2(coord.x * CELL_SIZE, coord.y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
		draw_rect(rect, Color(0.0, 1.0, 0.3, 0.5))
