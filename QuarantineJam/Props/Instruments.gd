extends KinematicBody2D

onready var softCollision = $SoftCollision
onready var softCollisionCollider = $SoftCollision/CollisionShape2D
onready var collider = $Collider
onready var timer = $Timer
var velocity = Vector2.ZERO
var target_position
var id = 0

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

func _ready() -> void:
	print(id)

func _physics_process(delta: float) -> void:
	
	var direction = position.direction_to(target_position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
	velocity = move_and_slide(velocity)
#	if softCollision.is_colliding():
#		velocity += softCollision.get_push_vector() * delta * 400
#	else:
#		velocity = Vector2.ZERO
#	velocity = move_and_slide(velocity)
	

func _on_Timer_timeout() -> void:
	softCollisionCollider.disabled = false
	collider.disabled = false
	timer.stop()
