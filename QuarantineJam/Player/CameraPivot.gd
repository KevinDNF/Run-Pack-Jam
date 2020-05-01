extends Position2D

onready var parent = $".."

func _ready() -> void:
	update_pivot_angle()
	
func _physics_process(delta: float) -> void:
	update_pivot_angle()

func update_pivot_angle():
	rotation = parent.direction_vector.angle()
