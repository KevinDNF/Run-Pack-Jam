extends Control

onready var Police_Meter = $"Police Meter"
onready var Followers_Meter = $"Followers Meter"

var Max_Followers = 2 setget set_max_followers
var Max_Enemies = 2 setget set_max_enemies

var Enemies = 1 setget set_enemies
var Followers = 1 setget set_followers

func set_max_followers(value):
	set_followers_ui(Followers, value)
	Max_Followers = value

func set_followers(value):
	set_followers_ui(value, Max_Followers)
	Followers = value

func set_max_enemies(value):
	set_enemies_ui(Enemies, value)
	Max_Enemies = value

func set_enemies(value):
	set_enemies_ui(value, Max_Enemies)
	Enemies = value
	
func set_followers_ui(current, max_value):
	var pct = float(current) / float(max_value)
	var frame_index = clamp(int(pct * 5) + 6, 6, 11)
	Followers_Meter.frame = frame_index

func set_enemies_ui(current, max_value):
	var pct = float(current) / float(max_value)
	var frame_index = clamp(int(pct * 5), 1, 5)
	Police_Meter.frame = frame_index


