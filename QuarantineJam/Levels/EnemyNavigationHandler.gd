extends Node

var policeman_prefab = preload("res://Enemies/Policeman.tscn")
var player
var nav : Navigation2D
var world
onready var spawn_position = $SpawnPosition.global_position
onready var line2d = $Line2D

signal new_policeman_created

func _ready() -> void:
	world = get_node("../../World")
	player = get_node("../../World/Player")
	nav = get_node("../../World/Navigation2D")

## Allows us to spawn police at set intervals
func _on_PoliceSpawnTimer_timeout() -> void:
	if world.currentNumberOfEnemies < world.maxNumberOfEnemies:
		var new_policeman = policeman_prefab.instance()
		add_child(new_policeman)
		new_policeman.global_position = spawn_position
		new_policeman.nav = nav
		new_policeman.player = player
		emit_signal("new_policeman_created")
	else:
		pass
