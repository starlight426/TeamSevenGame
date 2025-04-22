extends CharacterBody2D

@export var hp = 100
@export var team = "cigil"
@export var speed = 3000
var target = null
var closest_danger = null
var fire_ready = false
@export var fire_rate = 2.0
var rotation_speed = PI/100
var color = "default"
var type = "default"
var angle_to_target
var contact_dmg = 150

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TargetDetector.update_parent_target.connect(update_target)
	await get_tree().create_timer(0.5).timeout
	fire_ready = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (hp <= 0):
		queue_free()
	
	if(target):
		global_rotation = lerp_angle(global_rotation,(target.global_position - global_position).angle(),rotation_speed)
		velocity = Vector2(speed,0).rotated(global_rotation)
		
	
	
	move_and_slide()


func on_hitbox_entered(body):
	#print(body)
	#print(body.team)
	if(body.team != team && body.team != "none"):
		body.take_damage(contact_dmg)
		queue_free()

func update_target(body):
	target = body
	
func take_damage(dmg):
	hp -= dmg
