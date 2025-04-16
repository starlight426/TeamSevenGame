extends CharacterBody2D
@export var speed = 600
@export var team = "none"
@export var contact_dmg = 10
@export var color = "default"
@export var type = "straight"
var shape = "circle"
var mod1
var mod2 
var mod3 
var decay_time = 30.0


var spinning = true
var spinning_speed = PI
var expanding = true
var move_dir = 0.0

var rotation_speed = 0
var is_moving_specially = true
var time_to_move_specially = 30.0

var target = null
var locked_on_target = false

func _ready() -> void:
	move_dir = global_rotation
	velocity = Vector2(speed,0).rotated(move_dir)
	
	for current_child in get_children():
		current_child.team = team
	if(expanding):
		for current_child in get_children():
			current_child.start_moving
	await get_tree().create_timer(20.0).timeout
	queue_free()
	

func start_moving():
	start_decay()
	var movement = Vector2(speed,0).rotated(move_dir)
	if movement != Vector2.ZERO:
		movement = movement.normalized()
	match type:
		"straight":
			velocity = movement*speed
		"arc":
			velocity = movement*speed
			rotation_speed = mod1
			time_to_move_specially = mod2
		"striker":
			velocity = movement*speed
			rotation_speed = mod1
			target = mod2
			time_to_move_specially = 7.0
			
	moving_specially_timer()

func _physics_process(delta):
	if(spinning):
		global_rotation += spinning_speed * delta
	match type:
		"arc":
			if(is_moving_specially):
				move_dir += rotation_speed * delta
				velocity = Vector2(speed,0).rotated(move_dir)
		"striker":
		#	print("locked: " + str(locked_on_target))
			#print(rotation_speed)wa
			#print(mod2)
			#print(target)
			if(is_moving_specially):
				if(target):
					if(is_looking_at(target)):
						locked_on_target = true
					if(global_position.distance_to(target.global_position) < 1300):
						locked_on_target = true
					if(!locked_on_target):
						move_dir = lerp_angle(global_rotation,(target.global_position - global_position).angle(),rotation_speed)
						velocity = Vector2(speed,0).rotated(move_dir)
	move_and_slide()


func start_decay():
	await get_tree().create_timer(decay_time).timeout
	queue_free()
	
func moving_specially_timer():
	await get_tree().create_timer(time_to_move_specially).timeout
	is_moving_specially = false
	
func is_looking_at(target: Node2D) -> bool:
	var tolerance = 0.3
	var facing_dir = Vector2.RIGHT.rotated(move_dir)
	var to_target = (target.global_position - global_position).normalized()
	var angle_diff = facing_dir.angle_to(to_target)
	return abs(angle_diff) <= tolerance
	
	
