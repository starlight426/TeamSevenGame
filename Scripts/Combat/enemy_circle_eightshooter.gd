extends CharacterBody2D

@export var hp = 180
@export var team = "circle"
@export var speed = 250
var target = null
var closest_danger = null
var fire_ready = false
@export var fire_rate = 1.0
var rotation_speed = PI/64
var color = "default"
var type = "default"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TargetDetector.update_parent_target.connect(update_target)
	await get_tree().create_timer(0.5).timeout
	fire_ready = true
	speed_switcher()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (hp <= 0):
		queue_free()
	if(target):
		velocity = Vector2(speed,0).rotated(global_rotation)
		# smoothly turns to target if it exists
		global_rotation = lerp_angle(global_rotation,(target.global_position - global_position).angle(),rotation_speed)
		# fires if target exists
		if(fire_ready):
			fire()
			
	move_and_slide()
	
func fire():
	fire_ready = false
	AttackSpawner.spawn_bullets(global_position,global_rotation-PI,"single",1,0,"default","circle","straight",2000,3,20,"circle","purple",0,0,0)
	AttackSpawner.spawn_bullets(global_position,global_rotation,"single",1,0,"default","circle","straight",2000,3,20,"circle","purple",0,0,0)
	AttackSpawner.spawn_bullets(global_position,global_rotation-PI/4,"single",1,0,"default","circle","straight",2000,3,20,"circle","purple",0,0,0)
	AttackSpawner.spawn_bullets(global_position,global_rotation+PI/4,"single",1,0,"default","circle","straight",2000,3,20,"circle","purple",0,0,0)
	AttackSpawner.spawn_bullets(global_position,global_rotation-PI/2,"single",1,0,"default","circle","straight",2000,3,20,"circle","purple",0,0,0)
	AttackSpawner.spawn_bullets(global_position,global_rotation+PI/2,"single",1,0,"default","circle","straight",2000,3,20,"circle","purple",0,0,0)
	AttackSpawner.spawn_bullets(global_position,global_rotation-3*PI/4,"single",1,0,"default","circle","straight",2000,3,20,"circle","purple",0,0,0)
	AttackSpawner.spawn_bullets(global_position,global_rotation+3*PI/4,"single",1,0,"default","circle","straight",2000,3,20,"circle","purple",0,0,0)
	await get_tree().create_timer(1/fire_rate).timeout
	fire_ready = true

func speed_switcher():
	while(true):
		await get_tree().create_timer(3).timeout
		speed *= 6
		rotation_speed /= 6
		await get_tree().create_timer(3).timeout
		speed /= 6
		rotation_speed *= 6

func update_target(body):
	target = body
	
func take_damage(dmg):
	hp -= dmg
