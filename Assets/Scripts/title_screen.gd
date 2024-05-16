extends Node2D

@export var offset = Vector2(0, -5)
@export var duration = 2.5

# Called when the node enters the scene tree for the first time.
func _ready():
	start_tween()

func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($"moving_title_text", 'position', offset, duration / 2)
	tween.tween_property($"moving_title_text", 'position', Vector2.ZERO, duration / 2)


func _on_start_pressed():
	Global.game_start = true


func _on_quit_pressed():
	get_tree().quit()
