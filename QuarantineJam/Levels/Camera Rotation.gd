extends Position2D

onready var player = $".."

func _ready() -> void:
	update_rotation()
		
func _physics_process(delta: float) -> void:
	update_rotation()


func update_rotation():
	rotation = player.direction_vector.angle()
	
