extends CharacterBody2D


@export var speed : float = 200.0
@export var jump_velocity : float = -400.0
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var on_ladder = false

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("move_left", "move_right", 'move_up', "move_down")
	
	if direction:
		# freeze player if game has not started
		if not Global.game_start:
			velocity.x = 0
			velocity.y = 0
		# if player goes to radar and turns on the radar, freeze movement
		elif get_parent().get_node('radar').get_node('radar-grid').visible == true:
			velocity.x = 0
			velocity.y = 0
			# I made this while I had 1 and a half beers. Sets up the torpedo system and controls on the radar.
			if !Global.torpedoLockedIn:
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
		else:
			velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if on_ladder:
		if Input.is_action_pressed("move_up"):
			gravity = 0
			velocity.y = -speed
		elif Input.is_action_pressed("move_down"):
			gravity = 0
			velocity.y = speed
		else:
			velocity.y = 0

	move_and_slide()
	update_animate()
	update_facing_direction()

func update_animate():
	if not animation_locked:
		if direction.x != 0:
			if on_ladder && not is_on_floor():
				animated_sprite.play('climbing')
			else:
				animated_sprite.play('running')
		elif direction.y != 0 && not is_on_floor():
			animated_sprite.play('climbing')
		else:
			if on_ladder && not is_on_floor():
				animated_sprite.play('climbing')
			else: 
				animated_sprite.play('idle')

func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

func jump():
	velocity.y = jump_velocity
	animated_sprite.play('jump')
	animation_locked = true

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == 'jump':
		animation_locked = false

func _on_ladder_body_entered(body):
	on_ladder = true

func _on_ladder_body_exited(body):
	on_ladder = false
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
