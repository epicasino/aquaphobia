extends Node2D

var hasSequenceStarted = false

@onready var rng = RandomNumberGenerator.new()
@onready var torpedo_noises = [ $torpedo_1, $torpedo_2, $torpedo_3 ]

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$torpedo_sprite.play("hatch-closed")
	
func get_random_int_between(min_val, max_val):
	return rng.randi_range(min_val, max_val)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.torpedoLaunched && !hasSequenceStarted:
		$torpedo_sprite.play("whole-torpedo-sequence")
		$torpedo_noise_delay.start()

func _on_torpedo_noise_delay_timeout():
	var randomIndex = get_random_int_between(0,2)
	torpedo_noises[randomIndex].play()

