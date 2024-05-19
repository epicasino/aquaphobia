extends CharacterBody2D

var dir : float
var spawnPos : Vector2
var spawnRot : float
var zdex : int

@export var speed = 1000.0

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	z_index = zdex
	
func _physics_process(delta):
	velocity = Vector2(0, -speed).rotated(dir)
	move_and_slide()


func _on_area_2d_body_entered(body):
	print('HIT')
	queue_free()


func _on_timer_timeout():
	queue_free()
