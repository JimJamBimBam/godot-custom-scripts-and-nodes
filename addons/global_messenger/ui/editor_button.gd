@tool
class_name EButton extends Button

@export var icon_name: String:
	set(new_icon_name):
		icon_name = new_icon_name
		if Engine.is_editor_hint():
			icon = IconUtil.find_editor_icon(new_icon_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		icon = IconUtil.find_editor_icon(icon_name)
		self.flat = true
