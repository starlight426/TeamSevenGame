extends CharacterBody2D

#main functionality variables
@export var hp = 4000
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
var rotation_speed = PI/16

var target = null

var can_attack = true

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TargetDetector.update_parent_target.connect(update_target)
	MainMusicPlayer._play_boss_music()
	max_hp = hp
	phase_switcher()
	intro_phase_cycle()
	aggressive_phase_cycle()
	passive_fire_cycle()
	

func phase_switcher():
	await get_tree().create_timer(1.0).timeout
	while(true):
		if(hp <= max_hp && hp > max_hp/2):
			phase = "intro"
		if(hp <= max_hp/2 ):
			phase = "aggressive"
	#	if(hp > 2*max_hp/3):
	#		phase = "intro"
	#	if(hp <= 2*max_hp/3 && hp > max_hp/3):
	#		phase = "aggressive"
	#	if(hp <= max_hp/3 && hp > 0):
	#		phase = "artillery"
		await get_tree().create_timer(0.3).timeout

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
				intro_striker_attack()
			"aggressive_striker_burst":
				aggressive_striker_burst()
			"aggressive_orbiting_circle":
				aggressive_orbiting_circle()
			"aggresive_bullet_burst":
				aggressive_bullet_burst()
			
		

func intro_phase_cycle():
	await get_tree().create_timer(1.0).timeout
	while(true):
		if(phase == "intro"):
			passive_fire_rate = 6.0
			await get_tree().create_timer(4.0).timeout
			do_phase_action("intro","intro_circles_attack")
			await get_tree().create_timer(4.0).timeout
			do_phase_action("intro","intro_striker_attack")
		await get_tree().create_timer(0.3).timeout
		
func aggressive_phase_cycle():
	await get_tree().create_timer(1.0).timeout
	while(true):
		if(phase == "aggressive"):
			movement_mode = "slow_chase"
			passive_fire_rate = 9.0
			await get_tree().create_timer(4.0).timeout
			do_phase_action("aggressive","aggressive_striker_burst")
			await get_tree().create_timer(3.0).timeout
			do_phase_action("aggressive","aggressive_orbiting_circle")
			await get_tree().create_timer(2.0).timeout
			do_phase_action("aggressive","aggressive_bullet_burst")
		await get_tree().create_timer(0.3).timeout

func artillery_phase_cycle():
	await get_tree().create_timer(1.0).timeout
	while(true):
		if(phase == "artillery"):
			pass
		await get_tree().create_timer(0.3).timeout

func passive_fire_cycle():
	await get_tree().create_timer(1.0).timeout
	while(true):
		passive_fire_direction = passive_fire_direction - PI + rng.randf_range(-2*PI/3,2*PI/3)
		AttackSpawner.spawn_bullets(global_position,passive_fire_direction,"single",1,0,"default","circle","straight",2000,2,20,"circle","purple",0,0,0)
		await get_tree().create_timer(1/passive_fire_rate).timeout
	
func _physics_process(delta: float) -> void:
	$hp_tracker.text = str(hp)
	if (hp <= 0):
		queue_free()
	if(target):
		if(movement_mode == "slow_chase"):
			velocity = Vector2(speed,0).rotated(global_rotation)
		if(movement_mode == "slow_strafe"):
			velocity = Vector2(speed,speed * strafe_direction).rotated(global_rotation) 
			# + (strafe_direction * PI/2)
		# smoothly turns to target if it exists
		global_rotation = lerp_angle(global_rotation,(target.global_position - global_position).angle(),rotation_speed)
	
	move_and_slide()

func intro_circles_attack():
	AttackSpawner.spawn_bullet_collection(global_position,global_rotation,"circle_of_bullets","straight",2000,"circle",0,0,0)
	await get_tree().create_timer(0.7).timeout
	AttackSpawner.spawn_bullet_collection(global_position,global_rotation,"circle_of_bullets","straight",2000,"circle",0,0,0)
	await get_tree().create_timer(0.7).timeout
	AttackSpawner.spawn_bullet_collection(global_position,global_rotation,"circle_of_bullets","straight",2000,"circle",0,0,0)

func intro_striker_attack():
	for i in range(0,5):
		AttackSpawner.spawn_bullets(global_position,global_rotation-PI/2,"single",1,0,"default","circle","striker",2500,3,10,"circle","purple",PI/150,target,0)
		AttackSpawner.spawn_bullets(global_position,global_rotation+PI/2,"single",1,0,"default","circle","striker",2500,3,10,"circle","purple",PI/150,target,0)
		await get_tree().create_timer(0.8).timeout
		
func aggressive_striker_burst():
	for i in range(0,5):
		AttackSpawner.spawn_bullets(global_position + Vector2(rng.randf_range(-30,30),rng.randf_range(-30,30)),global_rotation+(PI/2 + (rng.randi_range(0,1)*2-1)),"single",1,0,"default","circle","striker",2800,3,10,"circle","purple",PI/100,target,0)
		await get_tree().create_timer(0.1).timeout
	
func aggressive_orbiting_circle():
	AttackSpawner.spawn_bullet_collection(global_position,global_rotation,"circle_of_bullets","arc",2000,"circle",PI/3,10.0,0)

func aggressive_bullet_burst():
	for i in range(0,6):
		AttackSpawner.spawn_bullets(global_position,global_rotation,"single",1,0,"default","circle","straight",2000,3,20,"circle","purple",0,0,0)
		await get_tree().create_timer(0.1).timeout
		
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
