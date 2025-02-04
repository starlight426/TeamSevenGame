extends Node
var bullet_patterner_scn = preload("res://Combat Scenes/System Scenes/bullet_patterner.tscn")
var solid_patterner_scn = preload("res://Combat Scenes/System Scenes/bullet_patterner.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#This script contains global functions for spawning bullet and solid patterns. 

#examples of calls (feel free to make more to copy paste):
#spawn_bullets(global_position,global_rotation-PI/2,"3cone",1,0.1,"default",circle","arc","default",1.5,30,"player","purple",PI/6,0,0)
#spawn_bullets(global_position,global_rotation-PI/2,"single",1,0,"default","circle","straight","default",1,30,"player","purple",0,0,0)
#pattern: bullet pattern passed to the next node
#pattern_scale: the size modifier of the pattern, input 1 for default
#pattern_delay: the delay between each spawned bullet, input 0 for none
#anim: animation that plays before each bullet spawn, input "default" for none
#shape: shape of the bullet
#type: movement pattern of bullet input "default" for default
#speed: linear speed of bullet, input "default" for default
#size: size modifier of bullet, input 1 for default
#dmg: damage of bullet, input "default" for default
#team: team of bullet
#color: color of bullet (might remove idk)
#mod1,mod2,mod3: extra arguments that may be used for the bullet movement. in an arc bullet, mod1 might contain the angle
#hp (solid only) hp modifier. input "default" for default.
#in solid spawner, the only difference is hp tacked on at the end, and mod1-3 being enemy subtypes.

func spawn_bullets(pos,dir,pattern,pattern_scale,pattern_delay,anim,shape,type,speed,size,dmg,team,color,mod1,mod2,mod3):
	var patterner = bullet_patterner_scn.instantiate()
	add_sibling(patterner)
	return patterner.spawn_pattern(pos,dir,pattern,pattern_scale,pattern_delay,anim,shape,type,speed,size,dmg,team,color,mod1,mod2,mod3)


func spawn_solids(pos,dir,pattern,pattern_scale,shape,type,speed,size,dmg,team,color,mod1,mod2,mod3,hp):
	var patterner = solid_patterner_scn.instantiate()
	add_sibling(patterner)
	return patterner.spawn_pattern(pos,dir,pattern,pattern_scale,shape,type,speed,size,dmg,team,color,mod1,mod2,mod3,hp)
