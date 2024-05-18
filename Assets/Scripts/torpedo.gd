extends Node2D

var hasSequenceStarted = false

const sequence = ['torpedo-door-open', 'torpedo-launch', 'hatch-closing', 'hatch-closed']
var sequenceIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$torpedo_sprite.play("hatch-closed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.torpedoLaunched && !hasSequenceStarted:
		$torpedo_sprite.play("whole-torpedo-sequence")
