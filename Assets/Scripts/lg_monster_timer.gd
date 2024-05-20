extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.game_day > 2:
		match Global.game_day:
			3:
				set_wait_time(150.0)
			4:
				set_wait_time(100.0)
			5:
				set_wait_time(60.0)
		start()
		print(time_left)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
