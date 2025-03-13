extends Control

var player_node 

func _ready() -> void:
	player_node = get_parent().get_parent().get_node("Player")
	
func _physics_process(delta: float) -> void:
	$HBoxContainer2/HealthLabel.text = "Health: " + str(player_node.hp) + "/200"
	$HBoxContainer/EnergyLabel.text = "Energy: " + str(player_node.energy) + "/500"
	$MoveIconsBar/Action1.value = player_node.move_cooldown_percentages[0]
	$MoveIconsBar/Action2.value = player_node.move_cooldown_percentages[1]
	$MoveIconsBar/Action3.value = player_node.move_cooldown_percentages[2]
	$MoveIconsBar/Action4.value = player_node.move_cooldown_percentages[3]
	$MoveIconsBar/Action5.value = player_node.move_cooldown_percentages[4]
