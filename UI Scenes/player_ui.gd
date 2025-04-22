extends Control

var player_node 
var triangle_flag = true
var square_flag = true

func _ready() -> void:
	player_node = get_parent().get_parent().get_node("Player")
	
func _physics_process(delta: float) -> void:
	if triangle_flag && player_node.attack_shape == "triange":
		triangle_flag = false
		$MoveIconsBar/Action1.texture_progress = load("res://Assets/UI Sprites/Icon_2Shot_Tri.png")
		$MoveIconsBar/Action2.texture_progress = load("res://Assets/UI Sprites/Icon_5Shot_Tri.png")
		$MoveIconsBar/Action3.texture_progress = load("res://Assets/UI Sprites/Icon_ZigZag.png")
		$MoveIconsBar/Action4.texture_progress = load("res://Assets/UI Sprites/Icon_Dash .png")
		$MoveIconsBar/Action5.texture_progress = load("res://Assets/UI Sprites/Icon_Summon_Tri.png")
	
	if square_flag && player_node.attack_shape == "square":
		square_flag = false
		$MoveIconsBar/Action1.texture_progress = load("res://Assets/spritePNGs/Icon_3Shot_Sqr.png")
		$MoveIconsBar/Action2.texture_progress = load("res://Assets/spritePNGs/Icon_Barrage_Sqr.png")
		$MoveIconsBar/Action3.texture_progress = load("res://Assets/UI Sprites/Icon_Crusher_Sqr.png")
		$MoveIconsBar/Action4.texture_progress = load("res://Assets/UI Sprites/Icon_LongDash.png")
		$MoveIconsBar/Action5.texture_progress = load("res://Assets/spritePNGs/Icon_Shield_Square.png")
	
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
	
	
