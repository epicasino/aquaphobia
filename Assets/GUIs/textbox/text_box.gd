extends MarginContainer

@onready var richText = $MarginContainer/RichTextLabel
@onready var type_timer = $type_timer
@onready var wait_timer = $wait_timer

signal message_completed
signal character_speech(character: String, emotion: String)

var messages_index = 0
var messages_array
var character_talking

func display_messages(messages, character: String):
	messages_index = 0
	messages_array = messages
	character_talking = character
	if character_talking == 'Rescue Team':
		message_sequence(messages_array[messages_index].line, messages_array[messages_index].emotion)
	
func message_sequence(message: String, emotion: String):
	if messages_index < messages_array.size():
		if character_talking == 'Rescue Team':
				character_speech.emit('Rescue Team', emotion)
				update_message(message)
		#else: update_message(message)

func update_message(message: String):
	richText.bbcode_text = _extract_tags(message)
	richText.visible_characters = 0
	#for i in richText.text:
		#wait_timer.wait_time += 0.15
	type_timer.start()

func _on_type_timer_timeout():
	if richText.visible_characters < richText.text.length():
		richText.visible_characters += 1
	else:
		type_timer.stop()
		wait_timer.start()

func _extract_tags(source_string: String):
	var _custom_regex = RegEx.new()
	_custom_regex.compile("({(.*?)})")
	return _custom_regex.sub(source_string, "", true)

func _on_wait_timer_timeout():
	#wait_timer.wait_time = 1
	messages_index += 1
	if messages_index < messages_array.size():
		message_sequence(messages_array[messages_index].line, messages_array[messages_index].emotion)
	else:
		message_completed.emit()
