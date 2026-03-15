extends CanvasLayer

var ronald_ai: Node
var director: Node
@onready var health_label = $health_label
@onready var stamina_label = $stamina_label
@onready var menace_label = $r_menace_meter
@onready var hunt_label = $r_hunt_meter
@onready var status_label = $r_status

func _ready():
	ronald_ai = get_tree().root.get_node("Main/Ronald/Brain/AI")
	director = get_tree().root.get_node("Main/AI_Director")
	
func setup(player: CharacterBody2D):
	player.health_changed.connect(_on_health_changed)
	player.stamina_changed.connect(_on_stamina_changed)
	director.menace_changed.connect(_on_menace_changed)
	director.hunt_changed.connect(_on_hunt_changed)
	director.status_changed.connect(_on_status_changed)
	
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

func _on_status_changed(new_value):
	status_label.text = "Status: " + new_value
	
	
