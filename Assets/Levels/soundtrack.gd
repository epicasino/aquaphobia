extends Node2D

var crossFade = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.game_start && not crossFade:
		$fade_in_out.play("crossfade")
		crossFade = true
