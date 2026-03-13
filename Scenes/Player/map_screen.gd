extends Control

@onready var camera = $SubViewportContainer/SubViewport/Camera2D
@onready var length_label = $LengthLabel

var line_start: Vector2i = Vector2i(-1, -1)
var is_drawing_line: bool = false


func _ready():
	var screen_size = get_viewport().get_visible_rect().size
	size = screen_size
	$SubViewportContainer.size = screen_size
	$SubViewportContainer/SubViewport.size = screen_size

func _input(event):
	if not visible:
		return
	
	# Zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom *= 1.1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom *= 0.9
	
	# Shift + left click to start/end line
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if Input.is_key_pressed(KEY_SHIFT):
			if event.pressed:
				line_start = screen_to_grid(event.position)
				is_drawing_line = true
			else:
				for coord in MapData.preview_cells:
					MapData.set_tile(coord, "wall")
				MapData.preview_cells.clear()
				is_drawing_line = false
				length_label.visible = false
				$SubViewportContainer/SubViewport/GridDrawer.queue_redraw()
		else:
			if event.pressed:
				var grid_coord = screen_to_grid(event.position)
				MapData.set_tile(grid_coord, "wall")
				$SubViewportContainer/SubViewport/GridDrawer.queue_redraw()
			
	# Right click erase
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		var grid_coord = screen_to_grid(event.position)
		MapData.erase_tile(grid_coord)
		$SubViewportContainer/SubViewport/GridDrawer.queue_redraw()

	if event is InputEventMouseMotion:
		# Pan with middle mouse
		if event.button_mask & MOUSE_BUTTON_MASK_MIDDLE:
			camera.position -= event.relative / camera.zoom
		# Drag paint
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT and not Input.is_key_pressed(KEY_SHIFT):
			var grid_coord = screen_to_grid(event.position)
			MapData.set_tile(grid_coord, "wall")
			$SubViewportContainer/SubViewport/GridDrawer.queue_redraw()
		# Right click drag erase
		if event.button_mask & MOUSE_BUTTON_MASK_RIGHT:
			var grid_coord = screen_to_grid(event.position)
			MapData.erase_tile(grid_coord)
			$SubViewportContainer/SubViewport/GridDrawer.queue_redraw()
		# Update line preview
		if is_drawing_line:
			MapData.preview_cells.clear()
			var current = screen_to_grid(event.position)
			var diff = current - line_start
			if abs(diff.x) >= abs(diff.y):
				var step = 1 if current.x >= line_start.x else -1
				for x in range(line_start.x, current.x + step, step):
					MapData.preview_cells.append(Vector2i(x, line_start.y))
			else:
				var step = 1 if current.y >= line_start.y else -1
				for y in range(line_start.y, current.y + step, step):
					MapData.preview_cells.append(Vector2i(line_start.x, y))
			$SubViewportContainer/SubViewport/GridDrawer.queue_redraw()
			length_label.visible = true
			length_label.position = event.position + Vector2(12, -12)
			length_label.text = str(MapData.preview_cells.size())

func screen_to_grid(screen_pos: Vector2) -> Vector2i:
	var viewport_pos = screen_pos - $SubViewportContainer.global_position
	var world_pos = viewport_pos / camera.zoom + camera.position - ($SubViewportContainer.size / 2.0) / camera.zoom
	return Vector2i(floor(world_pos.x / 16), floor(world_pos.y / 16))
