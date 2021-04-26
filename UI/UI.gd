extends Control

var player: Entity

func _ready():
	player = get_parent().get_parent()

func _process(delta):
	$Health/TextureProgress.value = (player.health / player.max_health) * 100
	$Stamina/TextureProgress.value = (player.stamina / player.max_stamina) * 100
	$Timer.text = "%003.0f" % PlayerInfoManager.timer
	$Kills/Label.text = "%02d" % PlayerInfoManager.kills
	$Potions/Label.text = "%02d" % player.potions
	$Floor.text = "F%02d" % (len(LevelManager.levels) - (LevelManager.current_level + 1))
