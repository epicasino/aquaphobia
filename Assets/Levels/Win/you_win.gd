extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade")
	$dolphin_timer.start()
	$AnimatedSprite2D.play("default")

func _on_dolphin_timer_timeout():
	$AnimationPlayer.play("dolphin_moves")
