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

var speed = 50
var path : = PoolVector2Array() setget set_path
#var nav_2d = null setget set_nav


func _process(delta: float) -> void:
	var move_distance = speed * delta
	move_along_path(move_distance)

func move_along_path(move_distance) -> void:
	var starting_point = position
	for i in range(path.size()):
		var distance_to_next = starting_point.distance_to(path[0])
		if move_distance <= distance_to_next and move_distance >= 0.0:
			position = starting_point.linear_interpolate(path[0], move_distance / distance_to_next)
			#var direction = position.direction_to(path[0])
			#velocity = velocity.move_toward(direction * speed, ACCELERATION * delta)
			break	
		elif move_distance < 0.0:
			position = path[0]
			set_process(false)
		move_distance -= distance_to_next
		starting_point = path[0]
		path.remove(0)

func set_path(new_path) -> void:
	path = new_path
	if new_path.size() == 0:
		return
	set_process(true)


####
#### Old code, keeping it here until I get navigation working
####
#func _ready() -> void:
#	playerDetectionCollider.shape.radius = playerDetectionRadiusSize
#
#func _physics_process(delta: float) -> void:
#	match state:
#		NORMAL:
#			if playerDetectionZone.can_see_player():
#				var player = playerDetectionZone.player
#				var direction = position.direction_to(player.global_position)
#				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
#		SLOWED:
#			pass
#	velocity = move_and_slide(velocity)

#func _physics_process(delta: float) -> void:
#	if path.size() > 1 :
#		var d = position.distance_to(path[0])
#		if d > 2:
#			position = position.linear_interpolate(path[0], speed * delta / d)
#		else:
#			path.remove(0)
#	else:
#		print("We've reached player")

