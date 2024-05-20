extends Node2D

var rng = RandomNumberGenerator.new()
@onready var gunSounds = [$left_gun1, $left_gun2]

func get_random_int_between(min_val, max_val):
	return rng.randi_range(min_val, max_val)

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_weapons_system_left_turret_selected():
	$AnimationPlayer.play("gun-to-left")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'gun-to-left':
		$Timer.start()

func _on_timer_timeout():
	var randomInt = get_random_int_between(0,1)
	$TurretBarrel.shoot()
	gunSounds[randomInt].play() 
	

func _on_weapons_system_left_turret_stop():
	$Timer.stop()
	$AnimationPlayer.play("left-back-to-normal")
