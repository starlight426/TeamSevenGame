class_name PauseMenu
extends Control

@onready var main = preload("res://main.tscn")
@onready var pause_menu: PauseMenu = $"."
@onready var resume_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/Resume_Button
@onready var quit_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/Quit_Button

func _ready():
	resume_button.button_down.connect(on_resume_pressed)
	quit_button.button_down.connect(on_quit_pressed)
	set_process(false)

func on_resume_pressed() -> void:
	get_parent().get_parent().pauseMenu()

func on_quit_pressed() -> void:
	get_tree().quit()
