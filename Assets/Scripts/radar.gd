extends Area2D

var inRadar = false
var openedRadar = false

var jamming_radar = false
var stop_jam = false

signal spawn_small_enemy
signal spawn_medium_enemy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inRadar:
		$interact_label.visible = true
	else: 
		$interact_label.visible = false
	
	if inRadar && !openedRadar && Input.is_action_just_pressed("interact"):
		$"radar-grid".visible = true
		openedRadar = true
	elif inRadar && openedRadar && Input.is_action_just_pressed("interact"):
		if Global.torpedoLockedIn == true:
			Global.torpedoLockedIn = false
		else:
			Global.torpedoLockedIn = true
	if inRadar && openedRadar && Input.is_action_just_pressed("secondary_interact"):
		if !Global.pingEnabled:
			$'radar-grid'.get_node('SubViewport').get_node('radar_button').play('on')
			Global.pingEnabled = true
			# Turns off day 1 grace period, monsters will start spawning after this is false
			Global.day_1_grace_period = false
		else:
			$'radar-grid'.get_node('SubViewport').get_node('radar_button').play('off')
			Global.pingEnabled = false
	if inRadar && Input.is_action_just_pressed("cancel"):
		$"radar-grid".visible = false
		openedRadar = false
	
	if Global.torpedoLaunched:
		Global.torpedoLockedIn = false
	
	if Global.radarJammed:
		if !jamming_radar:
			jamming_radar = true
			jam_radar()
	
	if !Global.pingEnabled && jamming_radar:
		if !stop_jam:
			stop_jam = true
			$regular_radar_timer.start()
	else: 
		stop_jam = false
		$regular_radar_timer.stop()
	
	radar_torpedo_controls()

func jam_radar():
	$"radar-grid/jammed_radar".visible = true
	$"radar-grid/jammed_radar".play("jammed")
	$jammed_radar_noise.play()

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

func _on_radargrid_spawn_small_monster():
	spawn_small_enemy.emit()

func _on_radargrid_spawn_med_monster():
	spawn_medium_enemy.emit()

func _on_regular_radar_timer_timeout():
	if !Global.pingEnabled:
		Global.radarJammed = false
		jamming_radar = false
		stop_jam = false
		$"radar-grid/jammed_radar".visible = false
		$"radar-grid/jammed_radar".stop()
		$jammed_radar_noise.stop()
