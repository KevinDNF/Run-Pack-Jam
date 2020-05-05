extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500

export var Active_Band_Members = 1 setget updateActiveBandMembers
onready var band_members = [
	$"Band_Members/Member_1",
	$"Band_Members/Member_2",
	$"Band_Members/Member_4",
	$"Band_Members/Member_3",
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



onready var instrumentScene = preload("res://Props/Instrument.tscn")

onready var instruments = []

var instrumentsAtHand = [
	true,
	true,
	true,
	true
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
var numberOfHeldInstruments = 1
var velocity = Vector2.ZERO
var direction_vector = Vector2.LEFT #Store direction for non movement animations

onready var animationTree1 = $p1ANPlayer
onready var animationPlayer1 = $p1APlayer
onready var animationState1 = animationTree1.get("parameters/playback")

onready var animationTree2 = $p1ANPlayer2
onready var animationPlayer2 = $p1APlayer2
onready var animationState2 = animationTree2.get("parameters/playback")

onready var animationTree3 = $p1ANPlayer3
onready var animationPlayer3 = $p1APlayer3
onready var animationState3 = animationTree3.get("parameters/playback")

onready var animationTree4 = $p1ANPlayer4
onready var animationPlayer4 = $p1APlayer4
onready var animationState4 = animationTree4.get("parameters/playback")

signal player_is_moving
signal band_is_playing

func _ready() -> void:
	animationTree1.active = true
	animationTree2.active = true
	animationTree3.active = true
	animationTree4.active = true
	updateActiveBandMembers(Active_Band_Members)
	
func _physics_process(delta: float) -> void:
	match(state):
		RUNNING:
			move_state(delta)
			emit_signal("player_is_moving")
		BAND_PLAYING:
			band_playing_state(delta)

func band_playing_state(delta: float):
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
		animationTree1.set("parameters/Idle/blend_position", input_vector)
		animationTree1.set("parameters/Run/blend_position", input_vector)
		animationTree1.set("parameters/GuitarIdle/blend_position", input_vector)
		animationTree1.set("parameters/GuitarRunning/blend_position", input_vector)
		
		animationTree2.set("parameters/Idle/blend_position", input_vector)
		animationTree2.set("parameters/Run/blend_position", input_vector)
		animationTree2.set("parameters/GuitarIdle/blend_position", input_vector)
		animationTree2.set("parameters/GuitarRunning/blend_position", input_vector)
		
		animationTree3.set("parameters/Idle/blend_position", input_vector)
		animationTree3.set("parameters/Run/blend_position", input_vector)
		animationTree3.set("parameters/GuitarIdle/blend_position", input_vector)
		animationTree3.set("parameters/GuitarRunning/blend_position", input_vector)
		
		animationTree4.set("parameters/Idle/blend_position", input_vector)
		animationTree4.set("parameters/Run/blend_position", input_vector)
		animationTree4.set("parameters/GuitarIdle/blend_position", input_vector)
		animationTree4.set("parameters/GuitarRunning/blend_position", input_vector)
		
		if instrumentsAtHand[0]:
			animationState1.travel("GuitarRunning")
		else:
			animationState1.travel("Run")
			
		if instrumentsAtHand[1]:
			animationState2.travel("GuitarRunning")
		else:
			animationState2.travel("Run")
			
		if instrumentsAtHand[2]:
			animationState3.travel("GuitarRunning")
		else:
			animationState3.travel("Run")
			
		if instrumentsAtHand[3]:
			animationState4.travel("GuitarRunning")
		else:
			animationState4.travel("Run")

		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState1.travel("Idle")
		animationState2.travel("Idle")
		animationState3.travel("Idle")
		animationState4.travel("Idle")
		
		
		if instrumentsAtHand[0]:
			animationState1.travel("GuitarIdle")
		else:
			animationState1.travel("Idle")
			
		if instrumentsAtHand[1]:
			animationState2.travel("GuitarIdle")
		else:
			animationState2.travel("Idle")
			
		if instrumentsAtHand[2]:
			animationState3.travel("GuitarIdle")
		else:
			animationState3.travel("Idle")
			
		if instrumentsAtHand[3]:
			animationState4.travel("GuitarIdle")
		else:
			animationState4.travel("Idle")
		
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("band_playing") and holding_all_instruments():		
		animationTree1.set("parameters/Idle/blend_position", Vector2.DOWN)
		animationTree1.set("parameters/Run/blend_position", Vector2.DOWN)
		animationTree1.set("parameters/GuitarIdle/blend_position", Vector2.DOWN)
		animationTree1.set("parameters/GuitarRunning/blend_position", Vector2.DOWN)
		
		animationTree2.set("parameters/Idle/blend_position", Vector2.DOWN)
		animationTree2.set("parameters/Run/blend_position", Vector2.DOWN)
		animationTree2.set("parameters/GuitarIdle/blend_position", Vector2.DOWN)
		animationTree2.set("parameters/GuitarRunning/blend_position", Vector2.DOWN)
		
		animationTree3.set("parameters/Idle/blend_position", Vector2.DOWN)
		animationTree3.set("parameters/Run/blend_position", Vector2.DOWN)
		animationTree3.set("parameters/GuitarIdle/blend_position", Vector2.DOWN)
		animationTree3.set("parameters/GuitarRunning/blend_position", Vector2.DOWN)
		
		animationTree4.set("parameters/Idle/blend_position", Vector2.DOWN)
		animationTree4.set("parameters/Run/blend_position", Vector2.DOWN)
		animationTree4.set("parameters/GuitarIdle/blend_position", Vector2.DOWN)
		animationTree4.set("parameters/GuitarRunning/blend_position", Vector2.DOWN)
		
		Band_Music.play(seek_position)
		Running_Music.stop()
		animationState1.travel("Playing")
		animationState2.travel("Playing")
		animationState3.travel("Playing")
		animationState4.travel("Playing")
		toggleBandPlaying()
	
func move():
	velocity = move_and_slide(velocity)

func toggleBandPlaying():
	state = BAND_PLAYING if state == RUNNING else RUNNING
	
	if state == BAND_PLAYING:
		emit_signal("band_is_playing")
	elif state == RUNNING:
		emit_signal("player_is_moving")
		drop_all_instruments()

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
	
	for i in range(instruments.size(), Active_Band_Members):
		band_members[i].visible = true
		var createdInstrument = instrumentScene.instance()
		createdInstrument.id = i
		instruments.append(createdInstrument)
		
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
	
func drop_all_instruments():
	for i in range(0, Active_Band_Members):
		var current_instrumern = instrumentScene.instance()
		instruments[i] = current_instrumern
		current_instrumern.id = i
		get_node("/root/World/Elements").add_child(instruments[i])
		instruments[i].set_instrument(i)
		instruments[i].throw(global_position)
		instrumentsAtHand[i] = false

func pickup_instrument(id):
	var p = instruments[id].get_parent()
	var el = instruments[id]
	el.queue_free()
	instrumentsAtHand[id] = true
	
func holding_all_instruments():
	for i in range(0, Active_Band_Members):
		if instrumentsAtHand[i] == false:
			return false
	return true

func _on_IntrumentPickupRadius_body_entered(body: Node) -> void:
	pickup_instrument(body.id)
