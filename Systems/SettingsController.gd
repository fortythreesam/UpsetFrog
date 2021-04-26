extends Node

var soundfx_audio_bus
var music_audio_bus
var master_audio_bus

func _ready():
	soundfx_audio_bus = AudioServer.get_bus_index("SoundFX")
	music_audio_bus = AudioServer.get_bus_index("Music")
	master_audio_bus = AudioServer.get_bus_index("Master")
	var new_volume = AudioServer.get_bus_volume_db(soundfx_audio_bus) - 15
	AudioServer.set_bus_volume_db(soundfx_audio_bus, new_volume)

func is_muted():
	return AudioServer.is_bus_mute(master_audio_bus)

func mute_master():
	var muted = AudioServer.is_bus_mute(master_audio_bus)
	AudioServer.set_bus_mute(master_audio_bus, not muted)#
	return not muted

func get_soundfx_volume():
	return AudioServer.get_bus_volume_db(soundfx_audio_bus)

func increase_soundfx_volume(i: int  = 1):
	var new_volume = AudioServer.get_bus_volume_db(soundfx_audio_bus) + i
	AudioServer.set_bus_volume_db(soundfx_audio_bus, new_volume)
	return new_volume

func decrease_soundfx_volume(i: int  = 1):
	var new_volume = AudioServer.get_bus_volume_db(soundfx_audio_bus) - i
	AudioServer.set_bus_volume_db(soundfx_audio_bus, new_volume)
	return new_volume

func get_music_volume():
	return AudioServer.get_bus_volume_db(music_audio_bus)

func increase_music_volume(i: int  = 1):
	var new_volume = AudioServer.get_bus_volume_db(music_audio_bus) + i
	AudioServer.set_bus_volume_db(music_audio_bus, new_volume)
	return new_volume

func decrease_music_volume(i: int  = 1):
	var new_volume = AudioServer.get_bus_volume_db(music_audio_bus) - i
	AudioServer.set_bus_volume_db(music_audio_bus, new_volume)
	return new_volume

func toggle_fullscreen():
	OS.window_fullscreen = !OS.window_fullscreen
	print(OS.window_fullscreen)
