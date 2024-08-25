class_name Composite extends BTNode

## Composite node controls the flow of its children in a specific way.

var running_child: BTNode = null


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = super._get_configuration_warnings()
	
	if get_children().filter(func(x): return x is BTNode).size() < 2:
		warnings.append(
			"Composite node should have at least two children. Otherwise it is useless."
		)
	
	return warnings


func interrupt(actor: Node, blackboard: Blackboard) -> void:
	if running_child != null:
		running_child.interrupt(actor, blackboard)
		running_child = null


func after_run(actor: Node, blackboard: Blackboard) -> void:
	running_child = null


func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"Composite")
	return classes
