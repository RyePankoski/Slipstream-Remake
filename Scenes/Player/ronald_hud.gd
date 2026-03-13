extends CanvasLayer

@onready var health_label = $health_label
@onready var stamina_label = $stamina_label


func setup(player: CharacterBody2D):
	player.health_changed.connect(_on_health_changed)
	player.stamina_changed.connect(_on_stamina_changed)
	health_label.text = "HP: " + str(roundi(player.health))
	stamina_label.text = "ST: " + str(roundi(player.stamina))


func _on_health_changed(new_value):
	health_label.text = "HP: " + str(roundi(new_value))

func _on_stamina_changed(new_value):
	stamina_label.text = "ST: " + str(roundi(new_value))
