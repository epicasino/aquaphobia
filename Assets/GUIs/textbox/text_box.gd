extends MarginContainer

@onready var richText = $MarginContainer/RichTextLabel
@onready var type_timer = $type_timer
@onready var wait_timer = $wait_timer

signal message_completed

func update_message(message: String):
	richText.bbcode_text = _extract_tags(message)
	richText.visible_characters = 0
	for i in richText.text:
		wait_timer.wait_time += 0.05
	type_timer.start()
	wait_timer.start()

func _on_type_timer_timeout():
	if richText.visible_characters < richText.text.length():
		richText.visible_characters += 1
	else:
		type_timer.stop()

func _extract_tags(source_string: String):
	var _custom_regex = RegEx.new()
	_custom_regex.compile("({(.*?)})")
	return _custom_regex.sub(source_string, "", true)

func _on_wait_timer_timeout():
	message_completed.emit()
