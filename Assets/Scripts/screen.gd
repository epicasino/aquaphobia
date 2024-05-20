extends Area2D

@onready var text_box = $text_box
var playerInTerminal = false
var startedDialogue = false

var alreadyTalked = false

var dialogue = [
  {
	"day": 1,
	"dialogue": [
	  {
		"line": "[center]Hello, pilot.[/center]",
		"emotion": "hello1"
	  },
	  {
		"line": "[center]We picked up your distress signal...[/center]",
		"emotion": "explain1"
	  },
	  {
		"line": "[center]Stuck at the bottom of the ocean, huh?[/center]",
		"emotion": "question"
	  },
	  {
		"line": "[center]Don't worry. Help is on the way.[/center]",
		"emotion": "snarky1"
	  },
	  {
		"line": "[center]The rescue team will arrive in approximately four days.[/center]",
		"emotion": "long_explain"
	  },
	  {
		"line": "[center]I would recommend you active your sonar.[/center]",
		"emotion": "explain2"
	  },
	  {
		"line": "[center]The wildlife is particularly aggresive down there.[/center]",
		"emotion": "explain1"
	  },
	  {
		"line": "[center]Good luck.[/center]",
		"emotion": "short1"
	  }
	],
	"person": "Rescue Team"
  },
  {
	"day": 2,
	"dialogue": [
	  {
		"line": "[center]Hello, pilot.[/center]",
		"emotion": "hello2"
	  },
	  {
		"line": "[center]Things are going well—the recovery ship will be there soon.[/center]",
		"emotion": "ponder2"
	  },
	  {
		"line": "[center]If command weren't so lax we could be there now...[/center]",
		"emotion": "snarky2"
	  },
	  {
		"line": "[center]The admins would be [wave]scrambling[/wave] if it were [wave]one of them.[/wave][/center]",
		"emotion": "ponder3"
	  },
	  {
		"line": "[center]Hang tight for now.[/center]",
		"emotion": "short2"
	  }
	],
	"person": "Rescue Team"
  },
  {
	"day": 3,
	"dialogue": [
	  {
		"line": "[center]Hello again.[/center]",
		"emotion": "hello1"
	  },
	  {
		"line": "[center]We had some [wave]unexpected[/wave] delays[/center]",
		"emotion": "explain4"
	  },
	  {
		"line": "[center]I hope you have plenty of rations down there.[/center]",
		"emotion": "explain3"
	  },
	  {
		"line": "[center]If all goes as planned, we'll be there tomorrow.[/center]",
		"emotion": "explain2"
	  }
	],
	"person": "Rescue Team"
  },
  {
	"day": 4,
	"dialogue": [
	  {
		"line": "[center]Hail, pilot.[/center]",
		"emotion": "hello2"
	  },
	  {
		"line": "[center][wave]Bad news.[/wave][/center]",
		"emotion": "disappointed"
	  },
	  {
		"line": "[center]The engineers made the pod calculations for the [wave]imperial system.[/wave][/center]",
		"emotion": "explain3"
	  },
	  {
		"line": "[center][wave]Not[/wave] the [wave]metric system.[/wave][/center]",
		"emotion": "explain1"
	  },
	  {
		"line": "[center]The pod [wave]voilently[/wave] imploded at a depth of around 3,000 meters.[/center]",
		"emotion": "pod_destroyed"
	  },
	  {
		"line": "[center]I'm sorry...[/center]",
		"emotion": "short1"
	  },
	  {
		"line": "[center]I got the process expedited so we'll be there tomorrow.[/center]",
		"emotion": "positive1"
	  },
	  {
		"line": "[center]Until then, stay frosty.[/center]",
		"emotion": "ponder2"
	  }
	],
	"person": "Rescue Team"
  },
  {
	"day": 5,
	"dialogue": [
	  {
		"line": "[center]Salutations, pilot.[/center]",
		"emotion": "hello1"
	  },
	  {
		"line": "[center]The expedited barge is stirring up the water and is causing [wave]increased activity.[/wave][/center]",
		"emotion": "explain1"
	  },
	  {
		"line": "[center]It shouldn't be long now.[/center]",
		"emotion": "snarky1"
	  },
	  {
		"line": "[center]See you soon.[/center]",
		"emotion": "short1"
	  }
	],
	"person": "Rescue Team"
  }
]

func _ready():
	$AnimatedSprite2D.play("idle")
	text_box.visible = false
	$interact_label.visible = false

func _process(delta):
	if playerInTerminal:
		$interact_label.visible = true
	else:
		$interact_label.visible = false
	
	if playerInTerminal&&Input.is_action_pressed("interact")&&!startedDialogue:
		if !alreadyTalked:
			alreadyTalked = true
			get_parent().get_node('music').get_node('audio_transitions').play('cross_fade_sit_rep')
			text_box.visible = true
			startedDialogue = true
			text_box.display_messages(dialogue[Global.game_day - 1].dialogue, dialogue[Global.game_day - 1].person)

#"[center]" + "[wave]Hi[/wave] I was generated for the dialogue system test for the godot game engine" + "[/center]"

func _on_body_entered(body):
	if body.name == 'Player':
		playerInTerminal = true

func _on_body_exited(body):
	if body.name == 'Player':
		playerInTerminal = false

func _on_text_box_message_completed():
	# sit rep fade out
	get_parent().get_node('music').get_node('audio_transitions').play_backwards('cross_fade_sit_rep')
	$tv.play()
	#print('Message Completed')
	text_box.visible = false
	startedDialogue = false
	$AnimatedSprite2D.play("turn_off")
	
func _on_text_box_character_speech(character, emotion):
	#print(character)
	if character == 'Rescue Team':
		match emotion:
			'hello1':
				$hello1.play()
			'hello2':
				$hello2.play()
			'short1':
				$short1.play()
			'short2':
				$short2.play()
			'snarky1':
				$snarky1.play()
			'snarky2':
				$snarky2.play()
			'explain1':
				$explain1.play()
			'explain2':
				$explain2.play()
			'explain3':
				$explain3.play()
			'explain4':
				$explain4.play()
			'ponder1':
				$'ponder1'.play()
			'ponder2':
				$'ponder2'.play()
			'ponder3':
				$'ponder3'.play()
			'positive1':
				$'positive1'.play()
			'pod_destroyed':
				$'pod_destroyed'.play()
			'disappointed':
				$disappointed.play()
			'long_explain':
				$long_explain.play()
			'question':
				$question.play()
			

#func _on_animated_sprite_2d_animation_finished(animation):
	#if animation == 'turn_off':
		#$AnimatedSprite2D.play("off")
