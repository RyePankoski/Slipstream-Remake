extends Node

@export var min_interval: float = 5.0
@export var max_interval: float = 20.0
@export var spawn_radius: float = 1500.0

var audio: AudioStreamPlayer2D
var player: Node2D
var noises: Array = []
var timer: Timer

func _ready():
	player = get_tree().root.get_node("Main/Player")

	audio = AudioStreamPlayer2D.new()
	add_child(audio)

	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_play_sound)
	add_child(timer)

	var dir = DirAccess.open("res://Sound Effects/ship_noises/")
	for file in dir.get_files():
		if file.ends_with(".mp3"):
			noises.append(load("res://Sound Effects/ship_noises/" + file))

	_queue_next()
	
func _process(delta):
	var space = player.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(audio.global_position, player.global_position)
	var result = space.intersect_ray(query)
	
	if result:
		audio.volume_db = -5.0  # muffled
	else:
		audio.volume_db = 0.0    # full volume

func _choose_point_near_player() -> Vector2:
	var angle = randf() * TAU
	return player.global_position + Vector2(cos(angle), sin(angle)) * spawn_radius

func _play_sound():
	if noises.is_empty():
		_queue_next()
		return
	if audio.playing:
		_queue_next()
		return
	audio.global_position = _choose_point_near_player()
	audio.stream = noises.pick_random()
	audio.play()
	_queue_next()

func _queue_next():
	timer.wait_time = randf_range(min_interval, max_interval)
	timer.start()
