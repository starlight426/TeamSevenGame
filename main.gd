extends Node2D

@onready var pause_menu = $CanvasLayer2/PauseMenu
var paused = false
var player_node
var should_load_game = false

func _ready() -> void:

	player_node = get_node("Player")
	MainMusicPlayer._play_music()
	pause_menu.hide()
	
	if not should_load_game:
		RoomLoader.load_room_from_exit("Circle City", "cigil_room", "from_right")
	else:
		load_game()
		should_load_game = false
		

func _process(delta: float) -> void:
	if Input.is_action_just_released("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		player_node.is_paused = false
		Engine.time_scale = 1
	else:
		pause_menu.show()
		player_node.is_paused = true
		Engine.time_scale = 0
	paused = !paused

func resume_game():
	pause_menu.hide()
	player_node.is_paused = false
	Engine.time_scale = 1
	paused = false
	print("Game resumed: Paused = ", paused, ", Menu visible = ", pause_menu.visible)  # Debug

# Save game function
func save_game():
	var save_data = {
		"player_position_x": player_node.position.x,
		"player_position_y": player_node.position.y,
		"player_is_paused": player_node.is_paused,
		"player_hp": player_node.hp,
		"player_energy": player_node.energy,
		"player_speed": player_node.speed,
		"attack_shape": player_node.attack_shape,
		"move_readiness": player_node.move_readiness,
		"move_cooldown_percentages": player_node.move_cooldown_percentages,
		"room_group": RoomLoader.last_group,
		"room_name": RoomLoader.last_room.replace(".tscn", ""),
		"entrance": RoomLoader.last_entrance
	}
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Game saved in ", RoomLoader.last_group, "/", RoomLoader.last_room, " at position: ", player_node.position)
	else:
		print("Failed to save game.")

# Load game function
func load_game():
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var save_data = JSON.parse_string(json_string)
			if save_data:
				var room_path = "res://Room Scenes/" + save_data["room_group"] + "/" + save_data["room_name"] + ".tscn"
				print("Attempting to load room: ", room_path)
				
				if ResourceLoader.exists(room_path):
					RoomLoader.load_room(room_path)
					await RoomLoader.room_has_loaded 
					player_node.position = Vector2(save_data["player_position_x"], save_data["player_position_y"])
					player_node.hp = save_data["player_hp"]
					player_node.energy = save_data["player_energy"]
					player_node.speed = save_data["player_speed"]
					player_node.attack_shape = save_data["attack_shape"]
					player_node.move_readiness = save_data["move_readiness"]
					player_node.move_cooldown_percentages = save_data["move_cooldown_percentages"]
					
					RoomLoader.last_group = save_data["room_group"]
					RoomLoader.last_room = save_data["room_name"] + ".tscn"
					RoomLoader.last_entrance = save_data["entrance"]
					
					resume_game()
					
					print("Game loaded to ", save_data["room_group"], "/", save_data["room_name"], " at position: ", player_node.position)
				else:
					print("Error: Room path does not exist: ", room_path)
			else:
				print("Failed to parse save data.")
		else:
			print("Failed to open save file.")
	else:
		print("No save file found.")

# Button signal handlers
func _on_Save_Button_pressed():
	save_game()

func _on_Load_Button_pressed():
	should_load_game = true
	load_game()  

func _on_Resume_Button_pressed():
	pauseMenu()

func _on_Quit_Button_pressed():
	get_tree().quit()
