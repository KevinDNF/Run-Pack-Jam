extends Control

onready var durationAnimation = $"Duration"

onready var lvlT = [$"lvl1",$"lvl2",
$"lvl3", $"lvl4"]

onready var lvls = [$"AnimationPlayer",$"AnimationPlayer2",
$"AnimationPlayer3", $"AnimationPlayer4"]

func showLevel(level):
	durationAnimation.seek(0)
	print("Level start" + str(level))
	visible = true
	lvlT[level].visible = true
	lvls[level].play()
	

	durationAnimation.play("Duration")
