extends AudioStreamPlayer
var level_music = preload("res://Assets/Audio Files/SI_Exploration_theme1_finalised.mp3")
var boss_music = preload("res://Assets/Audio Files/SI_Boss_Fight_theme1_finalised.mp3")

func _get_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	else:
		set_stream(music)
		set_volume_db(volume)
		stream.loop = true
		
func _play_music():
	_get_music(level_music)
	
func _play_boss_music():
	_get_music(boss_music)
