extends Node2D

func _input(event):
	if event.is_action_pressed("accept") or event.is_action_pressed("escape"):
		LevelManager.current_level = -1
		get_tree().change_scene(LevelManager.next_level())
