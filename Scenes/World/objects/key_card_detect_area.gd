extends Area2D

@export var key_id: int = 0

func interact(player):
	player.inventory.append(key_id)
	get_parent().queue_free()
	return "key_card"

func get_scan_data() -> Dictionary:
	return {"type": "Keycard", "id": key_id}
