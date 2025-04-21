extends CharacterBody2D

@export var team = "none"
@export var speed = 1000.0
@export var contact_dmg = 10
@export var color = "default"
@export var type = "straight"
var shape = "circle"
var mod1
var mod2 
var mod3 
var decay_time = 30.0

var rotation_speed = 0
var is_moving_specially = true
var time_to_move_specially = 30.0

var target = null
var locked_on_target = false

var current_sprite

# Called when the node enters the scene tree for the first time.

func _ready():
	#$Hitbox.body_entered.connect(on_bullet_hit)
	
	match shape:
		"circle":
			$CircleHitbox.body_entered.connect(on_bullet_hit)
			$CircleSprite.show()
			current_sprite = $CircleSprite
		"triangle":
			$TriangleHitbox.body_entered.connect(on_bullet_hit)
			$TriangleSprite.show()
			current_sprite = $TriangleSprite
		"zigzag":
			$ZigZagHitbox.body_entered.connect(on_bullet_hit)
			$ZigZagSprite.show()
			current_sprite = $ZigZagSprite
		"square":
			$SquareHitbox.body_entered.connect(on_bullet_hit)
			$SquareSprite.show()
			current_sprite = $SquareSprite
			
	match type:
		"straight":
			pass
		"striker":
			current_sprite.modulate = Color(0.7,0.7,1.0,1.0)
		
	match color:
		"cigil":
			current_sprite.modulate = Color.BLACK
	#play_this_sound()

func start_moving():
	start_decay()
	var movement = Vector2(speed,0).rotated(rotation)
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
			velocity = Vector2(speed,0).rotated(global_rotation)
			rotation_speed = mod1
			target = mod2
			time_to_move_specially = 7.0
			
	moving_specially_timer()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	match type:
		"arc":
			if(is_moving_specially):
				global_rotation += rotation_speed * delta
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
						global_rotation = lerp_angle(global_rotation,(target.global_position - global_position).angle(),rotation_speed)
						velocity = Vector2(speed,0).rotated(global_rotation)
	move_and_slide()

func on_bullet_hit(target):
	if(target.team != team):
		#print("took" + str(contact_dmg) + " damage")
		target.take_damage(contact_dmg)
		queue_free()

func start_decay():
	await get_tree().create_timer(decay_time).timeout
	queue_free()
	
func moving_specially_timer():
	await get_tree().create_timer(time_to_move_specially).timeout
	is_moving_specially = false
	
func is_looking_at(target: Node2D) -> bool:
	var tolerance = 0.1
	var facing_dir = Vector2.RIGHT.rotated(rotation)
	var to_target = (target.global_position - global_position).normalized()
	var angle_diff = facing_dir.angle_to(to_target)
	return abs(angle_diff) <= tolerance
	
	
