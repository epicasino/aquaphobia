extends Area2D

var inRadar = false
var openedRadar = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inRadar && !openedRadar && Input.is_action_just_pressed("interact"):
		$"radar-grid".visible = true
		openedRadar = true
	elif inRadar && openedRadar && Input.is_action_just_pressed("interact"):
		if Global.torpedoLockedIn == true:
			Global.torpedoLockedIn = false
		else:
			Global.torpedoLockedIn = true
	if inRadar && Input.is_action_just_pressed("secondary_interact"):
		if !Global.pingEnabled:
			$'radar-grid'.get_node('SubViewport').get_node('radar_button').play('on')
			Global.pingEnabled = true
		else:
			$'radar-grid'.get_node('SubViewport').get_node('radar_button').play('off')
			Global.pingEnabled = false
	if inRadar && Input.is_action_just_pressed("cancel"):
		$"radar-grid".visible = false
		openedRadar = false
	
	if Global.torpedoLaunched:
		Global.torpedoLockedIn = false
	
	radar_torpedo_controls()

# I made this while I had 1 and a half beers. Sets up the torpedo system and controls on the radar.
func radar_torpedo_controls():
	if !Global.torpedoLockedIn && $"radar-grid".visible:
		if Input.is_action_just_pressed("move_up"):
			if Global.torpedoCoordinates.y > 0:
				Global.torpedoCoordinates.y -= 64
		if Input.is_action_just_pressed("move_down"):
			if Global.torpedoCoordinates.y < 448:
				Global.torpedoCoordinates.y += 64
		if Input.is_action_just_pressed("move_left"):
			if Global.torpedoCoordinates.x > 0:
				Global.torpedoCoordinates.x -= 64
		if Input.is_action_just_pressed("move_right"):
			if Global.torpedoCoordinates.x < 512:
				Global.torpedoCoordinates.x += 64

func _on_body_entered(body):
	if body.name == 'Player':
		inRadar = true

func _on_body_exited(body):
	if body.name == 'Player':
		inRadar = false
