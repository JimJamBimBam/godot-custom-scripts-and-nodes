# meta-name: State
# meta-description: Generic template for scripts that want to extend State.gd
# meta-default: true
# meta-space-indent: 4

extends State

## Overridable function for getting the class name is needed because GDScript does not return
## the correct name when calling the native function "get_class". 
## Use this instead to get the correct values.
## Currently not very scalable but is needed in Godot 4.1.
## Later versions will have something better I think.
func _get_class() -> String:
	return "_CLASS_"

## Allows variables to be assigned to on initialization.
## Does not show up in base script state.gd because inheritence in Godot does not allow overrides.
## Set up custom inputs per extended class.
func set_state_values() -> void:
	pass


## Do not remove or Godot will call the super (base) class, which has warning for trying to use it.
func _tick() -> void:
	pass

## Do not remove or Godot will call the super (base) class, which has warning for trying to use it.
func _on_enter() -> void:
	pass

## Do not remove or Godot will call the super (base) class, which has warning for trying to use it.
func _on_exit() -> void:
	pass

