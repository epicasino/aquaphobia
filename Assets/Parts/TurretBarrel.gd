extends Sprite2D

@onready var mainScene = get_tree().get_root().get_node('submarine_level')
@onready var projectile = load('res://Assets/Parts/bullet.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	shoot()
	rotation = 100

func shoot():
	var bullet = projectile.instantiate()
	bullet.dir = rotation
	bullet.spawnPos = global_position
	bullet.spawnRot = rotation
	bullet.zdex = z_index - 1
	mainScene.add_child.call_deferred(bullet)
