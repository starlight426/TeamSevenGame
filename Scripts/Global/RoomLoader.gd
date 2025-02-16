extends Node
@onready var main_node = get_tree().root.get_node("Main")
var current_checkpoint: Node2D
var current_room = null
var new_room_loaded = null
signal room_has_loaded


func set_checkpoint(passed_checkpoint):
	# change this later
	load_room(passed_checkpoint.get_parent().get_path())
	await room_has_loaded
	teleport_player(passed_checkpoint.global_postion)
	
func player_die():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	

func load_room_from_exit(target_group,target_room,target_entrance):
	var room_to_load = "res://Overworld Scenes/Room scenes/" + target_group + "/" +target_room + ".tscn"
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
	
	if(current_room): 
		current_room.queue_free() 
		get_tree().call_group("element", "queue_free")
	
	main_node.call_deferred("add_child", new_room_loaded)
	current_room = new_room_loaded
	
	main_node.set_camera(new_room_loaded.get_node("left_camera_limit").position.x,new_room_loaded.get_node("right_camera_limit").position.x,
	new_room_loaded.get_node("top_camera_limit").position.y,new_room_loaded.get_node("bottom_camera_limit").position.y)
	
	room_has_loaded.emit()
	
func teleport_player(new_pos):
	main_node.get_node("xara").position = new_pos

func trigger(trigger_id):
	pass
	
