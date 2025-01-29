extends Node2D

var bullet_spawner = preload("res://Combat Scenes/System Scenes/bullet_spawner.tscn")

var shape_to_spawn #self explanatory
var type_to_spawn #movement pattern of spawned bullets
var speed_to_spawn #speed of bullets
var dmg_to_spawn #damage of bullets
var size_to_spawn #size modifier of bullets
var team_to_spawn #team of bullets
var color_to_spawn #color of bullets


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func spawn_pattern(pattern,passed_type,passed_pos,passed_dir,passed_speed,passed_size,passed_dmg,passed_team,passed_color):
	
	#these variables are static and have to be edited between spawns of bullets if you want them to change
	speed_to_spawn = passed_speed
	size_to_spawn = passed_size
	dmg_to_spawn = passed_dmg
	team_to_spawn = passed_team
	color_to_spawn = passed_color
	
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
			sp(pos,dir)
			
		"3cone":
			sp(pos,dir)
			sp(pos,dir+PI/6)
			sp(pos,dir-PI/6)
			
		"6cone":
			sp(pos,dir+PI/12)
			sp(pos,dir-PI/12)
			sp(pos,dir+PI/6)
			sp(pos,dir-PI/6)
			sp(pos,dir+PI/4)
			sp(pos,dir-PI/4)
			
		"7cone":
			sp(pos,dir)
			sp(pos,dir+PI/6)
			sp(pos,dir-PI/6)
			sp(pos,dir+PI/3)
			sp(pos,dir-PI/3)
			sp(pos,dir+PI/2)
			sp(pos,dir-PI/2)
			
		"5conetight":
			sp(pos,dir)
			sp(pos,dir+PI/6)
			sp(pos,dir-PI/6)
			sp(pos,dir+PI/12)
			sp(pos,dir-PI/12)
			
		"3spread":
			sp(pos,dir)
			spacing = 600
			off_angle = dir - (PI / 2)
			boffset = Vector2(spacing * cos(off_angle), spacing * sin(off_angle))
			sp(pos+boffset,dir)
			off_angle = dir + (PI / 2)
			boffset = Vector2(spacing * cos(off_angle), spacing * sin(off_angle))
			sp(pos+boffset,dir)
	
		"2spread":
			spacing = 300
			off_angle = dir - (PI / 2)
			boffset = Vector2(spacing * cos(off_angle), spacing * sin(off_angle))
			sp(pos+boffset,dir)
			off_angle = dir + (PI / 2)
			boffset = Vector2(spacing * cos(off_angle), spacing * sin(off_angle))
			sp(pos+boffset,dir)
		
	#delete self to reduce clutter
	queue_free()

func sp(pos,dir):
	var bspawner = bullet_spawner.instantiate()
	add_sibling(bspawner)
	bspawner.shoot(btype,pos,dir,bspeed,bsize,bdmg,bteam,bcolor)
	
	
