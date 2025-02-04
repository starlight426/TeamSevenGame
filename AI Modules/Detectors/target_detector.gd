extends Area2D
@export var team = "none"
var target
var enemies_in_area = []
signal update_parent_target(new_target)

# Called when the node enters the scene tree for the first time.
func _ready():
	team = get_parent().team

func _physics_process(delta):
	if(enemies_in_area.size() > 1):
		update_target(calculate_closest_enemy())
	if(enemies_in_area.size() == 1 && target != enemies_in_area[0]):
		update_target(enemies_in_area[0])
	
func detection_area_entered(body):
	if(body.team != team && body.team != "none"):
		enemies_in_area.append(body)
		if(enemies_in_area.size() == 1):
			update_target(body)
	
func detection_area_exited(body):
	enemies_in_area.erase(body)
	if(body == target):
		update_target(null);

func calculate_closest_enemy():
	var closest_distance_to_me = null
	var final_target
	for current_enemy in enemies_in_area:
		if(closest_distance_to_me == null):
			closest_distance_to_me = global_position.distance_to(current_enemy.global_position)
			final_target = current_enemy 
			continue
		if(global_position.distance_to(current_enemy.global_position) < closest_distance_to_me):
			closest_distance_to_me = global_position.distance_to(current_enemy.global_position)
			final_target = current_enemy
	return final_target

func update_target(new_target):
	update_parent_target.emit(new_target)
	target = new_target
