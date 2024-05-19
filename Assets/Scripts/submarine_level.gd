extends Node2D

var smallDeadEnemyIndex = 0
var smallEnemiesInKillzone = []

var medFleeEnemyIndex = 0
var medEnemiesInKillzone = []

var delSmallEnemies = []
var delMedEnemies = []

var medEnemyScene = preload('res://Assets/Enemies/medium_monster.tscn')
var smallEnemyScene = preload('res://Assets/Enemies/small_monster.tscn')

func _on_radar_spawn_small_enemy():
	var smallEnemy = smallEnemyScene.instantiate()
	add_child(smallEnemy)

func _on_radar_spawn_medium_enemy():
	var medEnemy = medEnemyScene.instantiate()
	add_child(medEnemy)

func _on_area_2d_body_entered(body):
	if body.name == 'AnimatedShark':
		medEnemiesInKillzone.push_back(body)
	if body.name == 'crab':
		smallEnemiesInKillzone.push_back(body)
	
func _on_weapons_system_gun_position_locked():
	if !Global.gunPosition && medEnemiesInKillzone.size() != 0:
		fleeMedEnemies()
	elif Global.gunPosition && smallEnemiesInKillzone.size() != 0:
		blowUpSmallEnemies()

func blowUpSmallEnemies():
	if smallDeadEnemyIndex < smallEnemiesInKillzone.size():
		$timers/smallEnemyFleeTimer.start()

func fleeMedEnemies():
	if medFleeEnemyIndex < medEnemiesInKillzone.size():
		$timers/medEnemyFleeTimer.start()

func _on_med_enemy_flee_timer_timeout():
	medEnemiesInKillzone[medFleeEnemyIndex].get_parent().reset_behaviors()
	medEnemiesInKillzone[medFleeEnemyIndex].get_parent().get_node('Sounds').get_node('hurt1').play()
	medEnemiesInKillzone[medFleeEnemyIndex].get_parent().get_node('AnimationPlayer').play('flee')
	delMedEnemies.push_back(medFleeEnemyIndex)
	medFleeEnemyIndex += 1
	fleeMedEnemies()
	
func _on_small_enemy_flee_timer_timeout():
	smallEnemiesInKillzone[smallDeadEnemyIndex].get_parent().reset_behavior()
	smallEnemiesInKillzone[smallDeadEnemyIndex].get_parent().get_node('Sounds').get_node('deathrattle').play()
	smallEnemiesInKillzone[smallDeadEnemyIndex].get_node('AnimatedSprite2D').play('explode')
	delSmallEnemies.push_back(smallDeadEnemyIndex)
	smallDeadEnemyIndex += 1
	blowUpSmallEnemies()

func _on_garbage_timer_timeout():
	if delSmallEnemies.size() != 0:
		for i in delSmallEnemies.size():
			var smallEnemy = delSmallEnemies[i]
			remove_child(smallEnemiesInKillzone[smallEnemy])
			smallEnemiesInKillzone.remove_at(smallEnemy)
		delSmallEnemies = []
		smallDeadEnemyIndex -= 1
	if delMedEnemies.size() != 0:
		for i in delMedEnemies.size():
			remove_child(medEnemiesInKillzone[delMedEnemies[i]])
			medEnemiesInKillzone.remove_at(delMedEnemies[i])
		delMedEnemies = []
		medFleeEnemyIndex -= 1
