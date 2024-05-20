extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_big_one_timer_timeout():
	$big_one.play("jumpscare")
	$big_one_sound.play()

func _on_big_one_animation_finished():
	$big_one_sound.stop()
	$big_one.visible = false
	$fade_in.play("fade_in")

func _on_quit_pressed():
	get_tree().quit()

func _on_start_again_pressed():
	Global.youLose = null
	Global.first_playthrough = false
	Global.game_start = true
	Global.pingEnabled = false
	Global.gunLockedIn = false
	Global.torpedoCoordinates = Vector2(256, 448)
	Global.torpedoLockedIn = false
	Global.radarJammed = false
	Global.reactorHealth = 0
	#get_tree().get_root().get_node('submarine_level').get_tree().reload_current_scene()
	get_tree().change_scene_to_file('res://Assets/Levels/submarine_level.tscn')
