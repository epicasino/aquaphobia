extends Camera2D

@export var TargetNode : Node2D = null

var game_start_zoom = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.game_start && Global.first_playthrough:
		set_position(TargetNode.get_position())
		if (!game_start_zoom):
			$AnimationPlayer.play("Zoom")
		game_start_zoom = true
	elif !Global.first_playthrough:
		set_position(TargetNode.get_position())
		if (!game_start_zoom):
			$AnimationPlayer.play("Zoom")
		game_start_zoom = true
