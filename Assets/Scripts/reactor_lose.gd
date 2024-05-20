extends Node2D

var blowingUpReactor = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.youLose == 'reactor explode':
		if !blowingUpReactor:
			blowingUpReactor = true
			blowUpReactor()

func blowUpReactor():
	$reactor_meltdown.play()
	$reactor_explosion_animation.play("explode")

func _on_reactor_meltdown_finished():
	get_tree().change_scene_to_file('res://Assets/Levels/Lose/reactor_explosion_lose.tscn')
