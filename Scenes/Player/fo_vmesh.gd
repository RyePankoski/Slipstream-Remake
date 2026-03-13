extends Polygon2D

@export var ray_count: int = 360
@export var max_distance: float = 800.0

func _process(delta):
	var points = []
	var space = get_world_2d().direct_space_state
	
	for i in ray_count:
		var angle = (2 * PI * i) / ray_count
		var direction = Vector2(cos(angle), sin(angle))
		var target = global_position + direction * max_distance
		
		var query = PhysicsRayQueryParameters2D.create(global_position, target)
		query.collision_mask = 128
		query.exclude = [self]
		var result = space.intersect_ray(query)
		
		if result:
			points.append(to_local(result.position))
		else:
			points.append(to_local(target))
	
	polygon = PackedVector2Array(points)
