extends Area2D

@onready var text_box = $text_box
var playerInTerminal = false
var startedDialogue = false

func _ready():
	$AnimatedSprite2D.play("idle")
	text_box.visible = false

func _process(delta):
	if playerInTerminal && Input.is_action_pressed("interact") && !startedDialogue:
		text_box.visible = true
		startedDialogue = true
		$AnimatedSprite2D.play("talking")
		text_box.display_messages(
			["[center]Hello pilot.[/center]",
			"[center]We picked up your distress signal...[/center]",
			"[center]Stuck at the bottom of the ocean, huh?[center]",
			"[center]Don't worry. Help is on the way.[/center]",
			"[center]The ETA of the rescue team will be five days.[/center]",
			"[center]I would recommend you activate your sonar and stay on your toes down there.[/center]",
			"[center]Best of luck...[/center]"
			], 'Rescue Team')

#"[center]" + "[wave]Hi[/wave] I was generated for the dialogue system test for the godot game engine" + "[/center]"

func _on_body_entered(body):
	if body.name == 'Player':
		playerInTerminal = true

func _on_body_exited(body):
	if body.name == 'Player':
		playerInTerminal = false

func _on_text_box_message_completed():
	#print('Message Completed')
	text_box.visible = false
	startedDialogue = false
	$AnimatedSprite2D.play("turn_off")
	
func _on_text_box_character_speech(character, emotion):
	#print(character)
	if character == 'Rescue Team':
		match emotion:
			'Hello':
				$rescue_hello.play()
			'Explain':
				$rescue_explain.play()

#func _on_animated_sprite_2d_animation_finished(animation):
	#if animation == 'turn_off':
		#$AnimatedSprite2D.play("off")

