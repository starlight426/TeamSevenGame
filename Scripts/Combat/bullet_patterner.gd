extends Node2D

var bullet_scn = preload("res://Combat Scenes/Bullet Scenes/bullet.tscn")

var shape_to_spawn #self explanatory
var type_to_spawn #movement pattern of spawned bullets
var speed_to_spawn #speed of bullets
var dmg_to_spawn #damage of bullets
var size_to_spawn #size modifier of bullets
var team_to_spawn #team of bullets
var color_to_spawn #color of bullets
var delay_to_spawn #delay of bullets
var anim_to_spawn #anim for bullets
var mod1
var mod2
var mod3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func spawn_pattern(passed_pos,passed_dir,pattern,passed_pattern_scale,passed_delay,passed_anim,passed_shape,passed_type,passed_speed,passed_size,passed_dmg,passed_team,passed_color,passed_mod1,passed_mod2,passed_mod3):
	
	#these variables are static and have to be edited between spawns of bullets if you want them to change
	shape_to_spawn = passed_shape
	speed_to_spawn = passed_speed
	size_to_spawn = passed_size
	dmg_to_spawn = passed_dmg
	team_to_spawn = passed_team
	type_to_spawn = passed_type
	color_to_spawn = passed_color
	delay_to_spawn = passed_delay
	shape_to_spawn = passed_shape
	mod1 = passed_mod1
	mod2 = passed_mod2
	mod2 = passed_mod3
	
	#these variables are passed to the spawn function every time because they change a lot
	var pos = passed_pos
	var dir = passed_dir
	#burner variables
	var boffset
	var spacing
	var off_angle
	
	#ADD ALL NEW PATTERNS HERE
	match pattern:
		"single":
			sp(pos,dir,1)
			
		"3cone":
			sp(pos,dir,0)
			sp(pos,dir+PI/6,1)
			sp(pos,dir-PI/6,2)
			
		"6cone":
			sp(pos,dir+PI/12,0)
			sp(pos,dir-PI/12,0)
			sp(pos,dir+PI/6,1)
			sp(pos,dir-PI/6,1)
			sp(pos,dir+PI/4,2)
			sp(pos,dir-PI/4,2)
			
		"7cone":
			sp(pos,dir,0)
			sp(pos,dir+PI/6,1)
			sp(pos,dir-PI/6,1)
			sp(pos,dir+PI/3,2)
			sp(pos,dir-PI/3,2)
			sp(pos,dir+PI/2,3)
			sp(pos,dir-PI/2,3)
			
		"5conetight":
			sp(pos,dir,0)
			sp(pos,dir+PI/6,1)
			sp(pos,dir-PI/6,1)
			sp(pos,dir+PI/12,2)
			sp(pos,dir-PI/12,2)
			
		"3spread":
			sp(pos,dir,0)
			spacing = 600
			off_angle = dir - (PI / 2)
			boffset = Vector2(spacing * cos(off_angle), spacing * sin(off_angle))
			sp(pos+boffset,dir,1)
			off_angle = dir + (PI / 2)
			boffset = Vector2(spacing * cos(off_angle), spacing * sin(off_angle))
			sp(pos+boffset,dir,1)
	
		"2spread":
			spacing = 300
			off_angle = dir - (PI / 2)
			boffset = Vector2(spacing * cos(off_angle), spacing * sin(off_angle))
			sp(pos+boffset,dir,0)
			off_angle = dir + (PI / 2)
			boffset = Vector2(spacing * cos(off_angle), spacing * sin(off_angle))
			sp(pos+boffset,dir,0)
		
	#delete self to reduce clutter
	queue_free()

func sp(pos,dir,delay_num):
	if(delay_num*delay_to_spawn > 0):
		await get_tree().create_timer(delay_num*delay_to_spawn).timeout
	if(anim_to_spawn != "default"):
		#anim code
		pass
		
	var new_bullet = bullet_scn.instantiate()
	new_bullet.global_position = pos
	new_bullet.global_rotation = dir
	new_bullet.shape = shape_to_spawn
	new_bullet.type = type_to_spawn
	new_bullet.speed = speed_to_spawn
	new_bullet.scale = Vector2(size_to_spawn,size_to_spawn)
	new_bullet.contact_dmg = dmg_to_spawn
	new_bullet.team = team_to_spawn
	new_bullet.color = color_to_spawn
	new_bullet.mod1 = mod1
	new_bullet.mod2 = mod2
	new_bullet.mod3 = mod3

	add_sibling(new_bullet)
	new_bullet.start_moving()
	
	
