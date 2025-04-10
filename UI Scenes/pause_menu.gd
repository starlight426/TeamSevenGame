class_name PauseMenu
extends Control

@onready var resume_button = $MarginContainer/VBoxContainer/HBoxContainer/Resume_Button
@onready var quit_button = $MarginContainer/VBoxContainer/HBoxContainer/Quit_Button
@onready var save_button = $MarginContainer/VBoxContainer/HBoxContainer/Save_Button
@onready var load_button = $MarginContainer/VBoxContainer/HBoxContainer/Load_Button

func _ready():
	# Connect all buttons to main.gd
	resume_button.button_down.connect(get_parent().get_parent()._on_Resume_Button_pressed)
	quit_button.button_down.connect(get_parent().get_parent()._on_Quit_Button_pressed)
	save_button.button_down.connect(get_parent().get_parent()._on_Save_Button_pressed)
	load_button.button_down.connect(get_parent().get_parent()._on_Load_Button_pressed)
	set_process(false)  
