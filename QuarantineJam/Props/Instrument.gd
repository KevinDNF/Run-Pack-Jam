extends RigidBody2D

onready var sprites = [
	"res://Props/SecondGuitar.png",
	"res://Props/BassGuitar.png",
	"res://Props/Drums.png",
	"res://Props/Guitar.png"
]

onready var sprite = $Sprite
onready var softCollision = $SoftCollision
onready var softCollisionCollider = $SoftCollision/CollisionShape2D
onready var collider = $Collider
var id = 0

export var OFFSET = 500
export var FORCE =  100
export var BOUNCE = 20

func _ready() -> void:
	linear_damp = 1
	var physics_material = PhysicsMaterial.new()
	physics_material.bounce = BOUNCE
	physics_material.rough = true
	physics_material_override = physics_material
	print(id)


func _on_Timer_timeout() -> void:
	softCollisionCollider.disabled = false
	#set_collision_layer_bit(0, true) do this but with animation
	collider.disabled = false

func set_instrument(id):
	sprite.texture = load(sprites[id])

func throw(player_position):
	
	var direction_rotation = randi()%360+0
	print("Rotation: " + str(direction_rotation))
	global_position = player_position + Vector2(50,0).rotated(direction_rotation)
	apply_impulse(Vector2(OFFSET, 0).rotated(direction_rotation),
				  Vector2(FORCE, 0).rotated(direction_rotation))
