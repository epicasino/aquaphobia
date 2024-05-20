extends SubViewportContainer

@onready var rng = RandomNumberGenerator.new()
@export var largeEnemyScene: PackedScene
@export var mediumMonsterScene: PackedScene
@export var smallEnemyScene: PackedScene

@onready var explosionSounds = [$explosion_1, $explosion_2, $explosion_3]
@onready var lgExplosionSounds = [$big_hit1, $big_hit2, $big_hit3]

var smallEnemyList = []
var mediumEnemyList = []
var largeEnemyList = []

var smallEnemyDelList = []
var medEnemyDelList = []
var lgEnemyDelList = []

var pingStarted = false

# once it goes true, enemies will spawn and cant be turned off until the end of each day
var startEnemySpawn = false

signal spawn_small_monster
signal spawn_med_monster

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	visible = false
	$SubViewport/radar_ping/Ping.visible = false
	$SubViewport/radar_button.play("off")
	
	# sub position
	#sub.position.x = 256
	#sub.position.y = 448

func _process(delta):
	if !Global.pingEnabled:
		pingStarted = false
		$SubViewport/ping.stop()
	else:
		startUpPing()
		pingStarted = true
	deleteEnemies()
	
	if !Global.day_1_grace_period || Global.game_day != 1:
		after_day_1_grace_period()
	
	if Global.torpedoLaunched:
		enemy_on_torpedo_coords_check()
		Global.torpedoLaunched = false

func after_day_1_grace_period():
	if !startEnemySpawn:
		$SubViewport/spawn_timer.start()
		if Global.game_day > 2:
			$SubViewport/lg_monster_timer.start()
		$SubViewport/medium_monster_timer.start()
		$SubViewport/small_monster_timer.start()
	startEnemySpawn = true

func get_random_int_between(min_val, max_val):
	return rng.randi_range(min_val, max_val)

# Return 1 or -1
func get_random_direction():
	return (randi()&2) - 1

func _on_spawn_timer_timeout():
	# Random Spawn Chance, 50% chance
	if get_random_int_between(1, 2) == 1:
		var spawn_area = get_random_int_between(1, 3)
		var monsterType = get_random_int_between(1, 10)
		# Medium Monster
		if monsterType <= Global.medEnemySpawnChance:
			match spawn_area:
			# top left -> right spawn
				1:
					var mediumMonster = mediumMonsterScene.instantiate()
					mediumMonster.position.x = get_random_int_between(0, 8) * 64
					mediumMonster.position.y = 0
					add_child(mediumMonster)
					mediumEnemyList.push_back(mediumMonster)
				# top left -> bottom left
				2:
					var mediumMonster = mediumMonsterScene.instantiate()
					mediumMonster.position.x = 0
					mediumMonster.position.y = get_random_int_between(0, 7) * 64
					add_child(mediumMonster)
					mediumEnemyList.push_back(mediumMonster)
				# top right -> bottom right
				3:
					var mediumMonster = mediumMonsterScene.instantiate()
					mediumMonster.position.x = 512
					mediumMonster.position.y = get_random_int_between(0, 7) * 64
					add_child(mediumMonster)
					mediumEnemyList.push_back(mediumMonster)
		# Small Monster
		else:
			match spawn_area:
				# top left -> right spawn
				1:
					var smallMonster = smallEnemyScene.instantiate()
					smallMonster.position.x = get_random_int_between(0, 8) * 64
					smallMonster.position.y = 0
					add_child(smallMonster)
					smallEnemyList.push_back(smallMonster)
				# top left -> bottom left
				2:
					var smallMonster = smallEnemyScene.instantiate()
					smallMonster.position.x = 0
					smallMonster.position.y = get_random_int_between(0, 7) * 64
					add_child(smallMonster)
					smallEnemyList.push_back(smallMonster)
				# top right -> bottom right
				3:
					var smallMonster = smallEnemyScene.instantiate()
					smallMonster.position.x = 512
					smallMonster.position.y = get_random_int_between(0, 7) * 64
					add_child(smallMonster)
					smallEnemyList.push_back(smallMonster)
# 8 quadrants

func _on_small_monster_timer_timeout():
	for i in smallEnemyList.size():
		var smallMonster = smallEnemyList[i]
		if smallMonster.position.x < 256:
			smallMonster.position.x += 64
		elif smallMonster.position.x > 256:
			smallMonster.position.x -= 64
		else: pass
		
		if smallMonster.position.y < 448:
			smallMonster.position.y += 64
		elif smallMonster.position.y > 448:
			smallMonster.position.y -= 64
		else: pass
		
		if smallMonster.position.x == 256&&smallMonster.position.y == 448:
			print('Small Enemy In Ship')
			spawn_small_monster.emit()
			smallEnemyDelList.push_back(i)
			remove_child(smallMonster)

func _on_medium_monster_timer_timeout():
	for i in mediumEnemyList.size():
		var mediumMonster = mediumEnemyList[i]
		if mediumMonster.position.x < 256:
			mediumMonster.position.x += 64
		elif mediumMonster.position.x > 256:
			mediumMonster.position.x -= 64
		else: pass
		
		if mediumMonster.position.y < 448:
			mediumMonster.position.y += 64
		elif mediumMonster.position.y > 448:
			mediumMonster.position.y -= 64
		else: pass
		
		if mediumMonster.position.x == 256&&mediumMonster.position.y == 448:
			print('Medium Enemy In Ship')
			spawn_med_monster.emit()
			medEnemyDelList.push_back(i)
			remove_child(mediumMonster)

