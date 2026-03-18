extends Node2D

var player: Node
var stops: Array[Vector2] = [Vector2(3380, 4960),Vector2(5000, 4960), Vector2(9130, 4960), Vector2(13050, 4960)]
var current_stop_index: int = 2  # start at the right stop
var target_stop: Vector2
var left: bool = false
var right: bool = false
var in_transit: bool = false
var target_x: float
var player_at_left: bool = false
var player_at_right: bool = false
var player_on_platform
const MAX_SPEED = 400.0
const MIN_SPEED = 10.0
const ACCELERATION = 100.0
var speed = 0.0

func _ready() -> void:
	
	global_position = Vector2(9130, 4960)
	
	$terminal_left.body_entered.connect(_on_terminal_left_entered)
	$terminal_left.body_exited.connect(_on_terminal_left_exited)
	$terminal_right.body_entered.connect(_on_terminal_right_entered)
	$terminal_right.body_exited.connect(_on_terminal_right_exited)
	$platform_area.body_entered.connect(_on_platform_entered)
	$platform_area.body_exited.connect(_on_platform_exited)

func _process(delta):
	if in_transit:
		_travel_to_stop()
		if not $Audio/tram_sfx.playing:
			$Audio/tram_sfx.play()
	else:
		$Audio/tram_sfx.stop()
		
	if player_at_left and Input.is_action_just_pressed("interact"):
		if not in_transit:
			_handle_lights()
		$Audio/terminal_sfx.play()
		$Audio/tram_start_sfx.play()
		if current_stop_index > 0:
			left = true
			right = false
			current_stop_index -= 1
			target_stop = stops[current_stop_index]
			target_x = target_stop.x
			in_transit = true
		else:
			print("No stop to the left")
	if player_at_right and Input.is_action_just_pressed("interact"):
		if not in_transit:
			_handle_lights()
		$Audio/terminal_sfx.play()
		$Audio/tram_start_sfx.play()

		if current_stop_index < stops.size() - 1:
			right = true
			left = false
			current_stop_index += 1
			target_stop = stops[current_stop_index]
			target_x = target_stop.x
			in_transit = true
		else:
			print("No stop to the right")

func _on_platform_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player = body
		print("Player on platform")

func _on_platform_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player = null

func _on_terminal_left_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_at_left = true

func _on_terminal_left_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_at_left = false

func _on_terminal_right_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_at_right = true

func _on_terminal_right_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_at_right = false
		
func _handle_lights():
	$Lights/light_left.enabled = not $Lights/light_left.enabled
	$Lights/light_right.enabled = not $Lights/light_right.enabled

func _travel_to_stop():
	var dist = abs(global_position.x - target_x)
	
	# distance needed to decelerate from current speed to MIN_SPEED
	var decel_distance = (speed * speed - MIN_SPEED * MIN_SPEED) / (2.0 * ACCELERATION)
	
	if dist > decel_distance:
		speed = move_toward(speed, MAX_SPEED, ACCELERATION * get_process_delta_time())
	else:
		speed = move_toward(speed, MIN_SPEED, ACCELERATION * get_process_delta_time())
	
	var direction = sign(target_x - global_position.x)
	var move = direction * speed * get_process_delta_time()
	global_position.x += move
	if player:
		player.global_position.x += move
	if abs(global_position.x - target_x) < 2.0:
		global_position.x = target_x
		in_transit = false
		left = false
		right = false
		speed = 0.0
		_handle_lights()
		$Audio/tram_stop_sfx.play()
