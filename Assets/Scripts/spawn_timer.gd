extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	match Global.game_day:
		1:
			set_wait_time(15.0)
		2:
			set_wait_time(14.0)
		3:
			set_wait_time(13.0)
		4:
			set_wait_time(12.0)
		5:
			set_wait_time(10.5)
	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
