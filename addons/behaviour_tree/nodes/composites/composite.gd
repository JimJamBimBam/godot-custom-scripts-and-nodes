class_name Composite extends BTNode

## Composite node controls the flow of its children in a specific way.

var running_child: BTNode = null

# TODO: Implement warnings, such as:
# - Composite node should have at least two nodes as children otherwise it is useless.

# TODO: Implement base logic for interrupt() method.
func interrupt(actor: Node, blackboard: Blackboard) -> void:
	pass


# TODO: Implement base logic for after_run() method.
func after_run(actor: Node, blackboard: Blackboard) -> void:
	pass


# TODO: Implement get_class_name() method.
func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"Composite")
	return classes
