extends GridContainer

var player_node
var triangle_flag = true
var square_flag = true 
#var debug_ready = false
func _ready() -> void:
	#get_tree().create_timer(0.5).timeout
	player_node = get_tree().root.get_node("Main").get_node("Player")
	#debug_ready = true


func _physics_process(delta: float) -> void:
	if triangle_flag && player_node.attack_shape == "triangle":
		triangle_flag = false
		$"2Shot Tri/TextureRect".material = null
		$"2Shot Tri/Label".text = "Double Shot\nCooldown 0.6s\nEnergy 20\n"
		$"2Shot Tri/Label".add_theme_color_override("font_color", Color("ffffff"))
		
		$"5Shot Tri/TextureRect".material = null
		$"5Shot Tri/Label".text = "5 Shot Spread\nCooldown 0.5s\nEnergy 30\n"
		$"5Shot Tri/Label".add_theme_color_override("font_color", Color("ffffff"))
		
		$"Zigzag/TextureRect".material = null
		$"Zigzag/Label".text = "Zigzag\nCooldown 0.3s\nEnergy 45\n"
		$"Zigzag/Label".add_theme_color_override("font_color", Color("ffffff"))
		
		$"Dash/TextureRect".material = null
		$"Dash/Label".text = "Dash\nCooldown 0.2s\nEnergy 20\n"
		$"Dash/Label".add_theme_color_override("font_color", Color("ffffff"))
		
		$"Rammer/TextureRect".material = null
		$"Rammer/Label".text = "Rammer\nCooldown 8s\nEnergy 80\n"
		$"Rammer/Label".add_theme_color_override("font_color", Color("ffffff"))
	
	if square_flag && player_node.attack_shape == "square":
		square_flag = false
		$"3Shot Sqr/TextureRect".material = null
		$"3Shot Sqr/Label".text = "Triple Shot\nCooldown 0.4s\nEnergy 20\n"
		$"3Shot Sqr/Label".add_theme_color_override("font_color", Color("ffffff"))
		
		$"Barrage/TextureRect".material = null
		$"Barrage/Label".text = "Barrage\nCooldown 0.6s\nEnergy 30\n"
		$"Barrage/Label".add_theme_color_override("font_color", Color("ffffff"))
		
		$"Crusher/TextureRect".material = null
		$"Crusher/Label".text = "Crusher\nCooldown 0.8s\nEnergy 45\n"
		$"Crusher/Label".add_theme_color_override("font_color", Color("ffffff"))
		
		$"Long Dash/TextureRect".material = null
		$"Long Dash/Label".text = "Long Dash\nCooldown 3s\nEnergy 100\n"
		$"Long Dash/Label".add_theme_color_override("font_color", Color("ffffff"))
		
		$"Shield Sqr/TextureRect".material = null
		$"Shield Sqr/Label".text = "Shield\nCooldown 5s\nEnergy 80\n"
		$"Shield Sqr/Label".add_theme_color_override("font_color", Color("ffffff"))
