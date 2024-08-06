class_name Blackboard extends Node

## Blackboard is a local data store for a particular behaviour tree.
## Information is added and removed by nodes as the tree runs,
## allowing information to be shared.

const DEFAULT = "default"

@export var blackboard: Dictionary = {}:
	set(b):
		blackboard = b
		_data[DEFAULT] = blackboard

var _data: Dictionary = {}

func _ready() -> void:
	_data[DEFAULT] = blackboard


func keys() -> Array[String]:
	var keys: Array[String]
	keys.assign(_data.keys().duplicate())
	return keys


func set_value(key: Variant, value: Variant, blackboard_name: String = DEFAULT) -> void:
	if not _data.has(blackboard_name):
		_data[blackboard_name] = {}

	_data[blackboard_name][key] = value


func get_value(
	key: Variant, default_value: Variant = null, blackboard_name: String = DEFAULT) -> Variant:
	if has_value(key, blackboard_name):
		return _data[blackboard_name].get(key, default_value)
	return default_value


func has_value(key: Variant, blackboard_name: String = DEFAULT) -> bool:
	return (
		_data.has(blackboard_name)
		and _data[blackboard_name].has(key)
		and _data[blackboard_name][key] != null
	)


func erase_value(key: Variant, blackboard_name: String = DEFAULT) -> void:
	if _data.has(blackboard_name):
		_data[blackboard_name][key] = null
