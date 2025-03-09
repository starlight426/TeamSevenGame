extends CharacterBody2D

@export var hp = 1000
var max_hp = hp
@export var team = "circle"
var target = null
var last_shot_angle = 0.0
var fire_ready = false
var passive_fire_rate = 0.3
var firing_passive_bullets = false
var rotation_speed = PI / 32
var color = "default"
var type = "default"
var move_mode = "chase"
var strafe_direction = "clockwise"
var move_speed = 1000
@export var bullet_speed = 1000
@export var bullet_count = 8

var phase = 1  # Tracks the current phase

# Called when the node enters the scene
func _ready() -> void:
	$TargetDetector.update_parent_target.connect(update_target)
	await get_tree().create_timer(0.5).timeout
	fire_ready = true
	
func start_battle():
	pass
	
# Called every frame
func _physics_process(delta: float) -> void:
	if target:
		# Handle movement and firing
		move_based_on_mode(delta)
		global_rotation = lerp_angle(global_rotation, (target.global_position - global_position).angle(), rotation_speed)

	if fire_ready:
		passive_fire()

		# Handle mode switching
		#mode_switch_timer -= delta
		#if mode_switch_timer <= 0:
		#	choose_random_move_mode()
		#	mode_switch_timer = mode_switch_interval

		# Check phase changes based on HP
		check_phase()

# Movement functions
func move_based_on_mode(delta: float) -> void:
	if move_mode == "chase":
		# Move towards the player
		var direction = (target.global_position - global_position).normalized() * move_speed
		velocity = direction
		move_and_slide()
	elif move_mode == "strafe":
		# Strafing movement
		var direction = 1 if strafe_direction == "clockwise" else -1
		var rotation_speed_strafe = PI / 4 * direction
		global_rotation += rotation_speed_strafe * delta
		velocity = Vector2.ZERO
	elif move_mode == "stay":
		# Stay still
		velocity = Vector2.ZERO

# Shooting function
func passive_fire() -> void:
	var random_angle = randf_range(PI/2, 3 * PI/2) + last_shot_angle
	last_shot_angle = random_angle

	# Reset fire readiness after cooldown
	fire_ready = false
	await get_tree().create_timer(1/passive_fire_rate).timeout
	fire_ready = true

# Fire basic bullets in a simple circle pattern
func fire_basic_bullets():
	for i in range(bullet_count):
		var angle = last_shot_angle + (i * (2 * PI / bullet_count))
		AttackSpawner.spawn_bullets(global_position, angle, "single", 1, 0, "default", "circle", "straight", bullet_speed, 2, 30, "circle", "purple", 0, 0, 0)

# Fire aggressive bullets with bursts
func fire_aggressive_bullets():
	for i in range(bullet_count):
		var angle = last_shot_angle + (i * (2 * PI / bullet_count))
		AttackSpawner.spawn_bullets(global_position, angle, "3cone", 1, 0, "default", "circle", "straight", bullet_speed * 1.2, 2, 30, "circle", "red", 0, 0, 0)

# Fire artillery-style bullets with expanding circles
func fire_artillery_bullets():
	for i in range(4):
		AttackSpawner.spawn_bullets(global_position, last_shot_angle, "6cone", 1, 0.5 * i, "default", "circle", "expanding", bullet_speed * 0.8, 3, 50, "circle", "blue", 0, 0, 0)

# Fire dense bullet patterns and summon projections
func fire_chaos_bullets():
	for i in range(12):
		var angle = last_shot_angle + (i * (2 * PI / 12))
		AttackSpawner.spawn_bullets(global_position, angle, "7cone", 1, 0, "default", "circle", "straight", bullet_speed * 1.5, 3, 30, "circle", "yellow", 0, 0, 0)

# Function to check and update phase based on HP
func check_phase():
	if hp <= 750 and phase == 1:
		phase = 2
		passive_fire_rate = 1.5
		move_speed *= 1.2
	elif hp <= 500 and phase == 2:
		phase = 3
		passive_fire_rate = 1.2
		move_speed *= 0.8
	elif hp <= 250 and phase == 3:
		phase = 4
		passive_fire_rate = 2.0
		move_speed *= 1.5

# Choose a random movement mode
#func choose_random_move_mode():
#	var random_choice = randi() % 3
#	match random_choice:
#		0:
#			move_mode = "chase"
#		1:
#			move_mode = "strafe"
#			strafe_direction = "clockwise" if randi() % 2 == 0 else "counterclockwise"
#		2:
#			move_mode = "stay"
			
func update_target(body):
	target = body
	
