extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500

enum {
	RUNNING,
	BAND_PLAYING
}

var state = RUNNING

var velocity = Vector2.ZERO
var direction_vector = Vector2.LEFT #Store direction for non movement animations

onready var animationTree = $AnimationTree
onready var animationPlayer = $AnimationPlayer
onready var animationState = animationTree.get("parameters/playback")

signal player_is_moving
signal band_is_playing

func _ready() -> void:
	animationTree.active = true
	
	
func _physics_process(delta: float) -> void:
	match(state):
		RUNNING:
			move_state(delta)
			emit_signal("player_is_moving")
		BAND_PLAYING:
			band_playing_state(delta)

func band_playing_state(delta: float):
	animationState.travel("Idle")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if Input.is_action_just_pressed("band_playing"):
		toggleBandPlaying()

func move_state(delta: float):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		direction_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("band_playing"):
		animationTree.set("parameters/Idle/blend_position", Vector2.DOWN)
		animationTree.set("parameters/Run/blend_position",  Vector2.DOWN)
		toggleBandPlaying()
	
func move():
	velocity = move_and_slide(velocity)

func toggleBandPlaying():
	state = BAND_PLAYING if state == RUNNING else RUNNING
	
	if state == BAND_PLAYING:
		emit_signal("band_is_playing")
	elif state == RUNNING:
		emit_signal("player_is_moving")
