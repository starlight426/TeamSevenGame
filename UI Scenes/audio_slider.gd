extends HBoxContainer

@onready var audio_name_lbl: Label = $Audio_Name_Lbl as Label
@onready var audio_num_lbl: Label = $Audio_Num_Lbl as Label
@onready var h_slider: HSlider = $HSlider as HSlider

@export_enum("Master") var bus_name : String

var bus_index : int = 0

func _ready():
	h_slider.value_changed.connect(on_value_changed)
	set_slider_value()

func set_value() -> void:
	audio_num_lbl.text = str(h_slider.value * 100)

func set_slider_value() -> void:
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_value()

func on_value_changed(value : float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	set_value()
