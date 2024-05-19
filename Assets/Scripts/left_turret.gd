extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_weapons_system_left_turret_selected():
	$AnimationPlayer.play("gun-to-left")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'gun-to-left':
		$Timer.start()

func _on_timer_timeout():
	$TurretBarrel.shoot()

func _on_weapons_system_left_turret_stop():
	$Timer.stop()
	$AnimationPlayer.play("left-back-to-normal")
