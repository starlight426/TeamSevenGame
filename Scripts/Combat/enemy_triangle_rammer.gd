extends CharacterBody2D

@export var hp = 100
@export var team = "triangle"
@export var speed = 2000
var target = null
var closest_danger = null
var fire_ready = false
@export var fire_rate = 2.0
var rotation_speed = PI/128
var color = "default"
var type = "default"
var angle_to_target
var contact_dmg = 170

var dash_ready = true
var dashing = false
var dash_direction = 0
var dash_speed = 8000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TargetDetector.update_parent_target.connect(update_target)
	await get_tree().create_timer(0.5).timeout
	fire_ready = true
	#speed_switcher()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (hp <= 0):
		queue_free()
	if(dash_ready):
		dash_cooldown()
		dash()
	if(target):
		global_rotation = lerp_angle(global_rotation,(target.global_position - global_position).angle(),rotation_speed)
		if(dashing):
			velocity = Vector2(dash_speed,0).rotated(dash_direction)
		else:
			velocity = Vector2(speed,0).rotated(global_rotation)
			
	move_and_slide()
	

func dash():
	dash_direction = velocity.angle()
	dashing = true
	await get_tree().create_timer(0.8).timeout
	dashing = false

func dash_cooldown():
	dash_ready = false
	await get_tree().create_timer(4.0).timeout
	dash_ready = true

func on_hitbox_entered(body):
	#print(body)
	#print(body.team)
	if(body.team != team && body.team != "none"):
		body.take_damage(contact_dmg)
		queue_free()
		
func speed_switcher():
	while(true):
		await get_tree().create_timer(6).timeout
		speed /= 4
		await get_tree().create_timer(1).timeout
		speed *= 4
func update_target(body):
	target = body
	
func take_damage(dmg):
	hp -= dmg
