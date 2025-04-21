extends Area2D

@export var target_room = "none"
@export var target_entrance = "none"
@export var target_group = "none"
@export var exit_ready = 0
#signal exit_room(target_r,entrance_num)
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.2).timeout
	exit_ready = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#only on layer 4

#target room and group are separate for convenience in the editor
func _on_body_entered(body):
	if(exit_ready):
		if(!body.target):
			RoomLoader.load_room_from_exit(target_group,target_room,target_entrance)
		
