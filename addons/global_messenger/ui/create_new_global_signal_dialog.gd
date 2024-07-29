@tool
class_name CreateSignalDialog extends Window

signal text_submitted(new_text: String)

var text_input: LineEdit:
	get:
		return _text_input

@onready var _text_input: LineEdit = %text_input

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


func _on_text_input_text_submitted(new_text: String) -> void:
	# Sanitise text to be consistent when used in other processes.
	var sanitised_text := _sanitise_text_input(new_text)
	print(sanitised_text)
	
	text_submitted.emit(sanitised_text)
	_text_input.clear()
	hide()


func _on_close_requested() -> void:
	hide()


func _sanitise_text_input(text: String) -> String:
	text = text.strip_edges()
	text = text.strip_escapes()
	text = text.replace(" ", "_")
	text = text.to_upper()
	return text
