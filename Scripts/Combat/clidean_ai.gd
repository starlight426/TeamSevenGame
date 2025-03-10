extends CharacterBody2D

@export var hp = 1000
@export var team = "circle"
@export var speed = 600  # Strafe speed
@export var passive_fire_rate = 1.5  # Time between passive bullet bursts
@export var strafe_interval = 3.0  # Time before switching strafe direction
@export var attack_cooldown = 1  # Time between attacks

var target = null
var fire_ready = false
var strafe_direction = 1  # 1 for clockwise, -1 for counterclockwise
var can_attack = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TargetDetector.update_parent_target.connect(update_target)
	await get_tree().create_timer(0.5).timeout
	fire_ready = true
	passive_fire()
	start_strafe_cycle()

# Passive bullet shooting
func passive_fire():
	while true:
		if fire_ready:
			var angle_offset = randf_range(-PI / 2, PI / 2)
			AttackSpawner.spawn_bullets(global_position, global_rotation + angle_offset, "circle", 1, 0, "default", "circle", "straight", 2000, 3, 30, "circle", "purple", 0, 0, 0)
		await get_tree().create_timer(passive_fire_rate).timeout

# Strafe behavior
func start_strafe_cycle():
	while true:
		strafe_direction *= -1  # Switch direction
		await get_tree().create_timer(strafe_interval).timeout

func _physics_process(delta: float) -> void:
	if target:
		# Strafe movement
		var direction_to_player = (target.global_position - global_position).normalized()
		var perpendicular_direction = direction_to_player.rotated(PI / 2 * strafe_direction)
		velocity = perpendicular_direction * speed
		move_and_slide()

		# Attack logic
		if can_attack:
			attack()

# Phase 1 (only thing implemented now for demo showcase)
func attack():
	can_attack = false
	var attack_type = randi() % 2
	if attack_type == 0:
		fire_bullet_circle()
	else:
		fire_striker_bullets()
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

# Fires a small bullet circle directly at the player
func fire_bullet_circle():
	AttackSpawner.spawn_bullets(global_position, (target.global_position - global_position).angle(), "single", 1, 0, "default", "circle", "straight", 2000, 3, 30, "circle", "red", 0, 0, 0)

# Fires slow striker bullets near the player
func fire_striker_bullets():
	for i in range(3):
		var offset_angle = randf_range(-PI / 6, PI / 6)  # Small random spread
		AttackSpawner.spawn_bullets(global_position, (target.global_position - global_position).angle() + offset_angle, "single", 1, 0, "default", "circle", "straight", 1200, 5, 40, "circle", "blue", 0, 0, 0)

func update_target(body):
	target = body

func take_damage(dmg):
	hp -= dmg
