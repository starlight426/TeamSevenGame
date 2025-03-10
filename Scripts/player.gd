extends CharacterBody2D

@export var speed = 3000
@export var hp = 100
@export var energy = 0
@export var team = "cigil"
var energy_ready = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(energy_ready):
		add_energy()
		
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
	move_and_slide()

func add_energy():
	energy_ready = false
	if(energy < 100):
		energy += 10
	if(energy < 300):
		energy += 10
	if(energy < 500):
		energy += 10
	await get_tree().create_timer(0.5).timeout
	energy_ready = true

func take_damage(dmg):
	hp -= dmg
