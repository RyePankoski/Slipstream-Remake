extends Node

var ronald: Node
var a_star: Node
var movement: Node
var player: Node

func _ready() -> void:
	ronald = get_tree().root.get_node("Main/Ronald")
	player = get_tree().root.get_node("Main/Player")
	a_star = ronald.get_node("Brain/A*")
	movement = ronald.get_node("Brain/Movement")
		
func enter_wander(range: float = 6000):
	a_star.find_path_to(a_star.get_random_valid_point(range, ronald.global_position))
func update_wander(delta):
	movement.follow_path(delta)
	if movement.is_path_done():
		enter_wander() 
		
func enter_hunt(range: float = 500):
	a_star.find_path_to(a_star.get_random_valid_point(range, player.global_position))
func update_hunt(delta):
	movement.follow_path(delta)
	if movement.is_path_done():
		#print("Done, on to the next hunt point	")
		enter_hunt()

func enter_flee():
	a_star.find_path_to()
	pass
func update_flee(delta):
	pass
	
