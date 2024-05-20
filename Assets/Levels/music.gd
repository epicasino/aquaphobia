extends Node2D

var crossfade : bool = false

func _ready():
	$main_menu_music.play()
	$ambience_music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Global.first_playthrough:
		$ambience_music.volume_db = -30
		$main_menu_music.stop()
	elif Global.game_start && not crossfade:
		$audio_transitions.play("crossfade")
		crossfade = true
	

func _on_reactor_explosion_animation_animation_started(anim_name):
	if anim_name == 'explode':
		$ambience_music.stop()
