extends Control

onready var MenuMusic = $MenuMusic
onready var ContinueSFX = $ContinueSFX
onready var ExitSFX = $ExitSFX

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
		$MenuMusic.play()
		

func toggle_pause():
	visible = not visible
	get_tree().paused = not get_tree().paused

func _on_Continue_Btn_button_up() -> void:
	ContinueSFX.play()
	$MenuMusic.stop()
	toggle_pause()

func _on_Quit_Btn_button_up() -> void:
	ExitSFX.play()
	$MenuMusic.stop()
	toggle_pause()
	print("quit not implemented")
	get_tree().quit()
