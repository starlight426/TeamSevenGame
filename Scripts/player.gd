extends CharacterBody2D

@export var speed = 2200
@export var hp = 200
@export var max_hp = hp
@export var energy = 0
@export var team = "cigil"
var attack_shape = "circle"
var move_readiness = [true,true,true,true,true]
var move_cooldowns = [0.4,0.6,0.8,3.0,5.0]
var move_cooldown_percentages = [100, 100, 100, 100, 100]
var energy_ready = true
var is_paused = false
var target = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2(0.5,0.5)
	$TargetDetector.update_parent_target.connect(update_target)
	pass # Replace with function body.

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
					AttackSpawner.spawn_bullets(global_position,global_rotation+PI/3,"single",1,0,"default","circle","striker",3000,3,10,"cigil","purple",PI/50,target,0)
					AttackSpawner.spawn_bullets(global_position,global_rotation-PI/3,"single",1,0,"default","circle","striker",3000,3,10,"cigil","purple",PI/50,target,0)
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
			pass
		"triangle_wave":
			pass
		"triangle_special":
			pass
		"short_dash":
			pass
		"triangle_summon":
			pass
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
	move_readiness[move_num] = false
	var timer = get_tree().create_timer(move_cooldowns[move_num])
	var percentage_completed = 0.0
	var time_passed = 0.0
	while timer.time_left > 0:
		time_passed = move_cooldowns[move_num] - timer.time_left
		move_cooldown_percentages[move_num] = (time_passed / move_cooldowns[move_num]) * 100
		await get_tree().create_timer(0).timeout
	
	move_readiness[move_num] = true
	
func speedup():
	speed *= 2.0
	await get_tree().create_timer(3).timeout
	speed /= 2.0

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
	
func die():
	RoomLoader.player_die()
	
func update_target(body):
	target = body

func take_damage(dmg):
	hp -= dmg
	
	if(hp <= 0):
		hp == 100
