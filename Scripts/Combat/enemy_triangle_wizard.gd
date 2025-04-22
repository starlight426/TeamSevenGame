extends CharacterBody2D

@export var hp = 120
@export var team = "triangle"
@export var speed = 300
var target = null
var closest_danger = null
var fire_ready = false
@export var fire_rate = 1.0
var rotation_speed = PI/32
var color = "default"
var type = "default"
var strafe_direction = 1
var chase_direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TargetDetector.update_parent_target.connect(update_target)
	await get_tree().create_timer(0.5).timeout
	fire_ready = true
	strafe_direction = randi()%2 * 2 - 1 #this just generates either 1 or -1 lol
	strafe_direction_switcher()
	chase_direction_switcher()
	dash_cycle()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (hp <= 0):
		queue_free()
		
	if(target):
		if(chase_direction == 1):
			velocity = Vector2(speed,speed * strafe_direction).rotated(global_rotation) 
		if(chase_direction == -1):
			velocity = Vector2(speed,speed * strafe_direction).rotated(global_rotation + PI)
		# smoothly turns to target if it exists
		global_rotation = lerp_angle(global_rotation,(target.global_position - global_position).angle(),rotation_speed)
		# fires if target exists
		if(fire_ready):
			fire()		
	move_and_slide()
	
func fire():
	fire_ready = false
	AttackSpawner.spawn_bullets($bullet_marker_1.global_position,global_rotation,"single",1,0,"default","zigzag","zigzag",2000,3,10,"triangle","purple",0,0,0)
	AttackSpawner.spawn_bullets($bullet_marker_2.global_position,global_rotation,"single",1,0,"default","zigzag","zigzag",2000,3,10,"triangle","purple",0,0,0)
	AttackSpawner.spawn_bullets($bullet_marker_3.global_position,global_rotation,"single",1,0,"default","zigzag","zigzag",2000,3,10,"triangle","purple",0,0,0)
	AttackSpawner.spawn_bullets($bullet_marker_4.global_position,global_rotation,"single",1,0,"default","zigzag","zigzag",2000,3,10,"triangle","purple",0,0,0)
	AttackSpawner.spawn_bullets($bullet_marker_5.global_position,global_rotation,"single",1,0,"default","zigzag","zigzag",2000,3,10,"triangle","purple",0,0,0)
	await get_tree().create_timer(1/fire_rate).timeout
	fire_ready = true
	
func strafe_direction_switcher():
	while(true):
		await get_tree().create_timer(1.0).timeout
		strafe_direction = randi()%2 * 2 - 1
		await get_tree().create_timer(3.0).timeout
		
func chase_direction_switcher():
	while(true):
		await get_tree().create_timer(2.0).timeout
		chase_direction = 1
		await get_tree().create_timer(4.0).timeout
		chase_direction = -1
	
func dash_cycle():
	while(true):
		await get_tree().create_timer(float(randi()%5)).timeout
		speed *= 6
		await get_tree().create_timer(0.3).timeout
		speed /= 6
	
func update_target(body):
	target = body
	
func take_damage(dmg):
	hp -= dmg
