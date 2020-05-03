extends Timer

var world
var toggle = false

func _ready() -> void:
	world = get_node("../../World")
	
func _on_Test_Spawn_Timer_timeout() -> void:
	match toggle:
		false:
			world.start_spawning_fans()
			toggle = true
		true:
			world.stop_spawning_fans()
			toggle = false
