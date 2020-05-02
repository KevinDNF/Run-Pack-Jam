extends Node

var player
var world
var playerHud 

onready var cheerClips = [
	$"1-50Cheers",
	$"20-40Cheers",
	$"100-200Cheers"
]

func _ready() -> void:
	player = get_node("../../World/Player")
	world = get_node("../../World")
	playerHud = get_node("../../World/UI/PlayerHUD")
	player.connect("band_is_playing", self, "turn_on_crowd_cheering")
	player.connect("player_is_moving", self, "turn_off_crowd_cheering")
	
func turn_on_crowd_cheering():
	var pct = playerHud.get_percentage_of_followers()
	var frame_index = clamp(int(pct * cheerClips.size()), 0, cheerClips.size())
	cheerClips[frame_index].play()

func turn_off_crowd_cheering():
	for i in cheerClips:
		i.stop()
