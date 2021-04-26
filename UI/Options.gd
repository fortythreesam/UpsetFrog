extends Control

signal closed

var cursor_position: int = 0



func _ready():
	$Buttons/Mute.text = "Mute: " + bool_to_yn(SettingsController.is_muted())
	$Buttons/FullScreen.text = "Fullscreen: " + bool_to_yn(OS.window_fullscreen)
	$Buttons/FXVolume.text = "FX Volume: " + str(SettingsController.get_soundfx_volume() + 50)

func _input(event):
	if event.is_action_pressed("down"):
		$Sounds/Blip.play()
		cursor_position += 1
	if event.is_action_pressed("up"):
		$Sounds/Blip.play()
		cursor_position -= 1
	cursor_position = posmod(cursor_position, $Buttons.get_child_count())
	$Select.margin_top = $Buttons.get_child(cursor_position).margin_top - 54
	
	if event.is_action_pressed("escape"):
		$Sounds/Select.play()
		emit_signal("closed")
		get_tree().set_input_as_handled()
		queue_free()
		get_tree().paused = false

	if (event.is_action_pressed("attack") or 
	   event.is_action_pressed("jump") or 
	   event.is_action_pressed("accept")):
		match $Buttons.get_child(cursor_position).name:
			"Return":
				$Sounds/Select.play()
				emit_signal("closed")
				get_tree().set_input_as_handled()
				queue_free()
				get_tree().paused = false
			"Quit":
				get_tree().quit()
	
	if (event.is_action_pressed("attack") or 
		event.is_action_pressed("jump") or 
		event.is_action_pressed("accept") or
		event.is_action_pressed("left") or
		event.is_action_pressed("right")):
		match $Buttons.get_child(cursor_position).name:
			"Mute":
				$Sounds/Select.play()
				SettingsController.mute_master()
				$Buttons/Mute.text = "Mute: " + bool_to_yn(SettingsController.is_muted())
			"FullScreen":
				$Sounds/Select.play()
				SettingsController.toggle_fullscreen()
				$Buttons/FullScreen.text = "Fullscreen: " + bool_to_yn(OS.window_fullscreen)
				
	if event.is_action_pressed("left"):
		match $Buttons.get_child(cursor_position).name:
			"FXVolume":
				$Sounds/Select.play()
				var new_volume: int = SettingsController.decrease_soundfx_volume()
				$Buttons/FXVolume.text = "FX Volume: " + str(new_volume + 50)
	if event.is_action_pressed("right"):
		match $Buttons.get_child(cursor_position).name:
			"FXVolume":
				$Sounds/Select.play()
				var new_volume: int = SettingsController.increase_soundfx_volume()
				$Buttons/FXVolume.text = "FX Volume: " + str(new_volume + 50)
		

func bool_to_yn(b):
	if b:
		return 'Y'
	else:
		return 'N'
