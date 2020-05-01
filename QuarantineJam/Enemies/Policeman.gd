extends KinematicBody2D

enum {
	NORMAL,
	SLOWED
}

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var playerDetectionRadiusSize = 600

var state = NORMAL
var velocity = Vector2.ZERO
var target = null

onready var playerDetectionZone = $PlayerDetectionZone
onready var playerDetectionCollider = $PlayerDetectionZone/CollisionShape2D

func _ready() -> void:
	playerDetectionCollider.shape.radius = playerDetectionRadiusSize

func _physics_process(delta: float) -> void:
	match state:
		NORMAL:
			if playerDetectionZone.can_see_player():
				var player = playerDetectionZone.player
				var direction = position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		SLOWED:
			pass
	velocity = move_and_slide(velocity)
