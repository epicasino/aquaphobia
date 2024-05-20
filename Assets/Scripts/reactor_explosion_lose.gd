extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade_in_text")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().quit()

func _on_start_again_pressed():
	Global.youLose = null
	Global.first_playthrough = false
	Global.gunLockedIn = false
	Global.game_start = true
	Global.pingEnabled = false
	Global.torpedoCoordinates = Vector2(256, 448)
	Global.torpedoLockedIn = false
	Global.radarJammed = false
	Global.reactorHealth = 0
	#get_tree().get_root().get_node('submarine_level').get_tree().reload_current_scene()
	get_tree().change_scene_to_file('res://Assets/Levels/submarine_level.tscn')
