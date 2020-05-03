extends KinematicBody2D

onready var softCollision = $SoftCollision
var velocity = Vector2.ZERO
var id = 0

func _ready() -> void:
	print(id)

func _physics_process(delta: float) -> void:
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	else:
		velocity = Vector2.ZERO
	velocity = move_and_slide(velocity)
	
