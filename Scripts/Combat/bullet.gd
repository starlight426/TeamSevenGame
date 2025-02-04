extends CharacterBody2D

@export var team = "none"
@export var speed = 1500.0
@export var contact_dmg = 10
@export var color = "default"
@export var type = "straight"
var shape = "circle"
var mod1 = 0
var mod2 = 0
var mod3 = 0



# Called when the node enters the scene tree for the first time.

func _ready():
	$Hitbox.body_entered.connect(on_bullet_hit)
	print(type)
	#start_decay()
	match type:
		"straight":
			print("type is straight")
	#play_this_sound()

func start_moving():
	start_decay()
	var movement = Vector2(speed,0).rotated(rotation)
	if movement != Vector2.ZERO:
		movement = movement.normalized()
	# Move the character
	match type:
		"straight":
			print("type is straight")
			velocity = movement*speed
		"arc":
			velocity = movement*speed
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	move_and_slide()

func on_bullet_hit(target):
	if(target.team != team):
		target.take_damage(contact_dmg)
		queue_free()
	
func start_decay():
	await get_tree().create_timer(40.0).timeout
	queue_free()
