extends AudioStreamPlayer2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.game_start:
		$fade_out.play("fade_out")
		

func _on_fade_out_animation_finished(anim_name):
	stop()
