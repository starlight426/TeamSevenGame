extends Node2D

#@onready var pause_menu: PauseMenu = $CanvasLayer2/PauseMenu
@onready var pause_menu = $CanvasLayer2/PauseMenu
var paused = false
var player_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RoomLoader.load_room_from_exit("Circle City","cigil_room","from_right")
	player_node = get_node("Player") 
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("pause"):
		pauseMenu()
	

func pauseMenu():
	if (paused):
		pause_menu.hide()
		player_node.is_paused = false
		Engine.time_scale = 1
	else:
		pause_menu.show()
		player_node.is_paused = true
		Engine.time_scale = 0
		
	paused = !paused
