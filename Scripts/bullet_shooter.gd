extends Node2D

@export var fire_rate = 1.0
@export var bullet_shape = "circle"
@export var bullet_type = "straight"

func _ready() -> void:
	shooter()
	
func shooter():
	while(true):
		AttackSpawner.spawn_bullets(global_position,global_rotation,"single",1,0,"default",bullet_shape,bullet_type,2000,3,10,"circle","purple",0,0,0)
		get_tree().create_timer(1.0/fire_rate).timeout
