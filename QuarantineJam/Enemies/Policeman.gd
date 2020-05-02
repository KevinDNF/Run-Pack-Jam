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
onready var slowdownTimer = $SlowdownTimer
onready var animationTree = $AnimationTree
onready var animationPlayer = $AnimationPlayer
onready var speakerPhone = $SpeakerPhone
onready var animationState = animationTree.get("parameters/playback")

onready var RadioTracks = [
	"res://Music and Sounds/Radio/RADIO CHATTER 1.wav",
	"res://Music and Sounds/Radio/RADIO CHATTER 2.wav",
	"res://Music and Sounds/Radio/RADIO CHATTER 3.wav",
	"res://Music and Sounds/Radio/RADIO CHATTER 4.wav",
	"res://Music and Sounds/SFX/CLEAR THIS AREA.wav"
]

var speed = 50
var path : = PoolVector2Array() setget set_path
var nav : Navigation2D = null setget set_nav
var player

var direction
#
func _ready() -> void:
	animationTree.active = true
	speakerPhone.stream = load(RadioTracks[randi()%RadioTracks.size()+0])
	speakerPhone.volume_db = -12
	speakerPhone.play()

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
			line2d.points = new_path
		
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
				
			direction = position.direction_to(path[0])
			var vector = Vector2.ZERO
			vector.x = clamp(direction.x, -1, 1)
			animationTree.set("parameters/Run/blend_position", direction)
			animationState.travel("Run")
			position = starting_point.linear_interpolate(path[0], move_distance / distance_to_next)
			
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
	
func set_slowdown_timer_invterval(value: float):
	slowdownTimer.wait_time = value
	
func _on_SlowdownTimer_timeout() -> void:
	slowdownTimer.stop()
	match state:
		NORMAL:
			state = SLOWED
			slowdownTimer.wait_time = 4
		SLOWED:
			state = NORMAL
			slowdownTimer.wait_time = 8
	slowdownTimer.start()
