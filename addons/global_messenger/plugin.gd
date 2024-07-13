@tool
extends EditorPlugin

const GLOBAL_MESSENGER_PATH = "res://addons/global_messenger/nodes/global_messenger.gd"

var _global_messenger_inspector: Node

func _enter_tree() -> void:
	add_autoload_singleton("GlobalMessenger", GLOBAL_MESSENGER_PATH)
	
	_global_messenger_inspector = load("res://addons/global_messenger/src/global_messenger_inspector.tscn").instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, _global_messenger_inspector)

func _exit_tree() -> void:
	remove_autoload_singleton("GlobalMessenger")
	
	if is_instance_valid(_global_messenger_inspector):
		remove_control_from_docks(_global_messenger_inspector)
		_global_messenger_inspector.queue_free()
