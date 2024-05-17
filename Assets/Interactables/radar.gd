extends Area2D

var inRadar = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inRadar && Input.is_action_just_pressed("interact"):
		$"radar-grid".visible = true
	if inRadar && Input.is_action_just_pressed("secondary_interact"):
		if !Global.pingEnabled:
			$'radar-grid'.get_node('SubViewport').get_node('radar_button').play('on')
			Global.pingEnabled = true
		else:
			$'radar-grid'.get_node('SubViewport').get_node('radar_button').play('off')
			Global.pingEnabled = false
	if inRadar && Input.is_action_just_pressed("cancel"):
		$"radar-grid".visible = false

func _on_body_entered(body):
	if body.name == 'Player':
		inRadar = true

func _on_body_exited(body):
	if body.name == 'Player':
		inRadar = false
