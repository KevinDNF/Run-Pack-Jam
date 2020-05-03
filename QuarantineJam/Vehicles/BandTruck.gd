extends Node2D

onready var enterTruckCollision = $"EnterTruck/CollisionShape2D"
onready var truckCollision = $"StaticBody2D/CollisionShape2D"

signal player_entered_truck

func _on_EnterTruck_body_entered(body: Node) -> void:
	emit_signal("player_entered_truck")

func show():
	visible = true
	enterTruckCollision.disabled = false
	truckCollision.disabled = false
