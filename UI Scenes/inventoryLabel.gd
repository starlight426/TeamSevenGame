extends Control

func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))


func _on_mouse_entered():
	$Label.visible = true

func _on_mouse_exited():
	$Label.visible = false
