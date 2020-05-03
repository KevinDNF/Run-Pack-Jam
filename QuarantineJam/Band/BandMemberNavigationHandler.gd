extends Node

var band_member_prefab = preload("res://Band/BandMember.tscn")
var player
var nav : Navigation2D
var world

var quarterFansReached = false
var halfFansReached  = false
var threeQuartersFansReached  = false
var allFansReached = false

onready var spawn_position = $SpawnPosition.global_position
onready var humanTreeNode = $"../Elements"
onready var fanNavigationHandler = $"../FanNavigationHandler"
onready var playerHud = $"../../World/UI/PlayerHUD"

func _ready() -> void:
	world = get_node("../../World")
	player = get_node("../../World/Elements/Player")
	nav = get_node("../../World/Navigation2D")
	fanNavigationHandler.connect("new_fan_created", self, "_on_new_fan_created")
	
func _on_new_fan_created():
	print("_on_new_fan_created called")
	var pct = playerHud.get_percentage_of_followers()
			
	if pct >= 0.25 and pct < 0.50:
		if quarterFansReached == false:
			#Spawn band member
			spawn_new_band_member()
			quarterFansReached = true
			#Check for any catchup spawns
			catch_up_band_spawn(.25)
			print("quarter of fans reached")
	if pct >= 0.50 and pct < 0.75:
		if halfFansReached == false:
			#Spawn another band member
			spawn_new_band_member()
			halfFansReached = true
			#Check for any catchup spawns
			catch_up_band_spawn(.50)
			print("half of fans reached")
	if pct >= 0.75 and pct < 1:
		if threeQuartersFansReached == false:
			#Spawn the third band member
			spawn_new_band_member()
			threeQuartersFansReached = true
			#Check for any catchup spawns
			catch_up_band_spawn(.75)
			print("third of fans reached")

	
func catch_up_band_spawn(currentStagePct):
	if currentStagePct == .25:
		pass
	elif currentStagePct == .50:
		# check to make sure any previous spawns haven't been missed
		if quarterFansReached == false:
			spawn_new_band_member()
			quarterFansReached = true
	elif currentStagePct == .75:
		# check to make sure any previous spawns haven't been missed
		if quarterFansReached == false:
			spawn_new_band_member()
			quarterFansReached = true
		if halfFansReached == false:
			spawn_new_band_member()
			halfFansReached = true


func spawn_new_band_member():
	print("Spawned new band member")
	var new_band_member = band_member_prefab.instance()
	new_band_member.player = player
	humanTreeNode.add_child(new_band_member)
	new_band_member.global_position = spawn_position
	new_band_member.nav = nav
