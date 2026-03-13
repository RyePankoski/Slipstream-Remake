extends Node

var player: Node2D
var interactables = []

@export var activation_radius: float = 600.0

func _ready():
	print(get_parent().get_children())
	player = get_node("player")
	interactables = get_tree().get_nodes_in_group("interactables")
	for obj in interactables:
		obj.process_mode = Node.PROCESS_MODE_DISABLED
	
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.timeout.connect(_check_proximity)
	add_child(timer)
	timer.start()

func _check_proximity():
	var active_count = 0
	for obj in interactables:
		var close = obj.global_position.distance_to(player.global_position) < activation_radius
		obj.process_mode = Node.PROCESS_MODE_INHERIT if close else Node.PROCESS_MODE_DISABLED
		if close:
			active_count += 1
	#print("Active: ", active_count, " / ", interactables.size())
