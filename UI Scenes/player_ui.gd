extends Control

var player_node 

func _ready() -> void:
	player_node = get_parent().get_parent().get_node("Player")
	
func _physics_process(delta: float) -> void:
	if (player_node.hp >= 100):
		$HBoxContainer2/HealthLabel.text = "Health: " + str(player_node.hp) + "/200"
	elif (player_node.hp >= 10):
		$HBoxContainer2/HealthLabel.text = "Health:   " + str(player_node.hp) + "/200"
	else:
		$HBoxContainer2/HealthLabel.text = "Health:    " + str(player_node.hp) + "/200"
	$HBoxContainer2/HealthBar.value = player_node.hp
	
	if (player_node.energy >= 100):
		$HBoxContainer/EnergyLabel.text = "Energy: " + str(player_node.energy) + "/500"
	elif (player_node.energy >= 10):
		$HBoxContainer/EnergyLabel.text = "Energy:   " + str(player_node.energy) + "/500"
	else:
		$HBoxContainer/EnergyLabel.text = "Energy:    " + str(player_node.energy) + "/500"
	$HBoxContainer/EnergyBar.value = player_node.energy
	$MoveIconsBar/Action1.value = player_node.move_cooldown_percentages[0]
	$MoveIconsBar/Action2.value = player_node.move_cooldown_percentages[1]
	$MoveIconsBar/Action3.value = player_node.move_cooldown_percentages[2]
	$MoveIconsBar/Action4.value = player_node.move_cooldown_percentages[3]
	$MoveIconsBar/Action5.value = player_node.move_cooldown_percentages[4]
