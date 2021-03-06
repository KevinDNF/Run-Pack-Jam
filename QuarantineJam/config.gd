extends Node

var STARTING_LEVEL = 0
var current_level = STARTING_LEVEL setget update_level_values
var MAX_LEVELS = 4
var SPAWN_TIMER = 3

var LEVELS = [
	"res://Levels/Level1.tscn",
]

var maxNumberOfEnemies = 5
var targetNumberOfFans = 0
var spawnFansInterval = 3
var spawnPoliceInterval = 3

func _ready() -> void:
	update_level_values(STARTING_LEVEL)

func update_level_values(value):
	current_level = clamp(value, 0, MAX_LEVELS)
	maxNumberOfEnemies = 2 * (current_level + 1)
	targetNumberOfFans = 5 * (current_level + 1)
	print("Updating values...\n" + "Level: " + str(current_level + 1) + "\n" + " Max Enemies: " + str(maxNumberOfEnemies) + "\n" + " Target Fans: " + str(targetNumberOfFans) + "\n")
