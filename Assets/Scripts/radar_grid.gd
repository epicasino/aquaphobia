extends SubViewportContainer

@onready var rng = RandomNumberGenerator.new()
@export var largeEnemyScene: PackedScene
@export var mediumMonsterScene : PackedScene
@export var smallEnemyScene : PackedScene

var smallEnemyList = []
var mediumEnemyList = []
var largeEnemyList = []

var smallEnemyDelList = []
var medEnemyDelList = []
var lgEnemyDelList = []

var pingStarted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	visible = false
	$SubViewport/radar_ping/Ping.visible = false
	$SubViewport/radar_button.play("off")
	# sub position
	#sub.position.x = 256
	#sub.position.y = 448

func get_random_int_between(min_val, max_val):
	return rng.randi_range(min_val, max_val)

# Return 1 or -1
func get_random_direction():
	return (randi() & 2) - 1

func _on_spawn_timer_timeout():
	# Random Spawn Chance, 50% chance
	if get_random_int_between(1,2) == 1:
		var spawn_area = get_random_int_between(1,3)
		var monsterType = get_random_int_between(1,10)
		# Medium Monster
		if monsterType <= 4:
			match spawn_area:
			# top left -> right spawn
				1:
					var mediumMonster = mediumMonsterScene.instantiate()
					mediumMonster.position.x = get_random_int_between(0,8) * 64
					mediumMonster.position.y = 0
					add_child(mediumMonster)
					mediumEnemyList.push_back(mediumMonster)
				# top left -> bottom left
				2:
					var mediumMonster = mediumMonsterScene.instantiate()
					mediumMonster.position.x = 0
					mediumMonster.position.y = get_random_int_between(0,7) * 64
					add_child(mediumMonster)
					mediumEnemyList.push_back(mediumMonster)
				# top right -> bottom right
				3:
					var mediumMonster = mediumMonsterScene.instantiate()
					mediumMonster.position.x = 512
					mediumMonster.position.y = get_random_int_between(0,7) * 64
					add_child(mediumMonster)
					mediumEnemyList.push_back(mediumMonster)
		# Small Monster
		else: 
			match spawn_area:
				# top left -> right spawn
				1:
					var smallMonster = smallEnemyScene.instantiate()
					smallMonster.position.x = get_random_int_between(0,8) * 64
					smallMonster.position.y = 0
					add_child(smallMonster)
					smallEnemyList.push_back(smallMonster)
				# top left -> bottom left
				2:
					var smallMonster = smallEnemyScene.instantiate()
					smallMonster.position.x = 0
					smallMonster.position.y = get_random_int_between(0,7) * 64
					add_child(smallMonster)
					smallEnemyList.push_back(smallMonster)
				# top right -> bottom right
				3:
					var smallMonster = smallEnemyScene.instantiate()
					smallMonster.position.x = 512
					smallMonster.position.y = get_random_int_between(0,7) * 64
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
		
		if smallMonster.position.x == 256 && smallMonster.position.y == 448:
		# TODO: add function to trigger small or medium monsters to spawn on submarine
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
		
		if mediumMonster.position.x == 256 && mediumMonster.position.y == 448:
		# TODO: add function to trigger small or medium monsters to spawn on submarine
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
		
	
func _process(delta):
	if !Global.pingEnabled: 
		pingStarted = false
		$SubViewport/ping.stop()
	else: 
		startUpPing()
		pingStarted = true
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
	if Global.torpedoLaunched:
		enemy_on_torpedo_coords_check()
		Global.torpedoLaunched = false

func enemy_on_torpedo_coords_check():
	for i in smallEnemyList.size():
		var smallEnemy = smallEnemyList[i]
		if smallEnemy.position == Global.torpedoCoordinates:
			smallEnemyDelList.push_back(i)
			remove_child(smallEnemy)
			print('hit')
	for i in mediumEnemyList.size():
		var mediumEnemy = mediumEnemyList[i]
		if mediumEnemy.position == Global.torpedoCoordinates:
			medEnemyDelList.push_back(i)
			remove_child(mediumEnemy)
			print('hit')

func startUpPing():
	if !pingStarted:
		$SubViewport/ping.start()

func _on_lg_monster_timer_timeout():
	var spawn_area = get_random_int_between(1,3)
	# top left -> right spawn
	var largeEnemy = largeEnemyScene.instantiate()
	largeEnemy.position.x = get_random_int_between(0,8) * 64
	largeEnemy.position.y = 0
	add_child(largeEnemy)
	largeEnemyList.push_back(largeEnemy)
