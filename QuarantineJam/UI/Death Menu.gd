extends Control

onready var MenuMusic = $MenuMusic
onready var ContinueSFX = $ContinueSFX

#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_up"):
#		show_menu()
#		$MenuMusic.play()
#
func show_menu():
	self.visible = true
	get_tree().paused = true

func _on_Continue_Btn_button_up() -> void:
	ContinueSFX.play()
	$MenuMusic.stop()
	#Singnal world
	get_tree().paused = false
	self.visible = false
