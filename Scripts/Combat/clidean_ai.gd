extends CharacterBody2D

#main functionality variables
@export var hp = 1000
var max_hp
@export var team = "circle"
@export var speed = 600  #speed

#phase variables
var phase = "intro"
var movement_mode = "slow_strafe"


#passive firing variables
@export var passive_fire_rate = 4.0  #time between passive bullet bursts
var passive_fire_direction = 0.0
var passive_fire_ready = true
var firing_passive_bullets = true

#movement variables
@export var strafe_interval = 3.0  #time before switching strafe direction
var is_switching_strafe_direction = true
var strafe_direction = 1  # 1 for clockwise, -1 for counterclockwise

var target = null

var can_attack = true

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TargetDetector.update_parent_target.connect(update_target)
	
	max_hp = hp
	phase_switcher()
	intro_phase_cycle()
	aggressive_phase_cycle()
	passive_fire_cycle()
	

func phase_switcher():
	while(true):
		if(hp > 2*max_hp/3):
			phase = "intro"
		if(hp <= 2*max_hp/3 && hp > max_hp/3):
			phase = "aggressive"
		if(hp <= max_hp/3 && hp > 0):
			phase = "artillery"
	get_tree().create_timer(0.3).timeout

#func static_phase_changes_manager():
	#while(true):
	#	if(phase == "intro"):
		#	passive_
	#	get_tree().create_timer(0.3).timeout

#exception handler
func do_phase_action(passed_phase,action):
	if(passed_phase == phase):
		match action:
			"intro_circles_attack":
				intro_circles_attack()
			"intro_striker_attack":
				pass
			
		

func intro_phase_cycle():
	while(true):
		if(phase == "intro"):
			passive_fire_rate = 0.3
			
			
		get_tree().create_timer(0.3).timeout
		
func aggressive_phase_cycle():
	while(true):
		if(phase == "aggressive"):
			pass
		get_tree().create_timer(0.3).timeout

func artillery_phase_cycle():
	while(true):
		if(phase == "artillery"):
			pass
		get_tree().create_timer(0.3).timeout

func passive_fire_cycle():
	while(true):
		passive_fire_direction = passive_fire_direction - PI + rng.randf_range(-2*PI/3,2*PI/3)
		AttackSpawner.spawn_bullets(global_position,passive_fire_direction,"single",1,0,"default","circle","straight",2000,3,30,"circle","purple",0,0,0)
		await get_tree().create_timer(1/passive_fire_rate).timeout
	
func _physics_process(delta: float) -> void:
	if (hp <= 0):
		queue_free()
	if target:
		# Strafe movement
		var direction_to_player = (target.global_position - global_position).normalized()
		var perpendicular_direction = direction_to_player.rotated(PI / 2 * strafe_direction)
		velocity = perpendicular_direction * speed
		move_and_slide()

func intro_circles_attack():
	AttackSpawner.spawn_bullet_collection(global_position,global_rotation,"circle_of_bullets","straight",2000,"circle",0,0,0)
	await get_tree().create_timer(0.7).timeout
	AttackSpawner.spawn_bullet_collection(global_position,global_rotation,"circle_of_bullets","straight",2000,"circle",0,0,0)
	await get_tree().create_timer(0.7).timeout
	AttackSpawner.spawn_bullet_collection(global_position,global_rotation,"circle_of_bullets","straight",2000,"circle",0,0,0)

func intro_striker_attack():
	for i in range(0,5):
		AttackSpawner.spawn_bullets(global_position,global_rotation+PI/2,"single",1,0,"default","circle","striker",1500,3,10,"circle","purple",PI/100,target,0)
		AttackSpawner.spawn_bullets(global_position,global_rotation-PI/2,"single",1,0,"default","circle","striker",1500,3,10,"circle","purple",PI/100,target,0)
		await get_tree().create_timer(0.4).timeout
		
func aggressive_striker_burst():
	for i in range(0,5):
		AttackSpawner.spawn_bullets(global_position + Vector2(rng.randf_range(-30,30),rng.randf_range(-30,30)),global_rotation+(PI/2 + (rng.randi_range(0,1)*2-1)),"single",1,0,"default","circle","striker",1500,3,10,"circle","purple",PI/100,target,0)
	
func aggressive_orbiting_circle():
	AttackSpawner.spawn_bullet_collection(global_position,global_rotation,"circle_of_bullets","arc",2000,"circle",PI/3,10.0,0)

func artillery_summon():
	var new_striker = load("res://Combat Scenes/Enemy Scenes/enemy_circle_striker.tscn").instantiate()
	new_striker.global_position = global_position
	add_sibling(new_striker)

func artillery_bullet_circle():
	AttackSpawner.spawn_bullet_collection(global_position,global_rotation,"circle_of_bullets","striker",2000,"circle",PI/3,10.0,0)
	
func update_target(body):
	target = body

func take_damage(dmg):
	hp -= dmg
