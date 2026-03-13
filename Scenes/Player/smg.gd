extends Node2D

@export var fire_rate: float = 0.125
@export var flash_time: float = 0.01
@export var bullet_scene: PackedScene

var can_fire = true

func _ready():
	$FireTimer.wait_time = fire_rate
	$FlashTimer.wait_time = flash_time
	$FireTimer.timeout.connect(_on_fire_timer_timeout)
	$FlashTimer.timeout.connect(_on_flash_timer_timeout)
	
func _process(delta):
	if Input.is_action_pressed("use tool or weapon") and can_fire:
		_fire()
		$muzzle_flash.enabled = true
		$FlashTimer.start()
		
func _fire():
	if not can_fire:
		return
	can_fire = false
	$fire_sfx.play()
	$FireTimer.start()
	
	var bullet = bullet_scene.instantiate()
	bullet.speed = 2000
	bullet.damage = 25.0
	bullet.max_range = 1000.0
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	get_tree().root.get_node("Main").add_child(bullet)
	bullet.global_position = global_position + bullet.direction * 30.0

func _on_fire_timer_timeout():
	can_fire = true
func _on_flash_timer_timeout():
	$muzzle_flash.enabled = false
