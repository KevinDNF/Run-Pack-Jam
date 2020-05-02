extends Node

var policeman_prefab = preload("res://Enemies/Policeman.tscn")
onready var spawn_position = $SpawnPosition.global_position
var player
var nav : Navigation2D
onready var line2d = $Line2D

#testing, delete after
var policeman

func _process(delta: float) -> void:
	player = get_node("../../World/Player")
	nav = get_node("../../World/Navigation2D")
	
	print(player.global_position)
	
	## temporarily get the policeman from the scene, for testing
	policeman = get_node("../../World/Policeman")
	
	var new_path = nav.get_simple_path(policeman.global_position, player.global_position)
	policeman.path = new_path
	line2d.points = new_path


## Allows us to spawn police at set intervals
func _on_PoliceSpawnTimer_timeout() -> void:
#	var new_policeman = policeman.instance()
#	add_child(new_policeman)
#	new_policeman.global_position = spawn_position
#
#	var new_path = nav.get_simple_path(new_policeman.global_position, player)
#	new_policeman.path = new_path
	pass	
