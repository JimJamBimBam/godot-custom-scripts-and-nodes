## Abstract class that allows for enclosed functionality.
## Any necessary variables/references can be initialized in the extended class.
class_name State extends Node

## Overridable function for getting the class name is needed because GDScript does not return
## the correct name when calling the native function "get_class". 
## Use this instead to get the correct values.
## Currently not very scalable but is needed in Godot 4.1.
## Later versions will have something better I think.
func _get_class() -> String:
	return "State"


## [Override] Must be overriden.
## Will print an error to make it clear to the user that they are using it wrong.
func _tick() -> void:
	_print_not_inherited_msg()


## [Override] Must be overriden.
## Will print an error to make it clear to the user that they are using it wrong.
func _on_enter() -> void:
	_print_not_inherited_msg()


## [Override] Must be overriden.
## Will print an error to make it clear to the user that they are using it wrong.
func _on_exit() -> void:
	_print_not_inherited_msg()


## Internal error message to tell users that they should not be creating instances of this class.
func _print_not_inherited_msg() -> void:
	printerr("State is an abstract class that should not be instansiated. Please extend from this class instead.")
