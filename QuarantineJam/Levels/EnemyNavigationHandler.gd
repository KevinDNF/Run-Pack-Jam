extends Node

var policeman = preload("res://Enemies/Policeman.tscn")
onready var spawn_position = $SpawnPosition.global_position
var player
var nav : Navigation2D

func _ready() -> void:
	player = get_node("../../World/Player").global_position
	print(player)
	nav = get_node("../../World/Navigation2D")


func _on_PoliceSpawnTimer_timeout() -> void:
	var new_policeman = policeman.instance()
	add_child(new_policeman)
	new_policeman.global_position = spawn_position
	
	var new_path = nav.get_simple_path(new_policeman.global_position, player)
	new_policeman.path = new_path
	
