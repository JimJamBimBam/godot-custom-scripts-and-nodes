class_name IconUtil extends RefCounted

## Function to find and return the editor icon that matches the given input string.
## Note: Only works in editor.
static func find_editor_icon(icon_name: String) -> Texture2D:
	# Get internal GUI base.
	var gui_base = EditorInterface.get_base_control()
	# Get icon from the base control.
	return gui_base.get_theme_icon(icon_name, "EditorIcons")
