extends Camera2D
var following_player = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(following_player):
		global_position = get_parent().get_node("Player").position
	
func set_camera(left_limit,right_limit,top_limit,bottom_limit):
	limit_left = left_limit
	limit_right = right_limit
	limit_top = top_limit
	limit_bottom = bottom_limit
	
func tween_camera():
	pass
