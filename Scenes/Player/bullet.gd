extends Area2D

@export var speed: float = 800.0
@export var max_range: float = 600.0
@export var damage: float = 10.0

var direction: Vector2 = Vector2.ZERO
var distance_traveled: float = 0.0

func _ready():
	$CollisionShape2D  # just needs to exist
	connect("area_entered", _on_area_entered)
	connect("body_entered", _on_body_entered)
	queue_redraw()

func _process(delta):
	var movement = direction * speed * delta
	global_position += movement
	distance_traveled += movement.length()
	
	if distance_traveled >= max_range:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
	
func _draw():
	draw_circle(Vector2.ZERO, 2.0, Color(1, 1, 0.8, 1))
