extends Area2D

@onready var rng = RandomNumberGenerator.new()

var inEngine = false
var engineRepair = false
var btnHeldDown = false

@onready var repair_sounds = [$repair_sounds/hammer1, $repair_sounds/hammer2, 
$repair_sounds/hammer3, $repair_sounds/wrench1, $repair_sounds/wrench2, 
$repair_sounds/wrench3, $repair_sounds/wrench4]

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$AnimatedSprite2D.play("default")
	$reactor_health.visible = false
	$engine_hum.play()
	$damage_timer.start()

func get_random_int_between(min_val, max_val):
	return rng.randi_range(min_val, max_val)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inEngine:
		$interact_label.visible = true
	else:
		$interact_label.visible = false
	if engineRepair:
		$fixing_status.visible = true
	else:
		$fixing_status.visible = false
	
	if inEngine && Input.is_action_just_pressed('interact'):
		btnHeldDown = true
	if inEngine && Input.is_action_just_released("interact"):
		btnHeldDown = false
		
	if !engineRepair && btnHeldDown:
		engineRepair = true
		$repair_timer.start()
	if engineRepair && !btnHeldDown:
		engineRepair = false
		$repair_timer.stop()
		
	if !inEngine:
		$reactor_health.visible = false
	else:
		$reactor_health.visible = true
		
	if Global.reactorHealth == 100:
		Global.youLose = 'reactor explode'

func _on_body_entered(body):
	if body.name == 'Player':
		inEngine = true

func _on_body_exited(body):
	if body.name == 'Player':
		inEngine = false

func _on_repair_timer_timeout():
	var randomInt = get_random_int_between(0,6)
	if Global.reactorHealth - 5 < 0:
		Global.reactorHealth = 0
	else:
		Global.reactorHealth -= 5
	repair_sounds[randomInt].play()

func _on_damage_timer_timeout():
	Global.reactorHealth += 1
