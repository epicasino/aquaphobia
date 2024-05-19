extends Path2D

@onready var rng = RandomNumberGenerator.new()

var warning = 0
var warningPhase = false
var attacking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var xPositionRange = get_random_int_between(845,928)
	position = Vector2(xPositionRange, -576)
	$AnimatableBody2D/AnimatedSprite2D.play("charging")

func get_random_int_between(min_val, max_val):
	return rng.randi_range(min_val, max_val)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !warningPhase:
		warning_noises()
		warningPhase = true

func warning_noises():
	# Plays two warning noises, on the third it charges down to ship
	if warning != 2:
		var screamIndex = get_random_int_between(0,3)
		var screamNoises = [$Sounds/scream1, $Sounds/scream2, $Sounds/scream3, $Sounds/scream4]
		screamNoises[screamIndex].play()
	else:
		$Sounds/charge.play()
		$"wind-up-timer".stop()
		$AnimationPlayer.play("move_down")
	
func _on_winduptimer_timeout():
	warning += 1
	warning_noises()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'move_down':
		$"attacking-timer".start()
		$"damage-timer".start()
		$AnimatableBody2D/AnimatedSprite2D.play("afk")
	
func _on_attackingtimer_timeout():
	if !attacking:
		$AnimatableBody2D/AnimatedSprite2D.play("drilling")
		attacking = true
		attacking_behavior()

func _on_damagetimer_timeout():
	Global.reactorHealth += 5 # TODO: damage reactor health here

func attacking_behavior():
	var drill_index = get_random_int_between(0,2)
	var drill_noises = [$Sounds/drill_1, $Sounds/drill_2, $Sounds/longdrill]
	drill_noises[drill_index].play()

func _on_scream_1_finished():
	$"wind-up-timer".start()

func _on_scream_2_finished():
	$"wind-up-timer".start()

func _on_scream_3_finished():
	$"wind-up-timer".start()

func _on_scream_4_finished():
	$"wind-up-timer".start()

func _on_drill_1_finished():
	attacking_behavior()

func _on_drill_2_finished():
	attacking_behavior()

func _on_longdrill_finished():
	attacking_behavior()
