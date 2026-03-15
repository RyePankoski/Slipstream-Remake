extends CharacterBody2D

@onready var map_layer = $MapLayer

const SPEED := 200.0
const SPRINT_MULTIPLIER := 2.0
var max_health = 100.0
var health = 100.0
var max_stamina = 100.0
var stamina = 100.0
var stamina_drain_rate = 0.2
var stamina_regen_rate = 0.1
var inventory: Array = []
var map_open = false


signal stamina_changed(new_value)
signal health_changed(new_value)

var monster_cam = false
var item_type 

func _ready():
	map_open = false
	map_layer.visible = map_open
	$HUD.setup(self)
	add_to_group("player")
	
func _input(event):
	if event.is_action_pressed("interact"):
		for area in $interact_region.get_overlapping_areas():
			if area.has_method("interact"):
				item_type = area.interact(self)
				if item_type == "key_card":
					$Audio/generic_pickup.play()
				break
		

func _process(delta):
	if Input.is_action_just_pressed("ui_focus_next"):
		map_open = not map_open
		map_layer.visible = map_open
	
	Engine.get_frames_per_second()
	_update_rotation(delta)

func _physics_process(delta):
	_handle_flashlight()
	_handle_movement()
	_handle_stats(delta)
	
func _handle_stats(delta):
	if map_open:
		return
	if stamina < 100:
		stamina += stamina_regen_rate
		stamina_changed.emit(stamina)
		
func _handle_flashlight():
	if Input.is_action_just_pressed("toggle flashlight"):
		$flashlight/flashlight_cone.enabled = not $flashlight/flashlight_cone.enabled
		$flashlight/flashlight_scatter.enabled = not $flashlight/flashlight_scatter.enabled
		$Audio/flashlight_sfx.play()
		
func _handle_movement():
	var direction = Vector2.ZERO
	var sprint_factor = 1.0
	if Input.is_action_pressed("move up"):
		direction.y -= 1
	if Input.is_action_pressed("move down"):
		direction.y += 1
	if Input.is_action_pressed("move left"):
		direction.x -= 1
	if Input.is_action_pressed("move right"):
		direction.x += 1
	if Input.is_action_pressed("sprint"):
		sprint_factor = SPRINT_MULTIPLIER
		if stamina > 0:
			stamina -= stamina_drain_rate
			stamina_changed.emit(stamina)
	var stamina_ratio = clamp(stamina / max_stamina, 0.6, 1.0)
	velocity = direction.normalized() * SPEED * sprint_factor * stamina_ratio
	move_and_slide()
	_update_audio(direction, sprint_factor)

func _update_rotation(delta):
	var mouse_pos = get_global_mouse_position()
	$flashlight.look_at(mouse_pos)
	$flashlight.rotation += PI / 2
	var target_angle = $flashlight.rotation - PI
	$player_body_sprites/player_body.rotation = lerp_angle($player_body_sprites/player_body.rotation, target_angle, delta * 7.0)
	$player_body_sprites/player_head.look_at(mouse_pos)
	$player_body_sprites/player_head.rotation -= PI/2

func _update_audio(direction, sprint_factor):
	if direction != Vector2.ZERO:
		if sprint_factor > 1:
			if not $Audio/run.playing:
				$Audio/walk_sfx.stop()
				$Audio/run.play()
		else:
			if not $Audio/walk_sfx.playing:
				$Audio/run.stop()
				$Audio/walk_sfx.play()
	else:
		$Audio/walk_sfx.stop()
		$Audio/run.stop()
