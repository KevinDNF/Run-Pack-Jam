extends Node

var policeman_prefab = preload("res://Enemies/Policeman.tscn")
var player
var nav : Navigation2D
var world
onready var spawn_position = $SpawnPosition.global_position
onready var line2d = $Line2D
onready var spawnTimer = $PoliceSpawnTimer
onready var humanTreeNode = $"../Elements"

signal new_policeman_created

func _ready() -> void:
	world = get_node("../../World")
	player = get_node("../../World/Elements/Player")
	nav = get_node("../../World/Navigation2D")
	spawnTimer.stop()
	spawnTimer.wait_time = Config.spawnPoliceInterval

## Allows us to spawn police at set intervals
func _on_PoliceSpawnTimer_timeout() -> void:
	if world.currentNumberOfEnemies < Config.maxNumberOfEnemies:
		var new_policeman = policeman_prefab.instance()
		humanTreeNode.add_child(new_policeman)
		new_policeman.global_position = spawn_position
		new_policeman.nav = nav
		new_policeman.player = player
		emit_signal("new_policeman_created")
	else:
		pass

func enable_spawn_timer():
	spawnTimer.start()
	
func disable_spawn_timer():
	spawnTimer.stop()
