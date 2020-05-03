extends Timer

var world
var toggle = false

func _ready() -> void:
	world = get_node("../../World")
	wait_time = Config.SPAWN_TIMER
	
func _on_Test_Spawn_Timer_timeout() -> void:
	match toggle:
		false:
			world.start_spawning_fans()
			world.start_spawning_police()
			toggle = true
		true:
			world.stop_spawning_fans()
			world.stop_spawning_police()
			toggle = false
