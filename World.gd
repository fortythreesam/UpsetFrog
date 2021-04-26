extends Node2D

func _ready():
	$Environment/NextLevel.connect("body_entered", self, "_on_NextLevel_body_entered")
	PlayerInfoManager.set_info($Entities/Crab)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.set_target($Entities/Crab)


func _on_NextLevel_body_entered(body):
	if body.has_method("is_player"):
		var next_level = LevelManager.next_level()
		PlayerInfoManager.save_info($Entities/Crab)
		get_tree().change_scene(next_level)
