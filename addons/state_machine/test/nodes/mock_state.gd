class_name MockState extends State

var tick_called: bool = false
var on_enter_called: bool = false
var on_exit_called: bool = false

func _get_class() -> String:
	return "MockState"


func _tick() -> void:
	pass


func _on_enter() -> void:
	on_enter_called = true


func _on_exit() -> void:
	on_exit_called = true
