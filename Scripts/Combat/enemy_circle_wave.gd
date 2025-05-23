extends CharacterBody2D

@export var hp = 140
@export var team = "circle"
@export var speed = 400
var target = null
var closest_danger = null
var fire_ready = false
@export var fire_rate = 1.3
var rotation_speed = PI/32
var color = "default"
var type = "default"

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
		velocity = Vector2(speed,0).rotated(global_rotation)
		# smoothly turns to target if it exists
		global_rotation = lerp_angle(global_rotation,(target.global_position - global_position).angle(),rotation_speed)
		# fires if target exists
		if(fire_ready):
			fire()
			
	move_and_slide()
	
func fire():
	fire_ready = false
	AttackSpawner.spawn_bullets($bullet_marker_1.global_position,global_rotation-PI/4,"single",1,0,"default","circle","straight",1800,3,10,"circle","purple",0,0,0)
	AttackSpawner.spawn_bullets($bullet_marker_2.global_position,global_rotation,"single",1,0,"default","circle","straight",1800,3,10,"circle","purple",0,0,0)
	AttackSpawner.spawn_bullets($bullet_marker_3.global_position,global_rotation+PI/4,"single",1,0,"default","circle","straight",1800,3,10,"circle","purple",0,0,0)
	await get_tree().create_timer(1/fire_rate).timeout
	fire_ready = true
	
func update_target(body):
	target = body
	
func take_damage(dmg):
	hp -= dmg
