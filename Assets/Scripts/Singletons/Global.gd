extends Node

var game_start : bool = false
var game_day : int = 1
var pingEnabled : bool = false

var day_1_grace_period: bool = true

# On radar scene, gets torpedo coordinates and verified lock-in coordinates
var torpedoCoordinates = Vector2(256, 448)
var torpedoLockedIn = false

# On weapons scene, verifies if torpedo has been launched
var torpedoLaunched = false

# false is guns, true is torpedo
var chosenWeapon = false

# false is left side, true is right side
var gunPosition = false
var gunLockedIn = false


var radarJammed = false

var youLose = false

var reactorHealth = 0

func _process(delta):
	#print(reactorHealth)
	pass
