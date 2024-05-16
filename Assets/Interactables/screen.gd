extends Area2D

@onready var text_box = $text_box
var playerInTerminal = false

func _ready():
	$AnimatedSprite2D.play("idle")

func _process(delta):
	if playerInTerminal && Input.is_action_pressed("interact"):
		$turn_on_timer.start()

func _on_body_entered(body):
	if body.name == 'Player':
		playerInTerminal = true

func _on_body_exited(body):
	if body.name == 'Player':
		playerInTerminal = false

func _on_text_box_message_completed():
	print('hello')
	$AnimatedSprite2D.play("turn_off")

func _on_turn_on_timer_timeout():
	$officer_hello.play()
	$AnimatedSprite2D.play("talking")
	text_box.update_message("[center]" + "[wave]Hi[/wave] I was generated for the dialogue system test for the godot game engine" + "[/center]")

#func _on_animated_sprite_2d_animation_finished(animation):
	#if animation == 'turn_off':
		#$AnimatedSprite2D.play("off")
