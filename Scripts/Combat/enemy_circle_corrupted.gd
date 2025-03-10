extends CharacterBody2D

@export var hp = 50
@export var team = "circle"
@export var speed = 1000
var target = null
var closest_danger = null
var fire_ready = false
var turn_ready = false
var home_position = global_position
var fire_direction = global_rotation
var turn_angle = global_rotation
@export var fire_rate = 4.0
@export var turn_rate = 0.5
var rotation_speed = PI/16
var color = "default"
var type = "default"
var rng

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TargetDetector.update_parent_target.connect(update_target)
	await get_tree().create_timer(0.5).timeout
	fire_ready = true
	turn_ready = true
	rng = RandomNumberGenerator.new()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (hp <= 0):
		queue_free()
	if(fire_ready):
		fire()
	#TODO: make it actually move towards target angle, will fix
	if(turn_ready):
		if(target):
			# turns vaguely towards target if it exists
			home_position = global_position
			turn_angle = (target.global_position - global_position).angle()+rng.randf_range(-PI/2,PI/2)
		else:
			pass
			if(global_position.distance_to(home_position) > 2000):
				# turns sharply towards home if far away
				turn_angle = (home_position - global_position).angle()+rng.randf_range(-PI/6,PI/6)
			else:
				# turns vaguely towards home 
				turn_angle = (home_position - global_position).angle()+rng.randf_range(-PI/2,PI/2)
		turn_cooldown()
	global_rotation = lerp_angle(global_rotation,turn_angle,rotation_speed)
	velocity = Vector2(speed,0).rotated(global_rotation)
	move_and_slide()
	
func fire():
	fire_ready = false
	fire_direction = fire_direction - PI + rng.randf_range(-2*PI/3,2*PI/3)
	AttackSpawner.spawn_bullets(global_position,fire_direction,"single",1,0,"default","circle","straight",2000,3,30,"circle","purple",0,0,0)
	await get_tree().create_timer(1/fire_rate).timeout
	fire_ready = true

func turn_cooldown():
	turn_ready = false
	await get_tree().create_timer(1/turn_rate).timeout
	turn_ready = true
func update_target(body):
	target = body
	
func take_damage(dmg):
	hp -= dmg
