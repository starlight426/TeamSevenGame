extends CharacterBody2D
@export var speed = 600

func _ready() -> void:
	velocity = Vector2(speed,0).rotated(global_rotation)
	await get_tree().create_timer(10.0).timeout
	queue_free()
func _physics_process(delta):
	global_rotation += PI/64
	move_and_slide()
