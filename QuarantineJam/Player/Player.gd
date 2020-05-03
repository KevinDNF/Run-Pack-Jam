extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500

export var Active_Band_Members = 1 setget updateActiveBandMembers
onready var band_members = [
	$"Band_Members/Member_1",
	$"Band_Members/Member_2",
	$"Band_Members/Member_3",
	$"Band_Members/Member_4",
]

onready var metalTracks = [
	"res://Music and Sounds/Metal/Metal (1 Instrument).ogg",
	"res://Music and Sounds/Metal/Metal (2 Instruments).ogg",
	"res://Music and Sounds/Metal/Metal (3 Instruments).ogg",
	"res://Music and Sounds/Metal/Metal (All Instruments).ogg"
]
onready var rockTracks = [
	"res://Music and Sounds/Rock/Rock (1 INSTRUMENT).ogg",
	"res://Music and Sounds/Rock/Rock (2 INSTRUMENTS).ogg",
	"res://Music and Sounds/Rock/Rock (3 INSTRUMENTS).ogg",
	"res://Music and Sounds/Rock/Rock (All Instruments).ogg"
]
onready var punkTracks = [
	"res://Music and Sounds/Punk/Punk (1 INSTRUMENT.ogg",
	"res://Music and Sounds/Punk/Punk (2INSTRUMENTS).ogg",
	"res://Music and Sounds/Punk/Punk (3 INSTRUMENTS).ogg",
	"res://Music and Sounds/Punk/Punk (All Instruments).ogg"
]

onready var indieTracks = [
	"res://Music and Sounds/Indie/Indie (1 Instrument).ogg",
	"res://Music and Sounds/Indie/Indie (2 Instrument).ogg",
	"res://Music and Sounds/Indie/Indie (3 Instruments).ogg",
	"res://Music and Sounds/Indie/Indie (All Instruments).ogg"
]


export var currentGenre = 0 setget updateCurrentGenre
onready var availableTracks = [indieTracks, punkTracks, rockTracks, metalTracks]

onready var Running_Music = $"Running_Music"
onready var Band_Music = $"Band_Music"
var seek_position = 0

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
	updateActiveBandMembers(Active_Band_Members)
	
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
		seek_position = Band_Music.get_playback_position()
		Band_Music.stop()
		Running_Music.play(0)
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
		Band_Music.play(seek_position)
		Running_Music.stop()
		toggleBandPlaying()
	
func move():
	velocity = move_and_slide(velocity)

func toggleBandPlaying():
	state = BAND_PLAYING if state == RUNNING else RUNNING
	
	if state == BAND_PLAYING:
		emit_signal("band_is_playing")
	elif state == RUNNING:
		emit_signal("player_is_moving")

func updateActiveBandMembers(value):
	if (band_members == null):
		Active_Band_Members = value
		return;
	
	Active_Band_Members = clamp(value, 1, band_members.size())
	
	seek_position = Band_Music.get_playback_position()
	var wasBandPlaying = Band_Music.playing
	Band_Music.stream = getCurrentTrack(currentGenre, Active_Band_Members - 1)
	if (wasBandPlaying):
		Band_Music.play(seek_position)
	
	for i in range(0, Active_Band_Members):
		band_members[i].visible = true
		
	for i in range(Active_Band_Members, band_members.size()):
		band_members[i].visible = false
func updateCurrentGenre(value):
	currentGenre = value
	updateActiveBandMembers(Active_Band_Members)

func getCurrentTrack(genreNo, trackNo):
	var x = clamp(genreNo, 0, availableTracks.size() - 1)
	var g = availableTracks[x]
	var y = clamp(trackNo, 0, g.size())
	print("loading " + g[y])
	return load(g[y])
