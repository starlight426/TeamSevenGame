extends Node
@onready var main_node = get_tree().root.get_node("Main")
var current_checkpoint: Node2D
var current_room = null
var new_room_loaded = null
signal room_has_loaded
var last_entrance = "from_left"
var last_group = "Circle City"
var last_room = "cigil_room.tscn"
func set_checkpoint(passed_checkpoint):
	# change this later
	load_room(passed_checkpoint.get_parent().get_path())
	await room_has_loaded
	teleport_player(passed_checkpoint.global_postion)
	
func player_die():
	#TransitionScreen.transition()
	#await TransitionScreen.on_transition_finished
	load_room_from_exit(last_group,last_room,last_entrance)
	
func load_room_from_exit(target_group,target_room,target_entrance):
	print(target_group,target_room,target_entrance)
	last_entrance = target_entrance
	last_group = target_group
	last_room = target_room
	var room_to_load = "res://Room Scenes/" + target_group + "/" +target_room + ".tscn"
	load_room(room_to_load)
	await room_has_loaded
	teleport_player(new_room_loaded.get_node(target_entrance).global_position)
	
func load_room(room_to_load):
	#room transition animation
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished

	if(!room_to_load):
		return
		
	new_room_loaded = load(room_to_load).instantiate()
	MainMusicPlayer._play_music()
	
	if(current_room): 
		current_room.queue_free() 
		get_tree().call_group("element", "queue_free")
	
	main_node.call_deferred("add_child", new_room_loaded)
	current_room = new_room_loaded
	
	main_node.get_node("Camera2D").set_camera(new_room_loaded.get_node("left_camera_limit").position.x,new_room_loaded.get_node("right_camera_limit").position.x,new_room_loaded.get_node("top_camera_limit").position.y,new_room_loaded.get_node("bottom_camera_limit").position.y)
	
	room_has_loaded.emit()
	
func teleport_player(new_pos):
	main_node.get_node("Player").position = new_pos

func trigger(trigger_id):
	pass
	
