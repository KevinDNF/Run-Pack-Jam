extends Node

export var maxNumberOfEnemies = 10
var currentNumberOfEnemies = 0
var policeman_prefab = preload("res://Enemies/Policeman.tscn")
var player
var nav : Navigation2D
onready var spawn_position = $SpawnPosition.global_position
onready var line2d = $Line2D

#testing, delete after
var policeman

func _ready() -> void:
	player = get_node("../../World/Player")
	nav = get_node("../../World/Navigation2D")

## Allows us to spawn police at set intervals
func _on_PoliceSpawnTimer_timeout() -> void:
	if currentNumberOfEnemies < maxNumberOfEnemies:
		var new_policeman = policeman_prefab.instance()
		add_child(new_policeman)
		new_policeman.global_position = spawn_position
		new_policeman.nav = nav
		new_policeman.player = player
		currentNumberOfEnemies += 1
		print(currentNumberOfEnemies)
	else:
		pass
