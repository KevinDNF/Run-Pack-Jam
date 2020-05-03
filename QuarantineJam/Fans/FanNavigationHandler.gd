extends Area2D

var fan_prefab = preload("res://Fans/Fan.tscn")
var player
var nav : Navigation2D
var world
onready var spawn_position = $SpawnPosition.global_position
onready var spawnTimer = $FanSpawnTimer

signal new_fan_created

func _ready() -> void:
	world = get_node("../../World")
	player = get_node("../../World/Player")
	nav = get_node("../../World/Navigation2D")
	spawnTimer.stop()
	
func _on_FanSpawnTimer_timeout() -> void:
	if world.currentNumberOfFans < world.targetNumberOfFans:
		var new_fan = fan_prefab.instance()
		new_fan.player = player
		new_fan.global_position = spawn_position
		new_fan.nav = nav
		add_child(new_fan)
		emit_signal("new_fan_created")
	else:
		pass

func enable_spawn_timer():
	spawnTimer.start()
	
func disable_spawn_timer():
	spawnTimer.stop()
