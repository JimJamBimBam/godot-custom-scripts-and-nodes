@tool
class_name RemoveableLabel extends Control

signal remove_pressed(to_remove_text: String)

@onready var label: Label = %label
@onready var _label: Label = %label
@onready var _remove: Button = %remove

func _ready():
	if Engine.is_editor_hint():
		_remove.icon = IconUtil.find_editor_icon("Remove")


func set_label_text(text: String) -> void:
	_label.text = text


func _on_remove_pressed() -> void:
	remove_pressed.emit(_label.text)
	self.queue_free()
