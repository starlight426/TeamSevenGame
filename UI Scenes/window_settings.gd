extends HBoxContainer

@onready var option_button: OptionButton = $OptionButton

const WINDOW_MODE_ARRAY : Array[String] = [
	"Window Mode",
	"Fullscreen",
	"Borderless Window",
	"Borderless Fullscreen"
]

func _ready():
	option_button.item_selected.connect(on_mode_selected)

func on_mode_selected(index : int) -> void:
	match index:
		0: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
