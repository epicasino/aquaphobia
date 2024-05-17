extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	play('default')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = Global.torpedoCoordinates.x
	position.y = Global.torpedoCoordinates.y
	
	if Global.torpedoLockedIn:
		play("locked_in")
	else: play("default")
