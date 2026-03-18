@tool
extends Node2D

const SLIDE_DISTANCE = 128.0
const SLIDE_DURATION = 0.5
var is_open = false
var tween: Tween
var closed_pos: Vector2
@export var required_key_id: int = 0
@export var locked = false:
	set(value):
		locked = value
		_update_light()

func _ready():
	closed_pos = $StaticBody2D.position
	add_to_group("interactables")
	_update_light()
	
func open_door():
	if is_open:
		return	
	check_for_key()
	if locked:
		$Audio/locked_sfx.play()
		return

	_slide(closed_pos + Vector2(0, SLIDE_DISTANCE))
	is_open = true
	$lock_light.enabled = false
	$Audio/open_door_sfx.play()
	
func check_for_key():
	if not locked:
		return
	var player = get_tree().get_first_node_in_group("player")
	if required_key_id in player.keycards:
		locked = false
		$Audio/unlock_sfx.play()
		_update_light()
	else:
		$Audio/locked_sfx.play()
	
func close_door():
	if not is_open:
		return
		
	is_open = false
	_slide(closed_pos)
	
	$Audio/door_close_sfx.play()
	$lock_light.enabled = true

func _slide(target: Vector2):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($StaticBody2D, "position", target, SLIDE_DURATION)\
		.set_trans(Tween.TRANS_SINE)

func _on_detect_player_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		open_door()
		
func _on_detect_player_zone_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		close_door()

func _update_light():
	if not locked:
		$lock_light.color = Color(0, 1, 0, 1)
	else:
		$lock_light.color = Color(1, 0, 0, 1)
