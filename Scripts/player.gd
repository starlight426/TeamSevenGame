extends CharacterBody2D

@export var speed = 2200
@export var hp = 200
@export var max_hp = hp
@export var energy = 0
@export var team = "cigil"
var attack_shape = "circle"
var move_readiness = [true,true,true,true,true]
var move_cooldowns = [0.4,0.6,0.8,3.0,5.0,0.6,0.5,0.3,0.3,8.0,0.5,1.0,3.0,0.8,10.0]
var move_cooldown_percentages = [100, 100, 100, 100, 100]
var energy_ready = true
var is_paused = false
var target = null

var dashing = false
var dash_direction = 0.0
var dash_speed = 8000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2(0.5,0.5)
	$TargetDetector.update_parent_target.connect(update_target)
	hp_regen()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(hp <= 0):
		hp = max_hp
		die()
		
	
	if(energy_ready):
		add_energy()
		
	if !is_paused:
		# set the player's rotation towards the mouse
		global_rotation = (get_global_mouse_position() - global_position).angle()
		
		if(!dashing):
			# check for movement keys and set movement vector accordingly
			var movement = Vector2.ZERO
			if Input.is_action_pressed("d_press"):
				movement.x += 1
			if Input.is_action_pressed("a_press"):
				movement.x -= 1
			if Input.is_action_pressed("s_press"):
				movement.y += 1
			if Input.is_action_pressed("w_press"):
				movement.y -= 1
				
			if movement != Vector2.ZERO:
				movement = movement.normalized()
			velocity = movement * speed
		else:
			velocity = Vector2(dash_speed,0).rotated(dash_direction)
			
		
		if Input.is_action_pressed("left_click"):
			use_attack(attack_shape + "_basic")
		if Input.is_action_pressed("right_click"):
			use_attack(attack_shape + "_wave")
		if Input.is_action_pressed("e_press"):
			use_attack(attack_shape + "_special")
		if Input.is_action_pressed("shift_press"):
			match attack_shape:
				"circle":
					use_attack("speedup")
				"triangle":
					use_attack("short_dash")
				"square":
					use_attack("long_dash")
		if Input.is_action_pressed("q_press"):
			use_attack(attack_shape + "_summon")
		move_and_slide()
	
