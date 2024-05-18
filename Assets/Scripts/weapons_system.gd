extends Area2D

var inWeaponsTerminal = false
var usingTerminal = false

var torpedoChoice = 'no'
var torpedoLock = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$weapons_gui.visible = false
	$torpedo_ui.visible = false
	$torpedo_ui/torpedo_confirm.play('select')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inWeaponsTerminal && Input.is_action_just_pressed("interact"):
		if usingTerminal && $torpedo_ui.visible:
			start_torpedo_launch()
		elif usingTerminal && $weapons_gui.visible:
			if !Global.gunLockedIn:
				Global.gunLockedIn = true
				$weapons_gui/guns_terminal_select.play("selected")
			else: 
				Global.gunLockedIn = false
				$weapons_gui/guns_terminal_select.play("default")
		else:
			get_weapon_screen()
	if inWeaponsTerminal && Input.is_action_just_pressed("secondary_interact"):
		switch_weapon_screen()
	if inWeaponsTerminal && Input.is_action_just_pressed("cancel"):
		$weapons_gui.visible = false
		$torpedo_ui.visible = false
		usingTerminal = false
	
	weapons_contols()
	set_gun_position()

func start_torpedo_launch():
	if torpedoChoice == 'yes' && Global.torpedoLockedIn:
		Global.torpedoLaunched = true
		torpedoLock = true
		$torpedo_ui/torpedo_confirm.play('confirm')
		$torpedo_wait_timer.start()
	if torpedoChoice == 'no':
		Global.torpedoLaunched = false
		Global.torpedoLockedIn = false
		torpedoLock = true
		$torpedo_ui/torpedo_confirm.play('confirm')
		$torpedo_wait_timer.start()
		

func switch_weapon_screen():
	if !Global.chosenWeapon:
		$weapons_gui.visible = false
		$torpedo_ui.visible = true
		Global.chosenWeapon = true
	else:
		$weapons_gui.visible = true
		$torpedo_ui.visible = false
		Global.chosenWeapon = false

func get_weapon_screen():
	if !Global.chosenWeapon:
		$weapons_gui.visible = true
		$torpedo_ui.visible = false
		usingTerminal = true
	else:
		$weapons_gui.visible = false
		$torpedo_ui.visible = true
		usingTerminal = true

func set_gun_position():
	if !Global.gunPosition:
		$weapons_gui/guns_terminal_select.position.x = 0
		$weapons_gui/guns_terminal_select.visible = true
	else:
		$weapons_gui/guns_terminal_select.position.x = 288
		$weapons_gui/guns_terminal_select.visible = true

func set_torpedo_button(option: bool):
	if option:
		$torpedo_ui/torpedo_confirm.position.x = 432
		$torpedo_ui/torpedo_confirm.position.y = 448
		torpedoChoice = 'no'
	else:
		$torpedo_ui/torpedo_confirm.position.x = 144
		$torpedo_ui/torpedo_confirm.position.y = 448
		torpedoChoice = 'yes'

func weapons_contols():
	if !Global.chosenWeapon:
		if Input.is_action_just_pressed("move_left") && !Global.gunLockedIn:
			Global.gunPosition = false
		if Input.is_action_just_pressed("move_right") && !Global.gunLockedIn:
			Global.gunPosition = true
	else: 
		if Input.is_action_just_pressed("move_left") && !torpedoLock:
			set_torpedo_button(false)
		if Input.is_action_just_pressed("move_right") && !torpedoLock:
			set_torpedo_button(true)

func _on_body_entered(body):
	if body.name == 'Player':
		inWeaponsTerminal = true

func _on_body_exited(body):
	if body.name == 'Player':
		inWeaponsTerminal = false

func _on_torpedo_wait_timer_timeout():
	$weapons_gui.visible = false
	$torpedo_ui.visible = false
	$torpedo_ui/torpedo_confirm.play('select')
	torpedoLock = false
	usingTerminal = false
