extends Control


func _on_Button_button_up() -> void:
	var startingLevel = Config.LEVELS[Config.STARTING_LEVEL]
	get_tree().change_scene(startingLevel)
