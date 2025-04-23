extends CharacterBody2D

#main functionality variables
@export var hp = 1500
var max_hp
@export var team = "triangle"
@export var speed = 1100 #speed

#phase variables
var phase = "intro"
var movement_mode = "slow_strafe"


#passive firing variables
@export var passive_fire_rate = 0.5  #time between passive bullet bursts
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
	dash_cycle()
	
func dash_cycle():
	while(true):
		await get_tree().create_timer(float(randi()%6 + 1)).timeout
		speed *= 4
		await get_tree().create_timer(0.4).timeout
		speed /= 4

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
		
			"aggressive_orbiting_circle":
				aggressive_orbiting_circle()
			"aggressive_bullet_burst":
				aggressive_bullet_burst()
			
		

func intro_phase_cycle():
	await get_tree().create_timer(1.0).timeout
	while(true):
		if(phase == "intro"):
			passive_fire_rate = 0.8
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
			passive_fire_rate = 0.9
			
			
			await get_tree().create_timer(5.0).timeout
			do_phase_action("aggressive","aggressive_bullet_burst")
			await get_tree().create_timer(5.0).timeout
			do_phase_action("aggressive","aggressive_bullet_burst")
			await get_tree().create_timer(5.0).timeout
			do_phase_action("aggressive","aggressive_orbiting_circle")
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
		AttackSpawner.spawn_bullets($passive_marker_1.global_position,global_rotation,"single",1,0,"default","triangle","straight",2600,3,10,"triangle","purple",0,0,0)
		AttackSpawner.spawn_bullets($passive_marker_2.global_position,global_rotation-PI/6,"single",1,0,"default","triangle","straight",2600,3,10,"triangle","purple",0,0,0)
		AttackSpawner.spawn_bullets($passive_marker_3.global_position,global_rotation+PI/6,"single",1,0,"default","triangle","straight",2600,3,10,"triangle","purple",0,0,0)
		AttackSpawner.spawn_bullets($passive_marker_4.global_position,global_rotation-PI/3,"single",1,0,"default","triangle","straight",2600,3,10,"triangle","purple",0,0,0)
		AttackSpawner.spawn_bullets($passive_marker_5.global_position,global_rotation+PI/3,"single",1,0,"default","triangle","straight",2600,3,10,"triangle","purple",0,0,0)
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
	#print("did triangle attack")
	for i in range(0,3):
		AttackSpawner.spawn_bullets($passive_marker_1.global_position,global_rotation,"single",1,0,"default","triangle","straight",3000,3,10,"triangle","purple",0,0,0)
		AttackSpawner.spawn_bullets($passive_marker_2.global_position,global_rotation,"single",1,0,"default","triangle","straight",3000,3,10,"triangle","purple",0,0,0)
		AttackSpawner.spawn_bullets($passive_marker_3.global_position,global_rotation,"single",1,0,"default","triangle","straight",3000,3,10,"triangle","purple",0,0,0)
		AttackSpawner.spawn_bullets($passive_marker_4.global_position,global_rotation,"single",1,0,"default","triangle","straight",3000,3,10,"triangle","purple",0,0,0)
		AttackSpawner.spawn_bullets($passive_marker_5.global_position,global_rotation,"single",1,0,"default","triangle","straight",3000,3,10,"triangle","purple",0,0,0)
		await get_tree().create_timer(0.4).timeout

func intro_striker_attack():
	#print("did lightning attack")
	for i in range(0,11):
		AttackSpawner.spawn_bullets(global_position,global_rotation,"single",1,0,"default","zigzag","zigzag",4500,3,15,"triangle","purple",0,0,0)
		await get_tree().create_timer(0.1).timeout
		
		
	
func aggressive_orbiting_circle():
	#print("did rammer attack")
	var new_summon = load("res://Combat Scenes/Enemy Scenes/enemy_triangle_rammer.tscn").instantiate()
	new_summon.global_position = global_position
	new_summon.global_rotation = global_rotation
	new_summon.hp = 70
	RoomLoader.current_room.add_child(new_summon)

func aggressive_bullet_burst():
	#print("did zigzag bursta attack")
	for i in range(0,9):
		AttackSpawner.spawn_bullets(global_position,global_rotation+rng.randf_range(-1*PI/6,1*PI/6),"single",1,0,"default","zigzag","zigzag",4000,3,20,"triangle","purple",0,0,0)
		await get_tree().create_timer(0.1).timeout
		
func artillery_summon():
	var new_striker = load("res://Combat Scenes/Enemy Scenes/enemy_circle_striker.tscn").instantiate()
	new_striker.global_position = global_position
	add_sibling(new_striker)

func artillery_bullet_circle():
	AttackSpawner.spawn_bullet_collection(global_position, rng.randf_range(0,2*PI),"circle_of_bullets","striker",2000,"circle",PI/3,10.0,0)
	
func update_target(body):
	target = body

func take_damage(dmg):
	hp -= dmg
