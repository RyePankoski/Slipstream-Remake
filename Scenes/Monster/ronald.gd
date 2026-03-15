extends CharacterBody2D

signal menace_changed(new_value)
signal hunt_changed(new_value)

var player: Node2D
var monster_cam = false

func _ready():
	add_to_group("Ronald")
	player = get_tree().get_first_node_in_group("player")
	
func _input(event):
	if event.is_action_pressed("debug_cam"):
		if monster_cam == false:
			$MonsterCamera2D.make_current()
			monster_cam = true
		else:
			get_node("/root/Main/Player/PlayerCamera2D").make_current()
			monster_cam = false

func _draw():
	pass
	#if player:
		#draw_line(Vector2.ZERO, to_local(player.global_position), Color(1, 0, 0, 0.5), 2.0)

func _process(delta):
	queue_redraw()
