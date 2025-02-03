extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


spawn_bullets(global_position,global_rotation-PI/2,"single",1,0,"default","circle","straight","default",1,30,"player","purple",0,0,0)
