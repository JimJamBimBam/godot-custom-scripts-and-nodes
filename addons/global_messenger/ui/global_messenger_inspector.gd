@tool
extends Control

const SCRIPT_PATH = "res://addons/global_messenger/src/game_event.gd"
const GAME_EVENT_TEMPLATE = "class_name GameEvent extends RefCounted\n\n"
const CONST_TEMPLATE = "const %s: String = %s"

@export var _removable_label_scene: PackedScene

@onready var _signal_names: Control = %signal_names
@onready var _add_global_signal_button: Button = %add_global_signal_button
@onready var _refresh_button: EButton = %refresh_button
@onready var _create_new_global_signal_dialog: CreateSignalDialog = %create_new_global_signal_dialog

var _game_event_script: Script
var _event_names: Array[String] = []


func _ready() -> void:
	_game_event_script = load(SCRIPT_PATH) as Script
	_game_event_script.property_list_changed.connect(_on_game_event_script_script_changed)
	_event_names = _get_game_events_from_script(_game_event_script)
	refresh_inspector()


func refresh_inspector() -> void:
	_refresh_global_events_list()


func _refresh_global_events_list() -> void:
	# Remove any children in the drawable list of Controls, so no double up occurs.
	for child in _signal_names.get_children():
		child.queue_free()
	# Find all events and make new labels to populate the inspector with.
	for event_name in _event_names:
		_create_new_event_label(event_name)


func _on_add_global_signal_button_pressed() -> void:
	_create_new_global_signal_dialog.show()
	_create_new_global_signal_dialog.text_input.grab_focus()


func _on_create_new_global_signal_dialog_text_submitted(new_text: String) -> void:
	if _event_names.has(new_text):
		printerr("Global signal already exists. Ignoring.")
		return
	
	if new_text.length() > 0:
		_event_names.append(new_text)
		var converted_text: String = _get_game_events_body()
		_write_text_to_file(converted_text, SCRIPT_PATH)
		_game_event_script.notify_property_list_changed()


func _on_refresh_button_pressed() -> void:
	refresh_inspector()


func _on_game_event_script_script_changed() -> void:
	refresh_inspector()


func _on_removeable_label_removed_pressed(text: String) -> void:
	_event_names.erase(text)
	var converted_text: String = _get_game_events_body()
	_write_text_to_file(converted_text, SCRIPT_PATH)
	_game_event_script.notify_property_list_changed()
	

func _get_game_events_from_script(script: Script) -> Array[String]:
	var constants: Array = script.get_script_constant_map().values()
	var temp_array: Array[String] = []
	# If there are no game events, ignore the rest.
	if constants.is_empty():
		return temp_array
	# Iterate through all the constants and append to _event_names array.
	for constant: String in constants:
		temp_array.append(constant)
	return temp_array


func _get_game_events_body() -> String:
	var return_text = ""
	for event_name in _event_names:
		return_text += (CONST_TEMPLATE % [event_name, "\"" + event_name + "\""]) + "\n"
	return return_text


func _write_text_to_file(text: String, file_path: String) -> void:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(GAME_EVENT_TEMPLATE + text)
	file.close()


func _create_new_event_label(label_name: String) -> void:
	var new_label = _removable_label_scene.instantiate() as RemoveableLabel
	new_label.name = label_name
	_signal_names.add_child(new_label)
	new_label.owner = self
	new_label.set_label_text(label_name)
	new_label.remove_pressed.connect(_on_removeable_label_removed_pressed)
