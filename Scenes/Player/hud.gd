extends CanvasLayer

var ronald_ai: Node
@onready var health_label = $health_label
@onready var stamina_label = $stamina_label
@onready var menace_label = $r_menace_meter
@onready var hunt_label = $r_hunt_meter



func _ready():
	ronald_ai = get_tree().root.get_node("Main/Ronald/Brain/AI")
	
func setup(player: CharacterBody2D):
	player.health_changed.connect(_on_health_changed)
	player.stamina_changed.connect(_on_stamina_changed)
	ronald_ai.menace_changed.connect(_on_menace_changed)
	ronald_ai.hunt_changed.connect(_on_hunt_changed)
	health_label.text = "HP: " + str(roundi(player.health))
	stamina_label.text = "ST: " + str(roundi(player.stamina))


func _on_health_changed(new_value):
	health_label.text = "HP: " + str(roundi(new_value))

func _on_stamina_changed(new_value):
	stamina_label.text = "ST: " + str(roundi(new_value))

func _on_menace_changed(new_value):
	menace_label.text = "Menace: " + str(roundi(new_value))
	
func _on_hunt_changed(new_value):
	hunt_label.text = "Hunt: " + str(roundi(new_value))
