extends CanvasLayer

var ronald_ai: Node
var director: Node

@onready var health_label = $health_label
@onready var stamina_label = $stamina_label

@onready var state_label = $r_state
@onready var behavior_label = $r_behavior

@onready var menace_label = $r_menace_meter
@onready var unease_label = $r_unease
@onready var peace_label = $player_peace

func _ready():
	ronald_ai = get_tree().root.get_node("Main/Ronald/Brain/AI")
	director = get_tree().root.get_node("Main/AI_Director")
	
func setup(player: CharacterBody2D):
	director.menace_changed.connect(_on_menace_changed)
	director.unease_changed.connect(_on_unease_changed)
	director.player_peace_changed.connect(_on_peace_changed)
	
	ronald_ai.state_changed.connect(_on_state_changed)
	ronald_ai.behavior_changed.connect(_on_behavior_changed)

	health_label.text = "HP: " + str(roundi(player.health))
	stamina_label.text = "ST: " + str(roundi(player.stamina))
	
func _on_menace_changed(new_value):
	menace_label.text = "Menace: " + str(roundi(new_value))
	
func _on_unease_changed(new_value):
	unease_label.text = "Unease: " + str(roundi(new_value))
	
func _on_peace_changed(new_value):
	peace_label.text = "Player peace: " + str(roundi(new_value))
	
func _on_state_changed(new_value):
	state_label.text = "State: " + new_value
	
func _on_behavior_changed(new_value):
	behavior_label.text = "Behavior: " + new_value
	
