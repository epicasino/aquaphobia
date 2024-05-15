extends Node2D

@onready var rng = RandomNumberGenerator.new()
#@export var largeEnemyScene: PackedScene
@export var mediumMonsterScene : PackedScene
@export var smallEnemyScene : PackedScene

var smallEnemyList = []
var mediumMonsterList = []
#var largeEnemyList = []

var smallEnemyDelList = []
var medEnemyDelList = []
var lgEnemyDelList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
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
					mediumMonsterList.push_back(mediumMonster)
				# top left -> bottom left
				2:
					var mediumMonster = mediumMonsterScene.instantiate()
					mediumMonster.position.x = 0
					mediumMonster.position.y = get_random_int_between(0,7) * 64
					add_child(mediumMonster)
					mediumMonsterList.push_back(mediumMonster)
				# top right -> bottom right
				3:
					var mediumMonster = mediumMonsterScene.instantiate()
					mediumMonster.position.x = 512
					mediumMonster.position.y = get_random_int_between(0,7) * 64
					add_child(mediumMonster)
					mediumMonsterList.push_back(mediumMonster)
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
	for i in mediumMonsterList.size():
		var mediumMonster = mediumMonsterList[i]
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

func _process(delta):
	if smallEnemyDelList.size() != 0:
		for i in smallEnemyDelList.size():
			smallEnemyList.remove_at(smallEnemyDelList[i])
		smallEnemyDelList = []
	if medEnemyDelList.size() != 0:
		for i in medEnemyDelList.size():
			mediumMonsterList.remove_at(medEnemyDelList[i])
		medEnemyDelList = []
