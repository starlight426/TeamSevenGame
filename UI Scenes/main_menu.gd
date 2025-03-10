class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button
@onready var options_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button
@onready var credits_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Credits_Button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button
@onready var options_menu: OptionsMenu = $OptionsMenu
@onready var margin_container: MarginContainer = $MarginContainer

# Currently directly to start of demo, later will go to a file select screen
@onready var start_level = preload("res://main.tscn")


func _ready():
	start_button.button_up.connect(on_start_pressed)
	options_button.button_down.connect(on_options_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)


func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	

func on_exit_pressed() -> void:
	get_tree().quit()

func on_exit_options_menu() -> void:
	options_menu.visible = false
	margin_container.visible = true
