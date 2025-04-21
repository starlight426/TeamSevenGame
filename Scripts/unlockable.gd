extends Area2D
@export var unlock_type = "triangle"

func _on_body_entered(body: Node2D) -> void:
	body.unlock(unlock_type)
			
