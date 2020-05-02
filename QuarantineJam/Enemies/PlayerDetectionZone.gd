extends Area2D

var player_within_range = false

func is_player_within_range():
	return player_within_range
	
func _on_PlayerDetectionZone_body_entered(body: Node) -> void:
	player_within_range = true

func _on_PlayerDetectionZone_body_exited(body: Node) -> void:
	player_within_range = false
