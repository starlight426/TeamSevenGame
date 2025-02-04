extends CharacterBody2D

@export var speed = 1500
@export var hp = 100
@export var team = "cigil"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	# Get the global mouse position
	var mouse_position = get_global_mouse_position()
	# Calculate the angle between the player and the mouse
	var angle_to_mouse = (mouse_position - global_position).angle()
	# Set the player's rotation to face towards the mouse
	global_rotation = angle_to_mouse
	
	# Check for movement keys and set movement vector accordingly
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
	# Move the character
	velocity = movement * speed
	move_and_slide()





func take_damage(dmg):
	hp -= dmg
