extends Node2D

@export var stop_number: int
var in_zone: bool
var tram: Node
var player: Node




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tram = get_tree().root.get_node("Main/World/Tram")
	player = get_tree().root.get_node("Main/Player")
	
	$terminal_area.body_entered.connect(_on_zone_entered)
	$terminal_area.body_exited.connect(_on_zone_exited)

func _process(delta):
	print(tram.global_position)
	
	if in_zone and Input.is_action_just_pressed("interact"):
		$chime.play()
		print("called tram")
		tram.current_stop_index = stop_number
		tram.target_stop = tram.stops[tram.current_stop_index]
		tram.target_x = tram.target_stop.x
		tram.in_transit = true
		tram._travel_to_stop()


func _on_zone_entered(body: Node) -> void:
	if body.is_in_group("player"):
		in_zone = true

func _on_zone_exited(body: Node) -> void:
	if body.is_in_group("player"):
		in_zone = false
	
