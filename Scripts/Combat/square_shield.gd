extends CharacterBody2D

@export var hp = 300
@export var team = "square"
@export var speed = 0

var color = "default"
var type = "default"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(team == "cigil"):
		$Sprite2D.modulate = Color.DIM_GRAY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = Vector2(speed,0).rotated(global_rotation)	
	move_and_slide()

	
func take_damage(dmg):
	hp -= dmg
