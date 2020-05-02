extends KinematicBody2D

enum {
	NORMAL,
	SLOWED
}

export var playerDetectionRadiusSize = 600
export var normal_speed = 50
export var slowed_speed = 10

var state = NORMAL
var velocity = Vector2.ZERO
var target = null

onready var playerDetectionZone = $PlayerDetectionZone
onready var line2d = $Line2D
onready var softCollision = $SoftCollision

var speed = 50
var path : = PoolVector2Array() setget set_path
var nav : Navigation2D = null setget set_nav
var player


func _process(delta: float) -> void:
	
	match state:
		NORMAL:
			speed = normal_speed
			
		SLOWED:
			speed = slowed_speed
	
	if playerDetectionZone.is_player_within_range():
		pass
	else:
		if player != null:
			var new_path = nav.get_simple_path(global_position, player.global_position)
			path = new_path
			
		
		var move_distance = speed * delta
		move_along_path(move_distance)
	
		if softCollision.is_colliding():
			velocity += softCollision.get_push_vector() * delta * 800
		else:
			velocity = Vector2.ZERO
			
		if velocity != Vector2.ZERO:
			velocity = move_and_slide(velocity)

func move_along_path(move_distance) -> void:
	var starting_point = position
	for i in range(path.size()):
		var distance_to_next = starting_point.distance_to(path[0])
		if move_distance <= distance_to_next and move_distance >= 0.0:
			if distance_to_next == 0:
				break
				
			position = starting_point.linear_interpolate(path[0], move_distance / distance_to_next)
			
			print(velocity)
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

func set_nav(value):
	nav = value
	
