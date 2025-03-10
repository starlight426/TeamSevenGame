extends CharacterBody2D

@export var hp = 50
@export var team = "circle"
@export var speed = 800
var target = null
var closest_danger = null
var fire_ready = false
@export var fire_rate = 0.5
var rotation_speed = PI/64
var color = "default"
var type = "default"
var angle_to_target
var contact_dmg = 90

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
		
		# fires if target exists
		if(fire_ready):
			fire()
			
	move_and_slide()
	
func fire():
	fire_ready = false
	AttackSpawner.spawn_bullets($bullet_marker_1.global_position,-1*global_rotation,"single",1,0,"default","circle","straight",2000,3,30,"circle","purple",0,0,0)
	AttackSpawner.spawn_bullets($bullet_marker_3.global_position,-1*global_rotation,"single",1,0,"default","circle","straight",2000,3,30,"circle","purple",0,0,0)
	await get_tree().create_timer(1/fire_rate).timeout
	fire_ready = true

func on_hitbox_entered(body):
	if(body.team != team):
		body.take_damage(contact_dmg)
		queue_free()

func update_target(body):
	target = body
	
func take_damage(dmg):
	hp -= dmg
