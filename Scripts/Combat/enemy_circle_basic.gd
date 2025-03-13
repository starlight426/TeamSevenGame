extends CharacterBody2D

@export var hp = 50
@export var team = "circle"
@export var speed = 700
var target = null
var closest_danger = null
var fire_ready = false
@export var fire_rate = 1.0
var rotation_speed = PI/32
var color = "default"
var type = "default"
enum {CHASING, STRAFING} 
var movement_mode = CHASING
var strafe_direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TargetDetector.update_parent_target.connect(update_target)
	await get_tree().create_timer(0.5).timeout
	fire_ready = true
	strafe_direction = randi()%2 * 2 - 1 #this just generates either 1 or -1 lol
	movement_mode_switcher()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (hp <= 0):
		queue_free()
		
	if(target):
		if(movement_mode == CHASING):
			velocity = Vector2(speed,0).rotated(global_rotation)
		if(movement_mode == STRAFING):
			velocity = Vector2(speed,speed * strafe_direction).rotated(global_rotation) 
			# + (strafe_direction * PI/2)
		# smoothly turns to target if it exists
		global_rotation = lerp_angle(global_rotation,(target.global_position - global_position).angle(),rotation_speed)
		# fires if target exists
		if(fire_ready):
			fire()		
	move_and_slide()
	
func fire():
	fire_ready = false
	AttackSpawner.spawn_bullets(global_position,global_rotation,"single",1,0,"default","circle","straight",2000,3,10,"circle","purple",0,0,0)
	await get_tree().create_timer(1/fire_rate).timeout
	fire_ready = true
	
func movement_mode_switcher():
	while(true):
		movement_mode = CHASING
		await get_tree().create_timer(2.0).timeout
		strafe_direction = randi()%2 * 2 - 1
		movement_mode = STRAFING
		await get_tree().create_timer(3.0).timeout
func update_target(body):
	target = body
	
func take_damage(dmg):
	hp -= dmg
