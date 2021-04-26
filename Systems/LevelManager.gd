extends Node

var current_level: int = 0

var levels = [
	"res://Levels/Level1.tscn",
	"res://Levels/Level2.tscn",
	"res://Levels/Level3.tscn",
	"res://Levels/Level4.tscn",
	"res://Levels/Level5.tscn",
	"res://Levels/Level6.tscn",
	"res://Levels/LevelFinal.tscn",
]

func next_level():
	if current_level < len(levels) - 1:
		current_level += 1
		return levels[current_level]
	else:
		return "res://UI/Options.tscn"
