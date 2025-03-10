extends Control

var player_node 

func _ready() -> void:
	player_node = get_parent().get_parent().get_node("Player")
	
func _physics_process(delta: float) -> void:
	$HBoxContainer2/HealthLabel.text = "Health: " + str(player_node.hp) + "/100"
	$HBoxContainer/EnergyLabel.text = "Energy: " + str(player_node.energy) + "/500"