func use_attack(attack):
	match attack:
		"circle_basic":
			if(energy >= 20 && move_readiness[0]):
					AttackSpawner.spawn_bullets(global_position,global_rotation,"single",1,0,"default","circle","straight",3500,3,10,"cigil","cigil",0,0,0)
					move_cooldown(0)
					energy -= 20
		"circle_wave":
			if(energy >= 30 && move_readiness[1]):
				AttackSpawner.spawn_bullets(global_position,global_rotation,"single",1,0,"default","circle","straight",3000,3,10,"cigil","cigil",0,0,0)
				AttackSpawner.spawn_bullets(global_position,global_rotation+PI/6,"single",1,0,"default","circle","straight",3000,3,10,"cigil","cigil",0,0,0)
				AttackSpawner.spawn_bullets(global_position,global_rotation-PI/6,"single",1,0,"default","circle","straight",3000,3,10,"cigil","cigil",0,0,0)
				move_cooldown(1)
				energy -= 30
		"circle_special":
			if(energy >= 45 && move_readiness[2]):
					AttackSpawner.spawn_bullets(global_position,global_rotation+PI/3,"single",1,0,"default","circle","striker",3000,3,10,"cigil","purple",PI/50,target,7.0)
					AttackSpawner.spawn_bullets(global_position,global_rotation-PI/3,"single",1,0,"default","circle","striker",3000,3,10,"cigil","purple",PI/50,target,7.0)
					move_cooldown(2)
					energy -= 45
		"speedup":
			if(energy >= 100 && move_readiness[3]):
				speedup()
				move_cooldown(3)
				energy -= 100
		"circle_summon":
			if(energy >= 80 && move_readiness[4]):
				var new_summon = load("res://Combat Scenes/Solid Scenes/circle_turret_summon.tscn").instantiate()
				new_summon.position = position
				new_summon.global_rotation = global_rotation
				RoomLoader.current_room.add_child(new_summon)
				move_cooldown(4)
				energy -= 80
		"triangle_basic":
			if(energy >= 20 && move_readiness[0]):
				AttackSpawner.spawn_bullets($twoshotmarker1.global_position,global_rotation,"single",1,0,"default","triangle","straight",3500,3,10,"cigil","cigil",0,0,0)
				AttackSpawner.spawn_bullets($twoshotmarker2.global_position,global_rotation,"single",1,0,"default","triangle","straight",3500,3,10,"cigil","cigil",0,0,0)
				move_cooldown(0)
				energy -= 20
		"triangle_wave":
			if(energy >= 30 && move_readiness[1]):
				AttackSpawner.spawn_bullets($fiveshotmarker1.global_position,global_rotation,"single",1,0,"default","triangle","straight",3000,3,10,"cigil","cigil",0,0,0)
				AttackSpawner.spawn_bullets($fiveshotmarker2.global_position,global_rotation+PI/4,"single",1,0,"default","triangle","straight",3000,3,10,"cigil","cigil",0,0,0)
				AttackSpawner.spawn_bullets($fiveshotmarker4.global_position,global_rotation-PI/4,"single",1,0,"default","triangle","straight",3000,3,10,"cigil","cigil",0,0,0)
				AttackSpawner.spawn_bullets($fiveshotmarker3.global_position,global_rotation+PI/2,"single",1,0,"default","triangle","straight",3000,3,10,"cigil","cigil",0,0,0)
				AttackSpawner.spawn_bullets($fiveshotmarker5.global_position,global_rotation-PI/2,"single",1,0,"default","triangle","straight",3000,3,10,"cigil","cigil",0,0,0)
				move_cooldown(1)
				energy -= 30
		"triangle_special":
			if(energy >= 45 && move_readiness[2]):
				AttackSpawner.spawn_bullets($fiveshotmarker1.global_position,global_rotation,"single",1,0,"default","zigzag","zigzag",3000,3,20,"cigil","cigil",0,0,0)
				AttackSpawner.spawn_bullets($fiveshotmarker3.global_position,global_rotation,"single",1,0,"default","zigzag","zigzag",3000,3,20,"cigil","cigil",0,0,0)
				AttackSpawner.spawn_bullets($fiveshotmarker5.global_position,global_rotation,"single",1,0,"default","zigzag","zigzag",3000,3,20,"cigil","cigil",0,0,0)
				move_cooldown(2)
				energy -= 45
		"short_dash":
			if(energy >= 20 && move_readiness[3]):
				short_dash()
				move_cooldown(3)
				energy -= 20
		"triangle_summon":
			if(energy >= 80 && move_readiness[4]):
				var new_summon = load("res://Combat Scenes/Solid Scenes/triangle_summon.tscn").instantiate()
				new_summon.position = position
				new_summon.global_rotation = global_rotation
				RoomLoader.current_room.add_child(new_summon)
				move_cooldown(4)
				energy -= 80
		"square_basic":
			pass
		"square_wave":
			pass
		"square_special":
			pass
		"long_dash":
			pass
		"square_shield":
			pass
		
			
func move_cooldown(move_num):
	#adapts to triangle/square moves
	
	var move_shape_offset = 0
	if(attack_shape == "triangle"):
		move_shape_offset = 1
	if(attack_shape == "square"):
		move_shape_offset = 2
	
	move_readiness[move_num] = false
	var timer = get_tree().create_timer(move_cooldowns[move_num+move_shape_offset*5])
	var percentage_completed = 0.0
	var time_passed = 0.0
	while timer.time_left > 0:
		time_passed = move_cooldowns[move_num+move_shape_offset*5] - timer.time_left
		move_cooldown_percentages[move_num] = (time_passed / move_cooldowns[move_num+move_shape_offset*5]) * 100
		await get_tree().create_timer(0).timeout
	
	move_readiness[move_num] = true
	
func speedup():
	speed *= 2.0
	await get_tree().create_timer(3).timeout
	speed /= 2.0

func short_dash():
	dash_direction = velocity.angle()
	dashing = true
	await get_tree().create_timer(0.3).timeout
	dashing = false
		
func long_dash():
	dash_direction = velocity.angle()
	dashing = true
	await get_tree().create_timer(1.0).timeout
	dashing = false

func unlock(unlock_type):
	attack_shape = unlock_type
	
func add_energy():
	energy_ready = false

	if(energy < 100):
		energy += 5
	if(energy < 300):
		energy += 5
	if(energy < 500):
		energy += 10
	await get_tree().create_timer(0.5).timeout
	energy_ready = true

func hp_regen():
	while(true):
		await get_tree().create_timer(3.0).timeout
		if(hp < 200):
			hp += 5
	
func die():
	RoomLoader.player_die()
	
func update_target(body):
	target = body

func take_damage(dmg):
	hp -= dmg
	
	if(hp <= 0):
		hp == 100
