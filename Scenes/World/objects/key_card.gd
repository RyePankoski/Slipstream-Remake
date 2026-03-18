extends Node2D

@export var key_id: int = 0
@export var item: Item

func _ready():
	$key_card_detect_area.key_id = key_id
