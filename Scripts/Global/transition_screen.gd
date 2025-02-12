extends CanvasLayer
@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer
signal on_transition_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if(anim_name == "fade_to_black"):
		on_transition_finished.emit()
		await get_tree().create_timer(0.1).timeout
		animation_player.play("fade_to_normal")
	else:
		color_rect.visible = false
	
func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")
