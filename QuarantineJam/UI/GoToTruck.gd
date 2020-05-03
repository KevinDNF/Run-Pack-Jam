extends Control

onready var durationAnimation = $"Duration"

func show():
	print("Go To Truck")
	visible = true
	durationAnimation.play("Duration")
