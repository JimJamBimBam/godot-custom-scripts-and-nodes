class_name ExampleState extends State


func _get_class() -> String:
	return "ExampleState"


func _tick() -> void:
	print(_get_class())
