extends Control

onready var MenuMusic = $MenuMusic
onready var ContinueSFX = $ContinueSFX

func show():
	toggle_pause()

func toggle_pause():
	visible = not visible
	get_tree().paused = not get_tree().paused

func _on_Button_button_up() -> void:
	Config.current_level = 0
	get_tree().paused = false
	get_tree().reload_current_scene()
	#add reset level logic
