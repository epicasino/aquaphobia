extends Path2D

@onready var rng = RandomNumberGenerator.new()

var onSub = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var xPositionRange = get_random_int_between(1952, 2000)
	position = Vector2(xPositionRange, 64)
	$crab/AnimatedSprite2D.play("swim")
	$crab_animations.play("move-to-sub")
	$Sounds/fiddle.play()

func get_random_int_between(min_val, max_val):
	return rng.randi_range(min_val, max_val)

func attack_behavior():
	var randomFiddle = get_random_int_between(0,2)
	var fiddles = [$Sounds/fiddle, $Sounds/fiddle2, $Sounds/fiddle3]
	fiddles[randomFiddle].play()
	Global.radarJammed = true
	$"attacking-timer".start()
	Global.reactorHealth += 2
	
func reset_behavior():
	onSub = false
	Global.radarJammed = false
	$'attacking-timer'.stop()
	$Sounds/fiddle.stop()
	$Sounds/fiddle2.stop()
	$Sounds/fiddle3.stop()

func _on_crab_animations_animation_finished(anim_name):
	if anim_name == 'move-to-sub':
		onSub = true
		Global.radarJammed = true
		attack_behavior()
	if anim_name == 'move-out-sub':
		call_deferred("free")

func _on_attackingtimer_timeout():
	if onSub && Global.radarJammed:
		attack_behavior()
	else:
		flee()
		
func flee():
	reset_behavior()
	$crab/AnimatedSprite2D.play("transition")
	$crab_animations.play("move-out-sub")
