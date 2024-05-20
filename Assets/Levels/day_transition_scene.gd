extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.game_day += 1
	$day_label.text = 'Day ' + str(Global.game_day)
	$AnimationPlayer.play("text-fade")
	$day_transition.play()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'text-fade':
		Global.first_playthrough = false
		#Global.game_day += 1
		Global.game_start = true
		Global.pingEnabled = false
		Global.torpedoCoordinates = Vector2(256, 448)
		Global.torpedoLockedIn = false
		Global.radarJammed = false
		Global.reactorHealth = 0
		#get_tree().get_root().get_node('submarine_level').get_tree().reload_current_scene()
		get_tree().change_scene_to_file('res://Assets/Levels/submarine_level.tscn')
