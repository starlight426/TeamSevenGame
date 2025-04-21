extends AudioStreamPlayer
const level_music = preload("res://Assets/Audio Files/SI_Exploration_theme1_finalised.mp3")
const boss_music = preload("res://Assets/Audio Files/SI_Boss_Fight_theme1_finalised.mp3")


func _init_music(music: AudioStream, volume = 1.0):
	if stream == music:
		return
	else:
		stream = music
		volume_db = volume
		play()
		
func _play_music():
	_init_music(level_music)
	
func _play_boss_music():
	_init_music(boss_music)
