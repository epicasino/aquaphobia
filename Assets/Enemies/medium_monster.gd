extends Path2D

@onready var rng = RandomNumberGenerator.new()

var warning = 0

var warningPhase = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$AnimatableBody2D/AnimatedSprite2D.play("charging")

func get_random_int_between(min_val, max_val):
	return rng.randi_range(min_val, max_val)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !warningPhase:
		warning_noises()
		warningPhase = true

func warning_noises():
	if warning != 2:
		var drill_noise = get_random_int_between(1,4)
		match drill_noise:
			1:
				$Sounds/scream1.play()
			2:
				$Sounds/scream2.play()
			3:
				$Sounds/scream3.play()
			4:
				$Sounds/scream4.play()
	else:
		$Sounds/charge.play()
		$"wind-up-timer".stop()
		$AnimationPlayer.play("move_down")
	
func _on_winduptimer_timeout():
	warning += 1
	warning_noises()

func _on_scream_1_finished():
	$"wind-up-timer".start()

func _on_scream_2_finished():
	$"wind-up-timer".start()

func _on_scream_3_finished():
	$"wind-up-timer".start()

func _on_scream_4_finished():
	$"wind-up-timer".start()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'move_down':
		$AnimatableBody2D/AnimatedSprite2D.play("drilling")
