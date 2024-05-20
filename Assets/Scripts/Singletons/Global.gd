extends Node

var game_start : bool = false
var game_day : int = 1
var pingEnabled : bool = false

var first_playthrough = true

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

var youLose

# modifies spawn timer
var enemySpawnRate: float
var largeEnemySpawnRate: float
# out of 10, remaining numbers out of 10 would be spawn rate of small_enemies
var medEnemySpawnChance: int

var reactorHealth = 0

func _ready():
	day_spawn_rates()

func day_spawn_rates():
	match game_day:
		1:
			enemySpawnRate = 13.5
			medEnemySpawnChance = 4
		2:
			enemySpawnRate = 12.5
			medEnemySpawnChance = 5
		3:
			largeEnemySpawnRate = 240
			enemySpawnRate = 11.5
			medEnemySpawnChance = 5
		4:
			largeEnemySpawnRate = 120
			enemySpawnRate = 10.5
			medEnemySpawnChance = 5
		5:
			largeEnemySpawnRate = 60
			enemySpawnRate = 11.5
			medEnemySpawnChance = 5
