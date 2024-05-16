extends Node2D

var crossfade : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.game_start && not crossfade:
		$audio_transitions.play("crossfade")
		crossfade = true
