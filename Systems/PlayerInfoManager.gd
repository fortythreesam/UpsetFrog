extends Node

var timer: float = 0
var kills: int = 0

var alive: bool = true

var player_dead_timer: float = 0
var player_deaths: int = 0

var player_info = {
	potions = 3
}

func _process(delta):
	timer += delta
	if not alive:
		player_dead_timer += delta
		if player_dead_timer > 2:
			player_dead_timer = 0
			alive = true
			player_info.potions += 1
			get_tree().reload_current_scene()

func add_kill():
	kills += 1

func save_info(player):
	player_info = {
		potions = player.potions
	}

func set_info(player):
	player.potions = player_info.potions
	
"""
The FOrgottenCave
The unyielding Crab
Upset Crab
The distempered crab
The raging crab
The Distraught crab
The greedy crab
"""