func _on_ping_timeout():
	get_parent().get_node('sonar_ping_noise').play()
	$SubViewport/radar_ping/radar_animation.play("expand")
	for i in smallEnemyList.size():
		var smallEnemy = smallEnemyList[i]
		smallEnemy.get_node('small_blip').play('blip')
	for i in mediumEnemyList.size():
		var mediumEnemy = mediumEnemyList[i]
		mediumEnemy.get_node('med_blip').play('blip')
	for i in largeEnemyList.size():
		var largeEnemy = largeEnemyList[i]
		largeEnemy.get_node('large_blip').play('blip')

func enemy_on_torpedo_coords_check():
	for i in smallEnemyList.size():
		var smallEnemy = smallEnemyList[i]
		if smallEnemy.position == Global.torpedoCoordinates:
			smallEnemyDelList.push_back(i)
			remove_child(smallEnemy)
			#$explosion_delay_timer.start() # for debug, delete or comment this line after
			print('small hit')
	for i in mediumEnemyList.size():
		var mediumEnemy = mediumEnemyList[i]
		if mediumEnemy.position == Global.torpedoCoordinates:
			medEnemyDelList.push_back(i)
			remove_child(mediumEnemy)
			$explosion_delay_timer.start()
			print('medium hit')
	for i in largeEnemyList.size():
		var largeEnemy = largeEnemyList[i]
		# A bunch of checks to see if you shot one grid place off of the large enemy
		if (Global.torpedoCoordinates.y < largeEnemy.position.y &&
		Global.torpedoCoordinates.y + 64 == largeEnemy.position.y):
			largeEnemy.position.y -= 64
		elif (Global.torpedoCoordinates.y > largeEnemy.position.y &&
		Global.torpedoCoordinates.y - 64 == largeEnemy.position.y):
			largeEnemy.position.y -= 64
		elif (Global.torpedoCoordinates.x > largeEnemy.position.x &&
		Global.torpedoCoordinates.y - 64 == largeEnemy.position.x):
			largeEnemy.position.y -= 64
		elif (Global.torpedoCoordinates.x < largeEnemy.position.x &&
		Global.torpedoCoordinates.y + 64 == largeEnemy.position.x):
			largeEnemy.position.y -= 64
		# If you hit directly, you eliminate the large monster
		elif Global.torpedoCoordinates == largeEnemy.position:
			lgEnemyDelList.push_back(i)
			remove_child(largeEnemy)
			$big_explosion_delay_timer.start()
			print('hit')
	if Global.torpedoCoordinates == Vector2(256, 448):
		Global.youLose = 'reactor explode'

	# sub position
	#sub.position.x = 256
	#sub.position.y = 448

func startUpPing():
	if !pingStarted:
		$SubViewport/ping.start()

func _on_lg_monster_timer_timeout():
	var spawn_area = get_random_int_between(1, 3)
	# top left -> right spawn
	var largeEnemy = largeEnemyScene.instantiate()
	largeEnemy.position.x = get_random_int_between(0, 8) * 64
	largeEnemy.position.y = 0
	add_child(largeEnemy)
	largeEnemyList.push_back(largeEnemy)
	$SubViewport/lg_monster_move_timer.start()

func _on_lg_monster_move_timer_timeout():
	for i in largeEnemyList.size():
		var randomNum = get_random_int_between(1,4)
		var largeMonster = largeEnemyList[i]
		if randomNum < 4:
			if largeMonster.position.x < 256:
				largeMonster.position.x += 64
			elif largeMonster.position.x > 256:
				largeMonster.position.x -= 64
			else: pass
			
			if largeMonster.position.y < 448:
				largeMonster.position.y += 64
			elif largeMonster.position.y > 448:
				largeMonster.position.y -= 64
			else: pass
		else:
			var random_direction = get_random_int_between(1, 4)
			# Moves random directions 50%, checks if random movement would exceed grid limits,
			# If it does, it doesn't move, making it more unpredictable.
			if random_direction == 1 && largeMonster.position.y > 0 && largeMonster.position.y < 448:
				largeMonster.position.y += 64
			elif random_direction == 2 && largeMonster.position.y < 448 && largeMonster.position.y > 0:
				largeMonster.position.y -= 64
			elif random_direction == 3 && largeMonster.position.x > 0 && largeMonster.position.x < 576:
				largeMonster.position.y -= 64
			elif random_direction == 4 && largeMonster.position.x < 576 && largeMonster.position.x > 0:
				largeMonster.position.y += 64
			
		if largeMonster.position.x == 256&&largeMonster.position.y == 448:
			lgEnemyDelList.push_back(i)
			remove_child(largeMonster)
			$SubViewport/lg_monster_move_timer.stop()
			Global.youLose = 'big one'
			# TODO: input you lose variable and screen here

func deleteEnemies():
	if smallEnemyDelList.size() != 0:
		for i in smallEnemyDelList.size():
			smallEnemyList.remove_at(smallEnemyDelList[i])
		smallEnemyDelList = []
	if medEnemyDelList.size() != 0:
		for i in medEnemyDelList.size():
			mediumEnemyList.remove_at(medEnemyDelList[i])
		medEnemyDelList = []
	if lgEnemyDelList.size() != 0:
		for i in lgEnemyDelList.size():
			largeEnemyList.remove_at(lgEnemyDelList[i])
		lgEnemyDelList = []

func _on_explosion_delay_timer_timeout():
	var randomIndex = get_random_int_between(0, 2)
	explosionSounds[randomIndex].play()

func _on_big_explosion_delay_timer_timeout():
	var randomIndex = get_random_int_between(0, 2)
	lgExplosionSounds[randomIndex].play()
